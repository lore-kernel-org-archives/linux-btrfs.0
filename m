Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55256 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751923AbaJ0C2B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Oct 2014 22:28:01 -0400
Message-ID: <544DAE18.8010205@cn.fujitsu.com>
Date: Mon, 27 Oct 2014 10:29:44 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Rene Thomas <re.thomas@gmx.de>, <linux-btrfs@vger.kernel.org>
Subject: Re: read block failed check_tree_block / Couldn't read chunk tree
References: <CAHOQfW0CF1CrHrZ_T_G49kXh6scKK59aYYZn48fi112RfHX=wg@mail.gmail.com>
In-Reply-To: <CAHOQfW0CF1CrHrZ_T_G49kXh6scKK59aYYZn48fi112RfHX=wg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: read block failed check_tree_block / Couldn't read chunk tree
From: Rene Thomas <re.thomas@gmx.de>
To: <linux-btrfs@vger.kernel.org>
Date: 2014年10月25日 00:43
> Dear Developers / Maintainer,
> I’ve set up a running RAID5 with three devices (sda1 / sdb1 /sdc1)
>
> Mountpoint was /home, filesystem was mounted
> A chain of unfortunal circumstances gives me the chance to run as root
> in a terminal.
>
> mkfs.ntfs /dev/sdb1
>
> where /dev/sdb1 is device 1 in the Array.
>
> After a while I’ve realised that the terminal I used was the wrong one
> and killed the process where the progress still was 0%.
> The filesystem was still in a readable state switched to read only.
> Write access was not able.
>
> After a restart the RAID failed to mount.
>
> Tried several steps to reactivate the Array.
>
> All btrfs commands leads to:
>
> Check tree block failed, want=5845480062976, have=0
> Check tree block failed, want=5845480062976, have=0
> Check tree block failed, want=5845480062976, have=65536
> Check tree block failed, want=5845480062976, have=0
> Check tree block failed, want=5845480062976, have=0
> read block failed check_tree_block
> Couldn't read chunk tree
Chunk tree corruption will always lead to disaster :(

What about remove sdb1 and mount sda1/sdc1 with -o degraded ?
I hope the sda1/sdc1 is still in correct status...
>
> Started with:
> btrfs fi show
> mount -o revovery,ro /dev/sdc1 /home
> failed with error (see dmesg log at [311])
> btrfs-image -c 9 -t 8 /dev/sdb1 /media/storageplace/fs_image
> btrfs-zero-log /dev/sdb1
> btrfs check /dev/sdb1
> btrfs check --repair /dev/sdb1
>
> At least I tried
> btrfs rescue chunk-recover /dev/sdb1
>
> Works for several hours on the arry and end up in (huge log available > 100k):
>
> “Fail to recover the chunk tree.”
If my previous defraded doesn't help, chunk-recover is the last chance 
for it.
If still failed, the chance to recover seems quite low.

However, can you upload the huge log for developers to investigate and 
improve the chunk-recover tools?

Thanks,
Qu
>
>   I’ve checked the super block there are no errors
>
> My question is there any chance on a broken c tree to get the data
> back? Not necessarily fix the Array only get the data.
>
> Thanks in advanced
>
> # uname -a
> Linux engelserver 3.17.0-031700rc5-generic #201409151105 SMP Mon Sep
> 15 15:08:10 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
>
>   # btrfs --version
> Btrfs v3.17
>
>   # btrfs fi show
> Label: 'mythstorage'  uuid: 9b454272-6800-4b3c-b196-9e180407a6cb
>          Total devices 1 FS bytes used 2.36MiB
>          devid    1 size 931.51GiB used 10.04GiB path /dev/sdd1
>
>   Check tree block failed, want=5845480062976, have=0
> Check tree block failed, want=5845480062976, have=0
> Check tree block failed, want=5845480062976, have=65536
> Check tree block failed, want=5845480062976, have=0
> Check tree block failed, want=5845480062976, have=0
> read block failed check_tree_block
> Couldn't read chunk tree
>
> Label: none  uuid: 8ef575d9-2465-479c-bf9c-067e2e417770
>          Total devices 3 FS bytes used 3.02TiB
>          devid    1 size 2.73TiB used 1.77TiB path /dev/sdb1
>          devid    2 size 2.73TiB used 1.77TiB path /dev/sda1
>          devid    3 size 2.73TiB used 1.77TiB path /dev/sdc1
> Btrfs v3.17
>
> dmesg:
> [  280.637338] init: plymouth-upstart-bridge main process ended, respawning
> [  311.298682] BTRFS info (device sdc1): disk space caching is enabled
> [  311.335674] BTRFS: bad tree block start 0 5845480062976
> [  311.336215] BTRFS: bad tree block start 0 5845480062976
> [  311.354660] BTRFS: bad tree block start 0 5845480054784
> [  311.354762] BTRFS: bad tree block start 0 5845480054784
> [  311.355024] BTRFS: bad tree block start 0 5845480067072
> [  311.355145] BTRFS: bad tree block start 0 5845480067072
> [  311.355496] BTRFS: bad tree block start 0 5845480050688
> [  311.355612] BTRFS: bad tree block start 0 5845480050688
> [  311.356347] BTRFS: bad tree block start 0 5845480071168
> [  311.356458] BTRFS: bad tree block start 0 5845480071168
> [  311.580203] BTRFS: Failed to read block groups: -5
> [  311.605073] BTRFS: open_ctree failed
>
> René
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

