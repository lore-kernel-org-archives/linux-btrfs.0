Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:36036 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbbL1VXd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Dec 2015 16:23:33 -0500
Received: by mail-io0-f174.google.com with SMTP id o67so313826715iof.3
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 13:23:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5681A4D5.4060203@online.no>
References: <567FEEB6.3080701@online.no>
	<CAJCQCtSHWTqn7zzCtUtGjpr5=dMqfC1aGWaeNpZyVVhjrCvDHg@mail.gmail.com>
	<56806F06.50309@online.no>
	<pan$c7935$46be3379$4afc60bd$677c85c5@cox.net>
	<568098B1.2040908@online.no>
	<CAJCQCtRGbKJ6RJ++1rUSuVByC_=mJq4afNV-3CCt_s4gCft92A@mail.gmail.com>
	<5681A4D5.4060203@online.no>
Date: Mon, 28 Dec 2015 14:23:32 -0700
Message-ID: <CAJCQCtSAm2i0QuXPK5xDWNXvcrg3uo_DU5WYOnOD8Fkgn+c4eQ@mail.gmail.com>
Subject: Re: Btrfs scrub failure for raid 6 kernel 4.3
From: Chris Murphy <lists@colorremedies.com>
To: Waxhead <waxhead@online.no>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hopefully a developer responds because I can only make so much out of
this, so take it with a grain of salt.

On Mon, Dec 28, 2015 at 2:08 PM, Waxhead <waxhead@online.no> wrote:
> Chris Murphy wrote:
>>
>> On Sun, Dec 27, 2015 at 7:04 PM, Waxhead <waxhead@online.no> wrote:
>>
>>> Since all drives register and since I can even mount the filesystem.
>>
>> OK so you've umounted the file system, reconnected all devices,
>> mounted the file system normally, and there are no problems reported
>> in dmesg?
>>
>> If so, yes I agree that a scrub should probably work, it should fix
>> any problems with the simulated corrupt device, and also not crash.
>>
>> What if you umount, and run btrfs check without --repair, what are the
>> results? This is btrfs-progs 4.3.1?
>>
> The output from dmesg after mounting
> [  546.857533] BTRFS info (device sdg1): disk space caching is enabled
> [  546.872126] BTRFS: bdev /dev/sde1 errs: wr 10, rd 0, flush 0, corrupt
> 29094, gen 4
> [  546.872165] BTRFS: bdev /dev/sdb1 errs: wr 16, rd 7, flush 0, corrupt 0,
> gen 0

These are static counts, not in-progress errors for those devices.

/dev/sde1 has lots of corruptions, so I'm guessing that's the device
you intentionally corrupted.
/dev/sdb1 has read and write errors and also has a different
generation than sde1. So there's at least two devices with problems.


>
>
> This is the output I get from btrfs check /dev/sdb1 > somefile.output ....
> (note the filesystem was checked in unmounted state)
>
> Checking filesystem on /dev/sdb1
> UUID: 2832346e-0720-499f-8239-355534e5721b
> The following tree block(s) is corrupted in tree 5:
>         tree block bytenr: 28488941568, level: 1, node key: (52273, 1, 0)
> The following data extent is lost in tree 5:
>         inode: 104721, offset:0, disk_bytenr: 37828165632, disk_len: 524288

Short of a dev asking for something else, I'd take a btrfs-image -t4
-c9 to a different file system (do this umounted). Then use btrfs
restore to get anything out that you care about. And then see if btrfs
check --repair can fix this.




> found 9161007108 bytes used err is 1
> total csum bytes: 8859672
> total tree bytes: 80969728
> total fs tree bytes: 66633728
> total extent tree bytes: 3211264
> btree space waste bytes: 10638420
> file data blocks allocated: 7929208832
>  referenced 7929208832
> btrfs-progs v4.3
>
> I also get a pretty fantastic amount of errors that will not be redirected
> to a file.
>
> ---snip---
> parent transid verify failed on 28597895168 wanted 371 found 339
> parent transid verify failed on 28597895168 wanted 371 found 339

So transid = generation. You have a wanted of 371, but at mount time
above it reports generation 4 and 0 for devs sde1 and sdb1
respectively. That's a big mismatch.

It sounds to me like more is going on than just one device being
intentionally corrupted.





> checksum verify failed on 28597895168 found 5D16DA87 wanted B9F56731
> checksum verify failed on 28597895168 found 1183EB4E wanted C18D87AC
> checksum verify failed on 28597895168 found 1183EB4E wanted C18D87AC
> bytenr mismatch, want=28597895168, have=147474999040
> Incorrect local backref count on 37826895872 root 5 owner 104850 offset 0
> found 0 wanted 1 back 0x94ac688
> Backref disk bytenr does not match extent record, bytenr=37826895872, ref
> bytenr=0
> backpointer mismatch on [37826895872 131072]
> owner ref check failed [37826895872 131072]
> ref mismatch on [37827117056 475136] extent item 1, found 0
> parent transid verify failed on 28597714944 wanted 371 found 339
> parent transid verify failed on 28597714944 wanted 371 found 339
> checksum verify failed on 28597714944 found 49CB81B9 wanted AD283C0F
> checksum verify failed on 28597714944 found D9F20AF8 wanted 1A5EE553
> checksum verify failed on 28597714944 found D9F20AF8 wanted 1A5EE553
> bytenr mismatch, want=28597714944, have=147480498944
> Incorrect local backref count on 37827117056 root 5 owner 104719 offset 0
> found 0 wanted 1 back 0x93688b0
> Backref disk bytenr does not match extent record, bytenr=37827117056, ref
> bytenr=37827026944
> backpointer mismatch on [37827117056 475136]
> owner ref check failed [37827117056 475136]
> ref mismatch on [37827641344 487424] extent item 1, found 0
> parent transid verify failed on 28597714944 wanted 371 found 339
> parent transid verify failed on 28597714944 wanted 371 found 339
> checksum verify failed on 28597714944 found 49CB81B9 wanted AD283C0F
> checksum verify failed on 28597714944 found D9F20AF8 wanted 1A5EE553
> checksum verify failed on 28597714944 found D9F20AF8 wanted 1A5EE553
> bytenr mismatch, want=28597714944, have=147480498944
> Incorrect local backref count on 37827641344 root 5 owner 104720 offset 0
> found 0 wanted 1 back 0x94ac778
> Backref disk bytenr does not match extent record, bytenr=37827641344, ref
> bytenr=0
> backpointer mismatch on [37827641344 487424]
> owner ref check failed [37827641344 487424]
> ref mismatch on [37828165632 524288] extent item 1, found 0
> parent transid verify failed on 28597714944 wanted 371 found 339
> parent transid verify failed on 28597714944 wanted 371 found 339
> checksum verify failed on 28597714944 found 49CB81B9 wanted AD283C0F
> checksum verify failed on 28597714944 found D9F20AF8 wanted 1A5EE553
> checksum verify failed on 28597714944 found D9F20AF8 wanted 1A5EE553
> bytenr mismatch, want=28597714944, have=147480498944
> Incorrect local backref count on 37828165632 root 5 owner 104721 offset 0
> found 0 wanted 1 back 0x94ac868
> Backref disk bytenr does not match extent record, bytenr=37828165632, ref
> bytenr=0
> backpointer mismatch on [37828165632 524288]
> owner ref check failed [37828165632 524288]
> checking free space cache
> checking fs roots
> ---snip end---
>
> ---snippety snip---
> root 5 inode 53325 errors 2001, no inode item, link count wrong
>         unresolved ref dir 52207 index 0 namelen 14 name pthreadtypes.h
> filetype 1 errors 6, no dir index, no inode ref
> root 5 inode 53328 errors 2001, no inode item, link count wrong
>         unresolved ref dir 52207 index 0 namelen 8 name select.h filetype 1
> errors 6, no dir index, no inode ref
> root 5 inode 53329 errors 2001, no inode item, link count wrong
>         unresolved ref dir 52207 index 0 namelen 9 name select2.h filetype 1
> errors 6, no dir index, no inode ref
> root 5 inode 53330 errors 2001, no inode item, link count wrong
>         unresolved ref dir 52207 index 0 namelen 5 name sem.h filetype 1
> errors 6, no dir index, no inode ref
> root 5 inode 53331 errors 2001, no inode item, link count wrong
>         unresolved ref dir 52207 index 0 namelen 11 name semaphore.h
> filetype 1 errors 6, no dir index, no inode ref
> root 5 inode 53333 errors 2001, no inode item, link count wrong
>         unresolved ref dir 52207 index 0 namelen 9 name setjmp2.h filetype 1
> errors 6, no dir index, no inode ref
> root 5 inode 53343 errors 2001, no inode item, link count wrong
>         unresolved ref dir 52207 index 0 namelen 10 name sockaddr.h filetype
> 1 errors 6, no dir index, no inode ref
> root 5 inode 53345 errors 2001, no inode item, link count wrong
>         unresolved ref dir 52207 index 0 namelen 9 name socket2.h filetype 1
> errors 6, no dir index, no inode ref
> root 5 inode 53347 errors 2001, no inode item, link count wrong
>         unresolved ref dir 52207 index 0 namelen 8 name stab.def filetype 1
> errors 6, no dir index, no inode ref
> root 5 inode 53350 errors 2001, no inode item, link count wrong
>         unresolved ref dir 52207 index 0 namelen 9 name statvfs.h filetype 1
> errors 6, no dir index, no inode ref
> root 5 inode 53351 errors 2001, no inode item, link count wrong
>         unresolved ref dir 52207 index 0 namelen 12 name stdio-ldbl.h
> filetype 1 errors 6, no dir index, no inode ref
> root 5 inode 53352 errors 2001, no inode item, link count wrong
>         unresolved ref dir 52207 index 0 namelen 12 name stdio-lock.h
> filetype 1 errors 6, no dir index, no inode ref
> root 5 inode 53361 errors 2001, no inode item, link count wrong
>         unresolved ref dir 52207 index 0 namelen 9 name string2.h filetype 1
> errors 6, no dir index, no inode ref
> root 5 inode 53384 errors 2001, no inode item, link count wrong
>         unresolved ref dir 52207 index 0 namelen 12 name wchar-ldbl.h
> filetype 1 errors 6, no dir index, no inode ref
> root 5 inode 62056 errors 2001, no inode item, link count wrong
>         unresolved ref dir 51339 index 0 namelen 5 name local filetype 2
> errors 6, no dir index, no inode ref
> root 5 inode 62093 errors 2001, no inode item, link count wrong
>         unresolved ref dir 51339 index 0 namelen 4 name sbin filetype 2
> errors 6, no dir index, no inode ref
> root 5 inode 62344 errors 2001, no inode item, link count wrong
>         unresolved ref dir 51339 index 0 namelen 5 name share filetype 2
> errors 6, no dir index, no inode ref
> root 5 inode 104721 errors 4001, no inode item, orphan file extent
> The following data extent is lost in tree 5:
>         inode: 104721, offset:0, disk_bytenr: 37828165632, disk_len: 524288
> root 5 inode 105299 errors 2001, no inode item, link count wrong
>         unresolved ref dir 51339 index 0 namelen 3 name src filetype 2
> errors 6, no dir index, no inode ref
> ---snippety snip end---
>
>



-- 
Chris Murphy
