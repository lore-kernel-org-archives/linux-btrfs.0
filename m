Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:33234 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751979AbdJKMDJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 08:03:09 -0400
Subject: Re: [PATCH] btrfs: fix max chunk size on dup
To: Naohiro Aota <nao.aota@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <150666965116.9802.15216393306253897797.stgit@naota.dhcp.fujisawa.hgst.com>
 <20171010113119.GJ3521@suse.cz>
 <11a2b79c-4eda-ff80-0ad4-53065919be01@mendix.com>
 <3336583b-0512-ee78-3842-4373b22abfbd@mendix.com>
 <51516c1c-6e76-6736-3606-d5bd7aa4f61f@mendix.com>
 <CAEe67=-Aqe1kTCjqKtEEVKJ1+LgWZML5JUhrLN7618vy-D1sWg@mail.gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <3258e515-a231-1fa8-22ff-923e56042461@mendix.com>
Date: Wed, 11 Oct 2017 14:03:06 +0200
MIME-Version: 1.0
In-Reply-To: <CAEe67=-Aqe1kTCjqKtEEVKJ1+LgWZML5JUhrLN7618vy-D1sWg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/11/2017 11:58 AM, Naohiro Aota wrote:
> Hi,
> 
> You may notice my @wdc.com address is bounced. As my internship job at
> wdc is finished, the address is already expired.
> Please contact me on this @elisp.net address.
> 
> 2017-10-11 2:42 GMT+09:00 Hans van Kranenburg <hans.van.kranenburg@mendix.com>:
>> Sorry for the mail spam, it's an interesting code puzzle... :)
>>
>> On 10/10/2017 07:22 PM, Hans van Kranenburg wrote:
>>> On 10/10/2017 07:07 PM, Hans van Kranenburg wrote:
>>>> On 10/10/2017 01:31 PM, David Sterba wrote:
>>>>> Hi,
>>>>>
>>>>> On Fri, Sep 29, 2017 at 04:20:51PM +0900, Naohiro Aota wrote:
>>>>>> Balancing a fresh METADATA=dup btrfs file system (with size < 50G)
>>>>>> generates a 128MB sized block group. While we set max_stripe_size =
>>>>>> max_chunk_size = 256MB, we get this half sized block group:
>>>>>>
>>>>>> $ btrfs ins dump-t -t CHUNK_TREE btrfs.img|grep length
>>>>>>                 length 8388608 owner 2 stripe_len 65536 type DATA
>>>>>>                 length 33554432 owner 2 stripe_len 65536 type SYSTEM|DUP
>>>>>>                 length 134217728 owner 2 stripe_len 65536 type METADATA|DUP
>>>>>>
>>>>>> Before commit 86db25785a6e ("Btrfs: fix max chunk size on raid5/6"), we
>>>>>> used "stripe_size * ndevs > max_chunk_size * ncopies" to check the max
>>>>>> chunk size. Since stripe_size = 256MB * dev_stripes (= 2) = 512MB, ndevs
>>>>>> = 1, max_chunk_size = 256MB, and ncopies = 2, we allowed 256MB
>>>>>> METADATA|DUP block group.
>>>>>>
>>>>>> But now, we use "stripe_size * data_stripes > max_chunk_size". Since
>>>>>> data_stripes = 1 on DUP, it disallows the block group to have > 128MB.
>>>>>> What missing here is "dev_stripes". Proper logical space used by the block
>>>>>> group is "stripe_size * data_stripes / dev_stripes". Tweak the equations to
>>>>>> use the right value.
>>>>>
>>>>> I started looking into it and still don't fully understand it. Change
>>>>> deep in the allocator can easily break some blockgroup combinations, so
>>>>> I'm rather conservative here.
>>>>
>>>> I think that the added usage of data_stripes in 86db25785a6e is the
>>>> problematic change. data_stripes is something that was introduced as
>>>> part of RAID56 in 53b381b3a and clearly only has a meaning that's
>>>> properly thought of for RAID56. The RAID56 commit already adds "this
>>>> will have to be fixed for RAID1 and RAID10 over more drives", only the
>>>> author doesn't catch the DUP case, which already breaks at that point.
>>>>
> 
> Thank you for explaining in detail :) Yes, the allocator was already
> broken by using the data_stripes.

Well, technically, data_stripes is right (I first was confused about it
yesterday). But it's something specific for parity raid.

> (and it will also "break" existing file systems, in terms of making a
> DUP|META block group smaller)

Yes, and on a fs larger than 50GiB I indeed see 512MB DUP metadata
chunks, instead of 1GiB like the code says.

> I believe this patch fix the things.
> 
>>>> At the beginning it says:
>>>>
>>>> int data_stripes; /* number of stripes that count for block group size */
>>>>
>>>> For the example:
>>>>
>>>> This is DUP:
>>>>
>>>> .sub_stripes    = 1,
>>>> .dev_stripes    = 2,
>>>> .devs_max       = 1,
>>>> .devs_min       = 1,
>>>> .tolerated_failures = 0,
>>>> .devs_increment = 1,
>>>> .ncopies        = 2,
>>>>
>>>> In the code:
>>>>
>>>> max_stripe_size = SZ_256M
>>>> max_chunk_size = max_stripe_size    -> SZ_256M
>>>>
>>>> Then we have find_free_dev_extent:
>>>>     max_stripe_size * dev_stripes   -> SZ_256M * 2 -> 512M
>>>>
>>>> So we like to find 512M on a disk, to stuff 2 stripes of 256M inside for
>>>> the DUP. (remember: The two parts of DUP *never* end up on a different
>>>> disk, even if you have multiple)
>>>>
>>
>> Another better fix would be to make a change here...
>>
>>>> If we find one:
>>>> stripe_size = devices_info[ndevs-1].max_avail   -> 512M, yay
>>
>> ...because this is not yay. The 512M is max_avail, which needs to holds
>> *2* stripes, not 1. So stripe_size is suddenly changed to twice the
>> stripe size for DUP.
>>
>> So, an additional division again by dev_stripes would translate the
>> max_avail on device ndevs-1 to the stripe size to use.
> 
> This catch the point. Notice stripe_size is divided by dev_stripes
> after the lines in the patch.

Yes,

stripe_size = div_u64(stripe_size, dev_stripes);

Anyone who reads this should think.. "So, ok, what IS a stripe then". O_o

> It means that at this region (from "stripe_size =
> devices_info[ndevs-1].max_avail;" to "stripe_size =
> div_u64(stripe_size, dev_stripes);"),
> "stripe_size" stands for "stripe size written in one device". IOW,
> stripe_size (here, size of region in one device) = dev_stripes *
> stripe_size (final, one chunk).
> These two "stripe_size" is mostly the same value, because we set
> dev_stripes > 1 only with DUP.
> 
> We are using this stripe_size in one device manner to calculate logical size.
> This is correct, if we actually stripe write to stripes in one device.
> But, it actually is
> copied stripes at least with current implementation. So the
> if-condition "if (stripe_size * data_stripes > max_chunk_size)"
> is doing wrong calculation.
> 
> So the solution would be:
> 
> 1. as in my patch, consider dev_stripes in the if-condition
> or,
> 2. as Hans suggests, move the division by dev_stripes above the if-condition,
>    and properly re-calculate stripe_size if logical size > max_chunk_size
> 
> Now, I think taking the 2nd solution would make the code more clear,
> because it eliminate two different meanings of "stripe_size"

Yes, it's quite important that the meaning of things is consistent.

item 81 key (FIRST_CHUNK_TREE CHUNK_ITEM 723261587456) itemoff 9627
itemsize 112
    chunk length 536870912 owner 2 stripe_len 65536
    type METADATA|DUP num_stripes 2
        stripe 0 devid 1 offset 641061617664
        dev uuid: edae9198-4ea9-4553-9992-af8e27aa6578
        stripe 1 devid 1 offset 641598488576
        dev uuid: edae9198-4ea9-4553-9992-af8e27aa6578

Stripes are the separate parts of physical disk space that are combined
into the logical address space.

So in the above example for DUP, The chunk is 512MiB, and both of the
stripes are also 512MiB.

Everywhere there's stripe in the code it should be, or should be working
towards that 512MiB value (e.g. only going down because the disk is
almost full). Right now it's not during part of the function, which
causes everything in between to act weird.

> Again, keep in mind that "dev_stripes = 1" on all BG types but DUP.
> So, multiply/divide with "dev_stripes" won't affect any BG but DUP BG
> (at least on current RAID feature set).

Yep. That's probably why the problem was not spotted yet.


Also: there is an additional question... Since the actual behaviour has
been creating 128MiB and 512MiB metadata chunks for years now, "fixing"
this bug would mean that the behaviour suddenly changes.

Since 1 GiB for a single metadata chunk is IMHO really too big (could
start a separate discussion why), I would propose to keep the actual
behavior consistent and change the default in the code from 256MiB and
1GiB to 128MiB and 512MiB.

What we *do* know then, is that we are not introducing regressions or
new problems for users.

Or, is there a special reason why you would want to have bigger ones,
causing you to find the bug?

> 
>>
>>>>
>>>> num_stripes = ndevs * dev_stripes -> 1 * 2  -> 2
>>>>
>>>> data_stripes = num_stripes / ncopies = 2 / 2 = 1
>>>
>>> Oh, wow, this is not true of course, because the "number of stripes that
>>> count for block group size" should still be 1 for DUP...
>>>
>>>> BOOM! There's the problem. The data_stripes only thinks about data that
>>>> is horizontally spread over disks, and not vertically spread...
>>>
>>> Hm... no Hans, you're wrong.
>>>
>>>> What I would propose is changing...
>>>>    the data_stripes = <blah> and afterwards trying to correct it with
>>>> some ifs
>>>> ...to...
>>>>    a switch/case thing where the explicit logic is put to get the right
>>>> value for each specific raid type.
>>>>
>>>> In case of DUP this simply means data_stripes = 2, because there is no
>>>> need for fancy calculations about spreading DUP data over X devices.
>>>> It's always 2 copies on 1 device.
>>>
>>> Eh, nope. 1.
>>>
>>> So, then I end up at the "stripe_size * data_stripes > max_chunk_size"
>>> again.
>>>
>>> So, yes, Naohiro is right, and DUP is the only case in which this logic
>>> breaks. DUP is the only one in which it this change makes a difference,
>>> because it's the only one which has dev_stripes set to something else
>>> than 1.
>>
>> If stripe_size doesn't incorrectly get set to dev_stripes * stripe_size
>> max_avail above, the if works.
>>
>> The comments below still stand, because doing all those calculations
>> with stripes and number of devices for something as predictable as DUP
>> is only confusing. :D
>>
>>>
>>> \o/
>>>
>>>> ...
>>>>
>>>> My general feeling when looking at the code, is that this single part of
>>>> code is responsible for too many different cases, or, more possible
>>>> cases than a developer can reason about at once "in his head" when
>>>> working on it.
>>>>
>>>> 7 raid options * 3 different types (data, metadata, system) = 21
>>>> already... Some parts of the algorithm make only sense for a subset of
>>>> the combinations, but they're still part of the computation, which
>>>> sometimes "by accident" results in the correct outcome. :)
>>>>
>>>> If it can't be done in a way that's easier to understand when reading
>>>> the code, it should have unit tests with a list of known input/output to
>>>> detect unwanted changes.
> 
> I agree. The code is too complicated for current RAID feature set,
> though it may support future
> expansion naturally.

Well, I think the original idea was to have one algorithm which works
with the parameters in the list of btrfs_raid_attr, so you could just
add a new type by only adding new parameters.

The addition of RAID56 (or, the way in which it was done) already
shattered that dream, since it adds special cases in specific places for
itself.

Or, the struct should include a field with .parity_stripes (1 for raid5,
2 for raid6, 0 for others) and that should be used instead of the if
raid5 () and if raid6 () etc... But, in that case, there's no code which
magically knows what to do when you set parity_stripes = 3.. Aaaargh!

-- 
Hans van Kranenburg
