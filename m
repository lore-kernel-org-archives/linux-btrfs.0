Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20916 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab3JPFpT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Oct 2013 01:45:19 -0400
Date: Wed, 16 Oct 2013 13:45:01 +0800
Subject: RE: No apparent effect for "btrfs device delete missing"
Message-ID: <vv06gquljp918ecd9089vg02.1381902301093@email.android.com>
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, Martin <m_btrfs@ml1.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just a note_ btrfs fi show reads from the disks which could read the cache, you may try drop the cache or, use btrfs-progs from David latest integration to see kernel perspective.

Martin <m_btrfs@ml1.co.uk> wrote:

>Trying:
>
>btrfs device delete missing /
>
>appears not to do anything for a "/" mount for where I have swapped out
>a HDD:
>
>
># btrfs filesystem show
>Label: 'test_btrfs_misc_5'  uuid: 7d29d4e6-efdc-41dc-9aa8-e74dfbe13cc9
>        Total devices 2 FS bytes used 28.00KB
>        devid    1 size 59.74GB used 2.03GB path /dev/sdd5
>        *** Some devices missing
>
>Label: 'test_btrfs_root_4'  uuid: 269e142c-e561-4227-b2b0-fe2f9fb99391
>        Total devices 3 FS bytes used 10.55GB
>        devid    4 size 56.00GB used 12.03GB path /dev/sde4
>        devid    1 size 56.00GB used 12.05GB path /dev/sdd4
>        *** Some devices missing
>
>Btrfs v0.20-rc1-358-g194aa4a
># btrfs device delete missing /
># btrfs filesystem show
>Label: 'test_btrfs_misc_5'  uuid: 7d29d4e6-efdc-41dc-9aa8-e74dfbe13cc9
>        Total devices 2 FS bytes used 28.00KB
>        devid    1 size 59.74GB used 2.03GB path /dev/sdd5
>        *** Some devices missing
>
>Label: 'test_btrfs_root_4'  uuid: 269e142c-e561-4227-b2b0-fe2f9fb99391
>        Total devices 3 FS bytes used 10.55GB
>        devid    4 size 56.00GB used 12.03GB path /dev/sde4
>        devid    1 size 56.00GB used 12.05GB path /dev/sdd4
>        *** Some devices missing
>
>Btrfs v0.20-rc1-358-g194aa4a
>
>
>All on the latest "Linux 3.11.5-gentoo".
>
># df -h | egrep '/$'
>rootfs          112G   22G   89G  20% /
>/dev/sdd4       112G   22G   89G  20% /
>
>
>
>Aside: Adding the /dev/sde4 device caused no balance action until I
>deleted a device to reduce the raid1 mirror (data and metadata) down to
>the two devices.
>
>The "missing" device was an old HDD that had physically failed. No data
>was lost for that example failure.
>
>
>Hope of interest,
>Martin
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
