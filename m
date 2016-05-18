Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31922 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751895AbcERBXW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 21:23:22 -0400
Subject: Re: problems with free space cache
To: Nicholas D Steeves <nsteeves@gmail.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
References: <CAD=QJKjop2j+K16nPcAU-bXiCVqm_aGK0g7WxjvTpBvXar+fQQ@mail.gmail.com>
 <85030f6b-b149-ccd2-ea87-42135b9ccd46@cn.fujitsu.com>
 <pan$d4fda$1f29731$4540c768$ab93bd6f@cox.net>
 <03a7da5b-e1e2-81a6-9d0c-ca80c1f52a63@cn.fujitsu.com>
 <9c5605c0-1382-334b-3b6e-9c87b6738164@gmail.com>
 <CAD=QJKgT0PQb-77FwNW-nq7O=ZtgoUmFMs6yvqE22KkTWtFQVA@mail.gmail.com>
CC: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <a8e8bf58-39ce-fd27-fd6b-d319fd1ceb33@cn.fujitsu.com>
Date: Wed, 18 May 2016 09:23:08 +0800
MIME-Version: 1.0
In-Reply-To: <CAD=QJKgT0PQb-77FwNW-nq7O=ZtgoUmFMs6yvqE22KkTWtFQVA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Nicholas D Steeves wrote on 2016/05/17 14:17 -0400:
> On 16 May 2016 at 07:36, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
>> On 2016-05-16 02:20, Qu Wenruo wrote:
>>>
>>>
>>>
>>> Duncan wrote on 2016/05/16 05:59 +0000:
>>>>
>>>> Qu Wenruo posted on Mon, 16 May 2016 10:24:23 +0800 as excerpted:
>>>>
>>>>> IIRC clear_cache option is fs level option.
>>>>> So the first mount with clear_cache, then all subvolume will have
>>>>> clear_cache.
>>>>
>>>>
>>>> Question:  Does clear_cache work with a read-only mount?
>>>
>>> Good question.
>>>
>>> But easy to check.
>>> I just checked it and found even that's possible, it doesn't work.
>
> +1  I had to use my USB flash rescue disk to mount with clear_cache.
>
>>> Free space cache inode bytenr doesn't change and no generation change.
>>> While without ro, it did rebuild free space cache for *SOME* chunks, not
>>> *ALL* chunks.
>>>
>>> And that's the problem I'm just chasing today.
>
> +1  Unfortunately, it didn't fix the affected free space cache files.
>
>>> Short conclude: clear_cache mount option will only rebuild free space
>>> cache for chunks which we allocated space from, during the mount time of
>>> clear_cache.
>>> (Maybe I'm just out-of-date and some other devs may already know that)
>
> Does this mean creating a huge file filled with zeros, while mounted
> with clear_cache would solve this?  I think that would be faster than
> a full rebalance, but I'm not convinced it would work, because of #1
> (see below).

No, it won't work, or at least won't work for all chunks.

Even you create a large file which would take up, for example, 50% of 
your total btrfs space.

It's still very possible that a lot of existing data chunk won't be 
modified, and their space cache is not not updated.

Not to mention that the large file won't cause too much metadata 
pressure to modify many metadata block group.

So without the new fsck method to offline clean space cache, either full 
balance with clear_cache mount option, or change kernel to do super slow 
mount to clean all free space cache.

>
> One of the following might have caused this situation:
>
> 1) I created a new subvolume, and tested a full restore from
> (non-btrfs aware) backups to this subvolume; some time later,
> verification (rsync -c with other options) completed, and the backup
> was confirmed to be usable; I deleted the subvolume and watched the
> cleaner get to work and reduce the allocated space, remembering a time
> a balance was necessary.  If this is what caused it, cloud there be a
> bug in the cleaner and/or cleaner<->space_cache interaction?

Unforunately, not sure, as I'm not familiar with btrfs cleaner thread.
But as long as fsck doesn't complain anything other than free space 
cache, cleaner thread is at least not causing big problem.

>
> 2) The same week I reorganised several hundred gigabytes of short term
> backups, moving them from one subvolume to another.  I used cp -ar
> --reflink=always from within /btrfs-admin, which is where I mount the
> whole volume, because / is subvol=rootfs.  After the copy I removed
> the source, then used the checksums I keep in my short-term backup
> directory to verify everything was ok (I could have restored from a
> fresh long-term backup if this failed).  As expected, everything was
> ok.  If this is what caused the free space cache bug, then could there
> be a bug in the intersubvolume reflink code?
>
>>> That behavior makes things a little confusing, which users may continue
>>> hitting annoying free space cache warning from kernel, even they try to
>>> use clear_cache mount option.
>
> So this warning is totally harmless and will not cause future problems?

Yes, at least for end-user. (despite the possible allocation performance 
impact)

For developer, this may means there is something wrong preventing us 
from commit free space cache to disk.

>
>>> Anyway, I'll add ability for manually wipe out all/given free space
>>> cache to btrfsck, at least creating a solution to really rebuild all v1
>>> free space cache.
>
> Nice!  Am I correct in understanding that this is as safe as a full
> balance, and not dangerous like btrfs check --repair?  Is it likely
> that the v2 free space cache will be default by linux-4.10?

I'm not certain about how safe full balance is.
(Common problem like ENOSPC will still prevent you from real *full* balance)
However, as balance is long tested and reviewed function, I assume it's 
still safer than current "btrfsck --clear-space-cache".

But at least, a little less dangerous than --repair.
If specifying to clear space cache, it will override the --repair 
option, and only to clear space cache.
So even carelessly typed "--clear-space-cache --repair", it will only 
clear cache.

And we designed the behavior to use transaction to protect most operation.
Every space cache inode deletion is in one transaction.
If bad things happened half way, only operation successfully done will 
be write to disk.


BUT! as the patchset has not been fully reviewed, it can still cause 
problem, and further more, for some extreme case, like the whole tree 
root already contains corrupted data, it may still cause problems.


So currently, it's still dangerous than read-only fsck, but IMHO less 
dangerous than --repair/--init-extent-tree.

Thans,
Qu
>
>> FWIW, I think it's possible to do this by mounting with clear_cache and then
>> running a full balance on the filesystem.  Having an option to do this on an
>> unmounted FS would be preferred of course, as that would almost certainly
>> be more efficient on any reasonably sized filesystem.
>
> I'm running a balance now, like it's 2015! ;-)
>
> Thank you,
> Nicholas
>
>


