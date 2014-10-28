Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19321 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750813AbaJ1JOi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Oct 2014 05:14:38 -0400
Message-ID: <544F5E7B.10400@cn.fujitsu.com>
Date: Tue, 28 Oct 2014 17:14:35 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Rene Thomas <re.thomas@gmx.de>, <linux-btrfs@vger.kernel.org>
Subject: Re: read block failed check_tree_block / Couldn't read chunk tree
References: <CAHOQfW0CF1CrHrZ_T_G49kXh6scKK59aYYZn48fi112RfHX=wg@mail.gmail.com>	<544DAE18.8010205@cn.fujitsu.com>	<CAHOQfW2d8oHuQWYde3g7aGwq5McgXkrRhA7eko+aqua6We6-PA@mail.gmail.com>	<544E0044.3050708@cn.fujitsu.com> <CAHOQfW0O0gT3jkGF5bcLs_m+v=2bYo6zbtV3bcW+FNDHRidgjg@mail.gmail.com>
In-Reply-To: <CAHOQfW0O0gT3jkGF5bcLs_m+v=2bYo6zbtV3bcW+FNDHRidgjg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: read block failed check_tree_block / Couldn't read chunk tree
From: Rene Thomas <re.thomas@gmx.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Date: 2014年10月28日 14:59
> Yes, removed sdb as well. Got the same error.
>
> You are right. I miss to add the btrfs ml when I reply. Thanks.
>
> I'am looking forward to hearing from you.
>
> Thanks
> René
Oh, that's bad...

Also investigate the full output of chunk-recover.
The results is worse that I first think.

1. Missing chunk item in RAID5
Which caused so many orphan dev extents and orphan block groups.
This is especially bad when it comes to RAID0/RAID5 where the stripe 
sequence matters.
That's to say, there are at least 499 chunks unable to recover.
(In RAID1, it could be recovered)

Also, chunk-recover current won't continue if there are so many orphans.
In your case, 1300+ valid chunk vs 500- unrecoverable orphan chunks,
The chance is very low now.

2. Low amount of rebuildable chunks.
The 77 bad chunks seems god, except the first bad chunk, who has no 
corresponding dev extent nor
block group.
Other 76 chunks are rebuildable, but 1316 + 76 won't change much against 
499 unrecoverable chunks.

So overall, it is almost impossible to recover.
I'm very sorry that I can't provide much help.

Thanks,
Qu

>
> 2014-10-27 9:20 GMT+01:00 Qu Wenruo <quwenruo@cn.fujitsu.com 
> <mailto:quwenruo@cn.fujitsu.com>>:
>
>
>     -------- Original Message --------
>     Subject: Re: read block failed check_tree_block / Couldn't read
>     chunk tree
>     From: Rene Thomas <re.thomas@gmx.de <mailto:re.thomas@gmx.de>>
>     To: Qu Wenruo <quwenruo@cn.fujitsu.com
>     <mailto:quwenruo@cn.fujitsu.com>>
>     Date: 2014年10月27日 15:30
>
>         Tried to mount the not affected drives in several ways. Always
>         get:
>
>         sudo mount -t btrfs -o degraded /dev/sda1 /home
>         [sudo] password for rthomas:
>         mount: Falscher Dateisystemtyp, ungültige Optionen, der
>            Superblock von /dev/sda1 ist beschädigt, fehlende
>            Kodierungsseite oder ein anderer Fehler
>            Manchmal liefert das Systemprotokoll wertvolle Informationen,
>            versuchen Sie »dmesg | tail« oder so
>
>     Even plug off the /dev/sdb?
>     If even remove the /dev/sdb hardware, it still reproduce the same
>     thing,
>     I think there is little chance.
>
>
>         And dmesg shows:
>
>         [  311.335674] BTRFS: bad tree block start 0 5845480062976
>         [  311.336215] BTRFS: bad tree block start 0 5845480062976
>         [  311.354660] BTRFS: bad tree block start 0 5845480054784
>         [  311.354762] BTRFS: bad tree block start 0 5845480054784
>         [  311.355024] BTRFS: bad tree block start 0 5845480067072
>         [  311.355145] BTRFS: bad tree block start 0 5845480067072
>         [  311.355496] BTRFS: bad tree block start 0 5845480050688
>         [  311.355612] BTRFS: bad tree block start 0 5845480050688
>         [  311.356347] BTRFS: bad tree block start 0 5845480071168
>         [  311.356458] BTRFS: bad tree block start 0 5845480071168
>         [  311.580203] BTRFS: Failed to read block groups: -5
>         [  311.605073] BTRFS: open_ctree failed
>
>         Tried all non-destructive ways to get data back.
>
>         Please find attached btrfs rescue chunk-recover log
>
>         http://sebsauvage.net/paste/?baa6fa7fbb2056cb#RTUGry3LQlmVghpjiMkRRGsxpwzDzoWOsmjO0elHF5c=
>
>     Thanks for the log,
>     I'll investigate it.
>
>         uname -a:
>         Linux engelserver 3.17.0-031700rc5-generic #201409151105 SMP
>         Mon Sep 15 15:08:10 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
>
>         btrfs --version:
>         3.17
>
>         I'am happy to help to improve tool quality / functionality.
>
>         Maybe it's interisting why mkfs.ntfs have such an impact on a
>         btrfs RAID5 array. In my opinion mkfs should not touch a
>         mounted device even when it's part of a raid and not explicit
>         mentioned in the fstab as the drive to be mounted.
>
>     Yes, mkfs should never touch a mounted device.
>     However, not every fs utils handles it in the right way.
>     In my test, ext4/btrfs/xfs can detect it and fail to mkfs, but
>     ntfs utils seems not to handle it right.
>     That caused the tragedy and btrfs-progs can't help but only to see
>     it happens.
>
>     BTW, would you mind Cc the mail to btrfs ml?
>     More people may provide help.
>
>     Thanks,
>     Qu
>
>
>         If there is a way get more information on the mount process /
>         chunk-recover,(e.g. enhanced log level) please advice.
>
>         Thanks
>         René
>
>
>         2014-10-27 3:29 GMT+01:00 Qu Wenruo <quwenruo@cn.fujitsu.com
>         <mailto:quwenruo@cn.fujitsu.com>
>         <mailto:quwenruo@cn.fujitsu.com
>         <mailto:quwenruo@cn.fujitsu.com>>>:
>
>
>             -------- Original Message --------
>             Subject: read block failed check_tree_block / Couldn't
>         read chunk tree
>             From: Rene Thomas <re.thomas@gmx.de
>         <mailto:re.thomas@gmx.de> <mailto:re.thomas@gmx.de
>         <mailto:re.thomas@gmx.de>>>
>             To: <linux-btrfs@vger.kernel.org
>         <mailto:linux-btrfs@vger.kernel.org>
>         <mailto:linux-btrfs@vger.kernel.org
>         <mailto:linux-btrfs@vger.kernel.org>>>
>             Date: 2014年10月25日 00:43
>
>                 Dear Developers / Maintainer,
>                 I’ve set up a running RAID5 with three devices (sda1 /
>         sdb1 /sdc1)
>
>                 Mountpoint was /home, filesystem was mounted
>                 A chain of unfortunal circumstances gives me the
>         chance to run
>                 as root
>                 in a terminal.
>
>                 mkfs.ntfs /dev/sdb1
>
>                 where /dev/sdb1 is device 1 in the Array.
>
>                 After a while I’ve realised that the terminal I used
>         was the
>                 wrong one
>                 and killed the process where the progress still was 0%.
>                 The filesystem was still in a readable state switched
>         to read
>                 only.
>                 Write access was not able.
>
>                 After a restart the RAID failed to mount.
>
>                 Tried several steps to reactivate the Array.
>
>                 All btrfs commands leads to:
>
>                 Check tree block failed, want=5845480062976, have=0
>                 Check tree block failed, want=5845480062976, have=0
>                 Check tree block failed, want=5845480062976, have=65536
>                 Check tree block failed, want=5845480062976, have=0
>                 Check tree block failed, want=5845480062976, have=0
>                 read block failed check_tree_block
>                 Couldn't read chunk tree
>
>             Chunk tree corruption will always lead to disaster :(
>
>             What about remove sdb1 and mount sda1/sdc1 with -o degraded ?
>             I hope the sda1/sdc1 is still in correct status...
>
>
>                 Started with:
>                 btrfs fi show
>                 mount -o revovery,ro /dev/sdc1 /home
>                 failed with error (see dmesg log at [311])
>                 btrfs-image -c 9 -t 8 /dev/sdb1
>         /media/storageplace/fs_image
>                 btrfs-zero-log /dev/sdb1
>                 btrfs check /dev/sdb1
>                 btrfs check --repair /dev/sdb1
>
>                 At least I tried
>                 btrfs rescue chunk-recover /dev/sdb1
>
>                 Works for several hours on the arry and end up in
>         (huge log
>                 available > 100k):
>
>                 “Fail to recover the chunk tree.”
>
>             If my previous defraded doesn't help, chunk-recover is the
>         last
>             chance for it.
>             If still failed, the chance to recover seems quite low.
>
>             However, can you upload the huge log for developers to
>         investigate
>             and improve the chunk-recover tools?
>
>             Thanks,
>             Qu
>
>
>                   I’ve checked the super block there are no errors
>
>                 My question is there any chance on a broken c tree to
>         get the data
>                 back? Not necessarily fix the Array only get the data.
>
>                 Thanks in advanced
>
>                 # uname -a
>                 Linux engelserver 3.17.0-031700rc5-generic
>         #201409151105 SMP
>                 Mon Sep
>                 15 15:08:10 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
>
>                   # btrfs --version
>                 Btrfs v3.17
>
>                   # btrfs fi show
>                 Label: 'mythstorage'  uuid:
>         9b454272-6800-4b3c-b196-9e180407a6cb
>                          Total devices 1 FS bytes used 2.36MiB
>                          devid    1 size 931.51GiB used 10.04GiB path
>         /dev/sdd1
>
>                   Check tree block failed, want=5845480062976, have=0
>                 Check tree block failed, want=5845480062976, have=0
>                 Check tree block failed, want=5845480062976, have=65536
>                 Check tree block failed, want=5845480062976, have=0
>                 Check tree block failed, want=5845480062976, have=0
>                 read block failed check_tree_block
>                 Couldn't read chunk tree
>
>                 Label: none  uuid: 8ef575d9-2465-479c-bf9c-067e2e417770
>                          Total devices 3 FS bytes used 3.02TiB
>                          devid    1 size 2.73TiB used 1.77TiB path
>         /dev/sdb1
>                          devid    2 size 2.73TiB used 1.77TiB path
>         /dev/sda1
>                          devid    3 size 2.73TiB used 1.77TiB path
>         /dev/sdc1
>                 Btrfs v3.17
>
>                 dmesg:
>                 [  280.637338] init: plymouth-upstart-bridge main process
>                 ended, respawning
>                 [  311.298682] BTRFS info (device sdc1): disk space
>         caching is
>                 enabled
>                 [  311.335674] BTRFS: bad tree block start 0 5845480062976
>                 [  311.336215] BTRFS: bad tree block start 0 5845480062976
>                 [  311.354660] BTRFS: bad tree block start 0 5845480054784
>                 [  311.354762] BTRFS: bad tree block start 0 5845480054784
>                 [  311.355024] BTRFS: bad tree block start 0 5845480067072
>                 [  311.355145] BTRFS: bad tree block start 0 5845480067072
>                 [  311.355496] BTRFS: bad tree block start 0 5845480050688
>                 [  311.355612] BTRFS: bad tree block start 0 5845480050688
>                 [  311.356347] BTRFS: bad tree block start 0 5845480071168
>                 [  311.356458] BTRFS: bad tree block start 0 5845480071168
>                 [  311.580203] BTRFS: Failed to read block groups: -5
>                 [  311.605073] BTRFS: open_ctree failed
>
>                 René
>                 --
>                 To unsubscribe from this list: send the line "unsubscribe
>                 linux-btrfs" in
>                 the body of a message to majordomo@vger.kernel.org
>         <mailto:majordomo@vger.kernel.org>
>                 <mailto:majordomo@vger.kernel.org
>         <mailto:majordomo@vger.kernel.org>>
>                 More majordomo info at
>         http://vger.kernel.org/majordomo-info.html
>
>
>
>
>

