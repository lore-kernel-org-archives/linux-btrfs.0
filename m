Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43339 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751459AbbLUCSy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Dec 2015 21:18:54 -0500
Subject: Re: Disk quota exceeded
To: Matthew Jurgens <default.mailbox@edcint.co.nz>,
        <linux-btrfs@vger.kernel.org>
References: <567533BA.1010207@edcint.co.nz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56776153.4010400@cn.fujitsu.com>
Date: Mon, 21 Dec 2015 10:17:55 +0800
MIME-Version: 1.0
In-Reply-To: <567533BA.1010207@edcint.co.nz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Matthew Jurgens wrote on 2015/12/19 21:38 +1100:
> I've create a subvolume
> CMD: btrfs quota enable /export/shared
> CMD: btrfs subvol create /export/shared/TV/files
> Create subvolume '/export/shared/TV/files'
> CMD: btrfs quota rescan /export/shared/TV/files
>
> I've assigned a small quota to it:
> CMD: btrfs qgroup limit 100M /export/shared/TV/files
>
> I've also disabled copy on write:
> CMD: chattr -R -V +C /export/shared/TV/files
> chattr 1.42.12 (29-Aug-2014)
> Flags of /export/shared/TV/files set as ---------------C
>
> CMD: sync; btrfs qgroup show -r /export/shared/TV/files
> qgroupid         rfer         excl     max_rfer
> --------         ----         ----     --------
> 0/5           2.11TiB      2.11TiB         none
> 0/1894       16.00KiB     16.00KiB    100.00MiB
>
> I created one file until I exceeded the quota using:
> CMD: dd if=/dev/zero of=/export/shared/TV/files/junk1 count=50 bs=1M
> CMD: dd if=/dev/zero of=/export/shared/TV/files/junk1 count=50 bs=1M
> dd: error writing â€˜/export/shared/TV/files/junk1â€™: Disk quota exceeded
> 50+0 records in
> 49+0 records out
> 51380224 bytes (51 MB) copied, 0.0238218 s, 2.2 GB/s
>
> then I removed the file
> CMD: rm /export/shared/TV/files/junk1
>
> I tried to create it again (and only got 900k written before the quota
> was exceeded):
> CMD: dd if=/dev/zero of=/export/shared/TV/files/junk1 count=50 bs=1M
> dd: error writing â€˜/export/shared/TV/files/junk1â€™: Disk quota exceeded
> 1+0 records in
> 0+0 records out
> 917504 bytes (918 kB) copied, 0.000568984 s, 1.6 GB/s
>
> then I removed the file
> CMD: rm /export/shared/TV/files/junk1
>
> I tried to create it again (and this time got 900k again written before
> the quota was exceeded):
> dd if=/dev/zero of=/export/shared/TV/files/junk1 count=50 bs=1M
> dd: error writing â€˜/export/shared/TV/files/junk1â€™: Disk quota exceeded
> 1+0 records in
> 0+0 records out
> 917504 bytes (918 kB) copied, 0.000943652 s, 972 MB/s
>
> The usage looks ok:
> CMD: sync; btrfs qgroup show -r /export/shared/TV/files
> qgroupid         rfer         excl     max_rfer
> --------         ----         ----     --------
> 0/5           3.10TiB      3.10TiB         none
> 0/1894      912.00KiB    912.00KiB    100.00MiB

The excl/rfer numbers will always be accurate, as that what 4.2 quota 
rework does.

>
> But I can not create any more files:
> CMD: dd if=/dev/zero of=/export/shared/TV/files/junk1 count=50 bs=1M
> dd: failed to open â€˜/export/shared/TV/files/junk1â€™: Disk quota exceeded

That's what exactly I fixed in 4.3-rc1.
And the operation to trigger the bug is almost the same with xfstest 
test case: btrfs/099.

Btrfs doesn't handle quota reserved space well, and caused reserved 
space leak. (fixed in 4.3-rc1, but more test would be better)

As long as you did overwrite, no matter whether you enabled or disabled 
CoW, it will leak reserved space, and the reserved space won't be freed.

Finally eating up your quota space.

You can either try latest 4.3-rc, which does not only include the quota 
fix, but also a lot of delayed ref fixes.

Or, there is a workaround:
Umount the fs and mount it again.
This will free the leaked space and make it work again for a short time,
until your next overwrite.

Thanks,
Qu
>
> CMD: lsattr /export/shared/TV/files
> ---------------C /export/shared/TV/files/junk1
>
> During other tests I have managed to get it to the point where I can't
> delete the file (since disk quota exceeded).
> I've waited many minutes to ensure commits etc. The only way I can
> seemingly consistently get the ability to write to the directory again
> is to reboot. Immediately after a reboot I can create files as expected.
>
> It seems like copy on write is still functioning for this directory? or
> quota results have delays?
> I've tried mounting the subvolume to another location, but same results.
>
> Is this happening because quotas are not yet considered stable?
> Is there something I am doing wrong?
>
>
>
>
> Other Info:
> The fstab entry:
> LABEL=SHARED            /export/shared          btrfs
> defaults,compress=lzo,relatime,nofail 0 1
>
> uname -a
> Linux gw.lambert.rd.to 4.2.7-200.fc22.x86_64 #1 SMP Thu Dec 10 03:28:47
> UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
>
> btrfs --version
> btrfs-progs v4.2.2
>
> btrfs fi show
> Label: 'SHARED'  uuid: 199672d4-69ef-4ecf-865a-851bed0167d5
>          Total devices 5 FS bytes used 3.10TiB
>          devid    1 size 2.73TiB used 1.27TiB path /dev/sdc
>          devid    2 size 2.73TiB used 1.27TiB path /dev/sdf
>          devid    3 size 2.73TiB used 1.27TiB path /dev/sdh
>          devid    4 size 2.73TiB used 1.27TiB path /dev/sde
>          devid    5 size 2.73TiB used 1.27TiB path /dev/sdd
>
> btrfs fi df /export/shared
> Data, RAID10: total=3.16TiB, used=3.09TiB
> System, RAID10: total=64.00MiB, used=352.00KiB
> Metadata, RAID10: total=9.00GiB, used=7.61GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
> dmesg:
> http://edcint.co.nz/tmp/dmesg_20151219.log
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


