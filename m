Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:51076 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756474AbdJJRHz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Oct 2017 13:07:55 -0400
Subject: Re: [PATCH] btrfs: fix max chunk size on dup
To: dsterba@suse.cz, Naohiro Aota <naohiro.aota@wdc.com>,
        linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com
References: <150666965116.9802.15216393306253897797.stgit@naota.dhcp.fujisawa.hgst.com>
 <20171010113119.GJ3521@suse.cz>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <11a2b79c-4eda-ff80-0ad4-53065919be01@mendix.com>
Date: Tue, 10 Oct 2017 19:07:53 +0200
MIME-Version: 1.0
In-Reply-To: <20171010113119.GJ3521@suse.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/10/2017 01:31 PM, David Sterba wrote:
> Hi,
> 
> On Fri, Sep 29, 2017 at 04:20:51PM +0900, Naohiro Aota wrote:
>> Balancing a fresh METADATA=dup btrfs file system (with size < 50G)
>> generates a 128MB sized block group. While we set max_stripe_size =
>> max_chunk_size = 256MB, we get this half sized block group:
>>
>> $ btrfs ins dump-t -t CHUNK_TREE btrfs.img|grep length
>>                 length 8388608 owner 2 stripe_len 65536 type DATA
>>                 length 33554432 owner 2 stripe_len 65536 type SYSTEM|DUP
>>                 length 134217728 owner 2 stripe_len 65536 type METADATA|DUP
>>
>> Before commit 86db25785a6e ("Btrfs: fix max chunk size on raid5/6"), we
>> used "stripe_size * ndevs > max_chunk_size * ncopies" to check the max
>> chunk size. Since stripe_size = 256MB * dev_stripes (= 2) = 512MB, ndevs
>> = 1, max_chunk_size = 256MB, and ncopies = 2, we allowed 256MB
>> METADATA|DUP block group.
>>
>> But now, we use "stripe_size * data_stripes > max_chunk_size". Since
>> data_stripes = 1 on DUP, it disallows the block group to have > 128MB.
>> What missing here is "dev_stripes". Proper logical space used by the block
>> group is "stripe_size * data_stripes / dev_stripes". Tweak the equations to
>> use the right value.
> 
> I started looking into it and still don't fully understand it. Change
> deep in the allocator can easily break some blockgroup combinations, so
> I'm rather conservative here.

I think that the added usage of data_stripes in 86db25785a6e is the
problematic change. data_stripes is something that was introduced as
part of RAID56 in 53b381b3a and clearly only has a meaning that's
properly thought of for RAID56. The RAID56 commit already adds "this
will have to be fixed for RAID1 and RAID10 over more drives", only the
author doesn't catch the DUP case, which already breaks at that point.

At the beginning it says:

int data_stripes; /* number of stripes that count for block group size */

For the example:

This is DUP:

.sub_stripes    = 1,
.dev_stripes    = 2,
.devs_max       = 1,
.devs_min       = 1,
.tolerated_failures = 0,
.devs_increment = 1,
.ncopies        = 2,

In the code:

max_stripe_size = SZ_256M
max_chunk_size = max_stripe_size    -> SZ_256M

Then we have find_free_dev_extent:
    max_stripe_size * dev_stripes   -> SZ_256M * 2 -> 512M

So we like to find 512M on a disk, to stuff 2 stripes of 256M inside for
the DUP. (remember: The two parts of DUP *never* end up on a different
disk, even if you have multiple)

If we find one:
stripe_size = devices_info[ndevs-1].max_avail   -> 512M, yay

ndevs = min(ndevs, devs_max)      -> min($whatever, 1)   -> 1
num_stripes = ndevs * dev_stripes -> 1 * 2  -> 2

data_stripes = num_stripes / ncopies = 2 / 2 = 1

BOOM! There's the problem. The data_stripes only thinks about data that
is horizontally spread over disks, and not vertically spread...

What I would propose is changing...
   the data_stripes = <blah> and afterwards trying to correct it with
some ifs
...to...
   a switch/case thing where the explicit logic is put to get the right
value for each specific raid type.

In case of DUP this simply means data_stripes = 2, because there is no
need for fancy calculations about spreading DUP data over X devices.
It's always 2 copies on 1 device.

...

My general feeling when looking at the code, is that this single part of
code is responsible for too many different cases, or, more possible
cases than a developer can reason about at once "in his head" when
working on it.

7 raid options * 3 different types (data, metadata, system) = 21
already... Some parts of the algorithm make only sense for a subset of
the combinations, but they're still part of the computation, which
sometimes "by accident" results in the correct outcome. :)

If it can't be done in a way that's easier to understand when reading
the code, it should have unit tests with a list of known input/output to
detect unwanted changes.

-- 
Hans van Kranenburg
