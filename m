Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:38235 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbcEQSRj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 14:17:39 -0400
Received: by mail-wm0-f48.google.com with SMTP id g17so44955428wme.1
        for <linux-btrfs@vger.kernel.org>; Tue, 17 May 2016 11:17:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9c5605c0-1382-334b-3b6e-9c87b6738164@gmail.com>
References: <CAD=QJKjop2j+K16nPcAU-bXiCVqm_aGK0g7WxjvTpBvXar+fQQ@mail.gmail.com>
	<85030f6b-b149-ccd2-ea87-42135b9ccd46@cn.fujitsu.com>
	<pan$d4fda$1f29731$4540c768$ab93bd6f@cox.net>
	<03a7da5b-e1e2-81a6-9d0c-ca80c1f52a63@cn.fujitsu.com>
	<9c5605c0-1382-334b-3b6e-9c87b6738164@gmail.com>
Date: Tue, 17 May 2016 14:17:37 -0400
Message-ID: <CAD=QJKgT0PQb-77FwNW-nq7O=ZtgoUmFMs6yvqE22KkTWtFQVA@mail.gmail.com>
Subject: Re: problems with free space cache
From: Nicholas D Steeves <nsteeves@gmail.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, Duncan <1i5t5.duncan@cox.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 16 May 2016 at 07:36, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
> On 2016-05-16 02:20, Qu Wenruo wrote:
>>
>>
>>
>> Duncan wrote on 2016/05/16 05:59 +0000:
>>>
>>> Qu Wenruo posted on Mon, 16 May 2016 10:24:23 +0800 as excerpted:
>>>
>>>> IIRC clear_cache option is fs level option.
>>>> So the first mount with clear_cache, then all subvolume will have
>>>> clear_cache.
>>>
>>>
>>> Question:  Does clear_cache work with a read-only mount?
>>
>> Good question.
>>
>> But easy to check.
>> I just checked it and found even that's possible, it doesn't work.

+1  I had to use my USB flash rescue disk to mount with clear_cache.

>> Free space cache inode bytenr doesn't change and no generation change.
>> While without ro, it did rebuild free space cache for *SOME* chunks, not
>> *ALL* chunks.
>>
>> And that's the problem I'm just chasing today.

+1  Unfortunately, it didn't fix the affected free space cache files.

>> Short conclude: clear_cache mount option will only rebuild free space
>> cache for chunks which we allocated space from, during the mount time of
>> clear_cache.
>> (Maybe I'm just out-of-date and some other devs may already know that)

Does this mean creating a huge file filled with zeros, while mounted
with clear_cache would solve this?  I think that would be faster than
a full rebalance, but I'm not convinced it would work, because of #1
(see below).

One of the following might have caused this situation:

1) I created a new subvolume, and tested a full restore from
(non-btrfs aware) backups to this subvolume; some time later,
verification (rsync -c with other options) completed, and the backup
was confirmed to be usable; I deleted the subvolume and watched the
cleaner get to work and reduce the allocated space, remembering a time
a balance was necessary.  If this is what caused it, cloud there be a
bug in the cleaner and/or cleaner<->space_cache interaction?

2) The same week I reorganised several hundred gigabytes of short term
backups, moving them from one subvolume to another.  I used cp -ar
--reflink=always from within /btrfs-admin, which is where I mount the
whole volume, because / is subvol=rootfs.  After the copy I removed
the source, then used the checksums I keep in my short-term backup
directory to verify everything was ok (I could have restored from a
fresh long-term backup if this failed).  As expected, everything was
ok.  If this is what caused the free space cache bug, then could there
be a bug in the intersubvolume reflink code?

>> That behavior makes things a little confusing, which users may continue
>> hitting annoying free space cache warning from kernel, even they try to
>> use clear_cache mount option.

So this warning is totally harmless and will not cause future problems?

>> Anyway, I'll add ability for manually wipe out all/given free space
>> cache to btrfsck, at least creating a solution to really rebuild all v1
>> free space cache.

Nice!  Am I correct in understanding that this is as safe as a full
balance, and not dangerous like btrfs check --repair?  Is it likely
that the v2 free space cache will be default by linux-4.10?

> FWIW, I think it's possible to do this by mounting with clear_cache and then
> running a full balance on the filesystem.  Having an option to do this on an
> unmounted FS would be preferred of course, as that would almost certainly
> be more efficient on any reasonably sized filesystem.

I'm running a balance now, like it's 2015! ;-)

Thank you,
Nicholas
