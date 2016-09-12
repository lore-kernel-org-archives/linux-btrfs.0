Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34918 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757879AbcILOyq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 10:54:46 -0400
Received: by mail-oi0-f48.google.com with SMTP id d191so100895714oih.2
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Sep 2016 07:54:46 -0700 (PDT)
Subject: Re: Is stability a joke?
To: dsterba@suse.cz, Waxhead <waxhead@online.no>, linux-btrfs@vger.kernel.org
References: <57D51BF9.2010907@online.no>
 <20160912142714.GE16983@twin.jikos.cz>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <52304724-5bca-a1e6-527f-040085c7ab19@gmail.com>
Date: Mon, 12 Sep 2016 10:54:40 -0400
MIME-Version: 1.0
In-Reply-To: <20160912142714.GE16983@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-12 10:27, David Sterba wrote:
> Hi,
>
> first, thanks for choosing a catchy subject, this always helps. While it
> will serve as another beating stick to those who enjoy bashing btrfs,
> I'm glad to see people answer in a constructive way.
>
> On Sun, Sep 11, 2016 at 10:55:21AM +0200, Waxhead wrote:
>> I have been following BTRFS for years and have recently been starting to
>> use BTRFS more and more and as always BTRFS' stability is a hot topic.
>> Some says that BTRFS is a dead end research project while others claim
>> the opposite.
>
> I take the 'research' part, as it's still possible to implement features
> that were not expected years ago, but not a research in the sense "will
> shadowing and clones approach to b-trees work?", ie. the original paper
> by Ohad Rodeh from 2007.  That we can still add various metadata and
> structures to the same underlying format proves that the design is sound
> and flexible, building on the same primitives, only extending the
> logical structure.
>
> But I'm sure you'll find people who still claim that btrfs is broken by
> design, because they heared somebody say that [1].
There have been a lot of things that hurt BTRFS's reputation.  I don't 
see this one as quite as much of an issue as the fiasco that was the 
original merge with mainline and the fact that a lot of distros added 
'support' before it was at all ready.  IMHO, if a distro is going to 
provide a filesystem as their default, then their default configuration 
needs to work with no user intervention for more than 90% of their 
users, and BTRFS has not been and still is not there at least with it's 
default options.
>
>> Taking a quick glance at the wiki does not say much about what is safe
>> to use or not and it also points to some who are using BTRFS in production.
>> While BTRFS can apparently work well in production it does have some
>> caveats, and finding out what features is safe or not can be problematic
>> and I especially think that new users of BTRFS can easily be bitten if
>> they do not do a lot of research on it first.
>
> That's a valid point, the wiki lacks that, the usrespace tools do not
> warn or prevent before using features deemed unsafe. In the enterprise
> SLES kernel we can afford to draw a line where the support from our side
> ends, regardless of the upstream status of the features. Doing that in
> the upstream kernel is a bit different, the release and update schedules
> are not the same, code is not selectively backported etc.
The other problem though is that what is considered unsafe varies by use 
case and a bunch of other factors.  As an example, SUSE obviously 
considers qgroups safe, but I and a number of other list regulars do 
not.  Similarly, LZO compression is something I would consider safe 
under specific circumstances (namely, if you have reliable hardware and 
can expect to be able to replace a failing component before you get 
storms of read or write failures), but not in others.
>
>> The Debian wiki for BTRFS (which is recent by the way) contains a bunch
>> of warnings and recommendations and is for me a bit better than the
>> official BTRFS wiki when it comes to how to decide what features to use.
>
> The 'wiki problem' is real, for too long people went to distro wikis for
> generic information, so even if our k.org wiki is up to date, it's not
> the primary source anyway. Changing that back is a long-term goal.
>
>> The Nouveau graphics driver have a nice feature matrix on it's webpage
>> and I think that BTRFS perhaps should consider doing something like that
>> on it's official wiki as well
>>
>> For example something along the lines of .... (the statuses are taken
>> our of thin air just for demonstration purposes)
>>
>> Kernel version 4.7
>> +----------------------------+--------+-----+-------+-------+--------+-------+--------+
>> | Feature / Redundancy level | Single | Dup | Raid0 | Raid1 | Raid10 |
>> Raid5 | Raid 6 |
>> +----------------------------+--------+-----+-------+-------+--------+-------+--------+
>> | Subvolumes                 | Ok     | Ok  | Ok    | Ok    | Ok   | Bad
>>    | Bad    |
>> +----------------------------+--------+-----+-------+-------+--------+-------+--------+
>> | Snapshots                  | Ok     | Ok  | Ok    | Ok    | Ok     |
>> Bad   | Bad    |
>> +----------------------------+--------+-----+-------+-------+--------+-------+--------+
>> | LZO Compression            | Bad(1) | Bad | Bad   | Bad(2)| Bad    |
>> Bad   | Bad    |
>> +----------------------------+--------+-----+-------+-------+--------+-------+--------+
>> | ZLIB Compression           | Ok     | Ok  | Ok    | Ok    | Ok     |
>> Bad   | Bad    |
>> +----------------------------+--------+-----+-------+-------+--------+-------+--------+
>> | Autodefrag                 | Ok     | Bad | Bad(3)| Ok    | Ok     |
>> Bad   | Bad    |
>> +----------------------------+--------+-----+-------+-------+--------+-------+--------+
>>
>> (1) Some explanation here...
>> (2) Some explanation there....
>> (3) And some explanation elsewhere...
>>
>> ...etc...etc...
>>
>> I therefore would like to propose that some sort of feature / stability
>> matrix for the latest kernel is added to the wiki preferably somewhere
>> where it is easy to find. It would be nice to archive old matrix'es as
>> well in case someone runs on a bit older kernel (we who use Debian tend
>> to like older kernels). In my opinion it would make things bit easier
>> and perhaps a bit less scary too. Remember if you get bitten badly once
>> you tend to stay away from from it all just in case, if you on the other
>> hand know what bites you can safely pet the fluffy end instead :)
>
> Somebody has put that table on the wiki, so it's a good starting point.
> I'm not sure we can fit everything into one table, some combinations do
> not bring new information and we'd need n-dimensional matrix to get the
> whole picture.
Agreed, especially because some things are only bad in specific 
circumstances (For example, snapshots generally work fine on almost 
anything, until you get into the range of more than about 250, then they 
start causing issues).
>
> d.
>
>
> [1] https://btrfs.wiki.kernel.org/index.php/FAQ#..._btrfs_is_broken_by_design_.28aka._Edward_Shishkin.27s_.22Unbound.28.3F.29_internal_fragmentation_in_Btrfs.22.29
