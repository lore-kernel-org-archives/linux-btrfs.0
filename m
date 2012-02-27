From: Christian Brunner <christian@brunner-muc.de>
Subject: Re: Strange prformance degradation when COW writes happen at fixed offsets
Date: Mon, 27 Feb 2012 09:29:59 +0100
Message-ID: <CAJafhzSGT=B3KDE7m9=KyzGYXWT+QEfm09g1nxVd=Z14j_p2VQ@mail.gmail.com>
References: <CAB3q8748dryFek4UZnh+5__feqp_ffCX-VdZNkcs62B=X47Ghw@mail.gmail.com>
	<CAB3q874F+6HrjvxYduex3sKcskMYcVXOa_CqW6i1F=gDv8+u7g@mail.gmail.com>
	<pan.2012.02.24.06.38.07@cox.net>
	<CAB3q876D=jFQF8D+PypAkZM3Uuxgwmf+tjLB9m9Pb5JZsCHZTw@mail.gmail.com>
	<CAB3q874fWRmB6oRjiup=2zkiePdB3wrT3b7Ph4aW38s+VrRkJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Nik Markovic <nmarkovi.navteq@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAB3q874fWRmB6oRjiup=2zkiePdB3wrT3b7Ph4aW38s+VrRkJg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2012/2/24 Nik Markovic <nmarkovi.navteq@gmail.com>:
> To add... I also tried nodatasum (only) and nodatacow otions. I found
> somewhere that nodatacow doesn't really mean tthat COW is disabled.
> Test data is still the same - CPU spikes and times are the same.
>
> On Fri, Feb 24, 2012 at 2:38 PM, Nik Markovic <nmarkovi.navteq@gmail.=
com> wrote:
>> On Fri, Feb 24, 2012 at 12:38 AM, Duncan <1i5t5.duncan@cox.net> wrot=
e:
>>> Nik Markovic posted on Thu, 23 Feb 2012 20:31:02 -0600 as excerpted=
:
>>>
>>>> I noticed a few errors in the script that I used. I corrected it a=
nd it
>>>> seems that degradation is occurring even at fully random writes:
>>>
>>> I don't have an ssd, but is it possible that you're simply seeing e=
rase-
>>> block related degradation due to multi-write-block sized erase-bloc=
ks?
>>>
>>> It seems to me that when originally written to the btrfs-on-ssd, th=
e file
>>> will likely be written block-sequentially enough that the file as a=
 whole
>>> takes up relatively few erase-blocks. =A0As you COW-write individua=
l
>>> blocks, they'll be written elsewhere, perhaps all the changed block=
s to a
>>> new erase-block, perhaps each to a different erase block.
>>
>> This is a very interesting insight. I wasn't even aware of the
>> erase-block issue, so I did some reading up on it...
>>
>>>
>>> As you increase the successive COW generation count, the file's fil=
e-
>>> system/write blocks will be spread thru more and more erase-blocks,
>>> basically fragmentation but of the SSD-critical type, into more and=
 more
>>> erase blocks, thus affecting modification and removal time but not =
read
>>> time.
>>
>> OK, so time to write would increase due to fragmentation and writing=
,
>> it now makes sense (though I don't see why small writes would affect
>> this, but my concerns are not writes anyway), but why would cp
>> --reflink time increase so much. Yes, new extents would be created,
>> but btrfs doesn't write into data blocks, does it? I figured its
>> metadata would be kept in one place. I figure the only thing BTRFS
>> would do on cp --reflink=3Dalways:
>> 1. Take a collection of extents owned by source.
>> 2. Make the new copy use the same collection of extents.
>> 3. Write the collection of extents to the "directory".
>>
>> Now this process seems to be CPU intensive. When I remove or make a
>> reflink copy, one core pikes up to 100%, which tells me that there's=
 a
>> performance issue there, not an ssd issue. Also, only one CPU thread
>> is being used for this. I figured that I can improve this by some
>> setting. Maybe thread_pool mount option? Are there any updates in
>> later kernels that I should possibly pick up?
>>
>> [...]
>>
>> Unless I am wrong, this would disable COW completely and reflink cop=
y.
>> Reflinks are a crucial component and the sole
>> reason I picked BTRFS for the system that I am writing for my compan=
y.
>> The autodefrag option addresses multiple writes. Writing is not the
>> problem, but cp --reflink should be near-instant. That was the reaso=
n
>> we chose BTRFS over ZFS, which seemed to be the only feasible
>> alternative. ZFS snapshot complicate the design and deduplication co=
py
>> time is the same as (or not much better than) raw copy.
>>
>> [...]
>>
>> As I mentioned above, the COW is the crucial component of our system=
,
>> XFS won't do. Our system does not do random writes. In fact it is
>> mainly heavy on read operation. The system does occasional "rotation
>> of rust" on large files in a way that version control system would
>> (large files are modified and then used as a new baseline)

The symptoms you are reporting are quite similar to what I'm seeing in
our Ceph cluster:

http://comments.gmane.org/gmane.comp.file-systems.btrfs/15413

AFAIK, Chris and Josef are working on it, but you'll have to wait for
kernel 3.4, until this will be available in mainline. If you are
feeling adventurous, you could try the patches in Josef's git tree,
but I think it's still experimental.

Regards,
Christian
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
