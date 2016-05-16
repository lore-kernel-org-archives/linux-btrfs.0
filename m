Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22444 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751934AbcEPCYf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 May 2016 22:24:35 -0400
Subject: Re: problems with free space cache
To: Nicholas D Steeves <nsteeves@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAD=QJKjop2j+K16nPcAU-bXiCVqm_aGK0g7WxjvTpBvXar+fQQ@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <85030f6b-b149-ccd2-ea87-42135b9ccd46@cn.fujitsu.com>
Date: Mon, 16 May 2016 10:24:23 +0800
MIME-Version: 1.0
In-Reply-To: <CAD=QJKjop2j+K16nPcAU-bXiCVqm_aGK0g7WxjvTpBvXar+fQQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Nicholas D Steeves wrote on 2016/05/15 22:11 -0400:
> The volume was created with btrfs-progs-4.4.41; I upgraded to
> linux-4.4.10 today, and here is what I grepped from my dmesg:
>
> [  +0.002613] Btrfs loaded
> [  +0.080621] BTRFS: device label Red devid 1 transid 108234 /dev/sda3
> [  +0.000106] BTRFS: device label Red devid 2 transid 108234 /dev/sdb2
> [  +0.011888] BTRFS info (device sdb2): disk space caching is enabled
> [  +0.000001] BTRFS: has skinny extents
> [  +0.063532] BTRFS info (device sdb2): disk space caching is enabled
> [  +3.615389] BTRFS warning (device sdb2): block group 183639212032
> has wrong amount of free space
> [  +0.000002] BTRFS warning (device sdb2): failed to load free space
> cache for block group 183639212032, rebuilding it now
> [  +1.718348] BTRFS warning (device sdb2): block group 859022819328
> has wrong amount of free space
> [  +0.000003] BTRFS warning (device sdb2): failed to load free space
> cache for block group 859022819328, rebuilding it now
> [  +4.357965] BTRFS info (device sdb2): The free space cache file
> (1082361118720) is invalid. skip it
> [  +0.026489] BTRFS info (device sdb2): The free space cache file
> (1094172278784) is invalid. skip it
> [  +0.740340] BTRFS info (device sdb2): The free space cache file
> (1183292850176) is invalid. skip it
> [  +0.610161] BTRFS info (device sdb2): The free space cache file
> (1248791101440) is invalid. skip it
> [  +0.353670] BTRFS info (device sdb2): The free space cache file
> (1284224581632) is invalid. skip it
>
> What is the standard procedure for fixing the cache?  Rootfs is a
> subvolume and the first entry in fstab.  Second entry is /btrfs-admin,
> which is where I mount the whole volume.  Is it sufficient to add the
> clear_cache option to the rootfs entry, or does the /btrfs-admin entry
> also need it?

IIRC clear_cache option is fs level option.
So the first mount with clear_cache, then all subvolume will have 
clear_cache.

$ sudo mount /dev/sda6 -o subvol=sub1,clear_cache /mnt/data/
$ sudo mount /dev/sda6 -o subvol=sub2 /mnt/test/
$ mount | grep btrfs
/dev/sda6 on /mnt/data type btrfs 
(rw,relatime,space_cache,clear_cache,subvolid=257,subvol=/sub1)
/dev/sda6 on /mnt/test type btrfs 
(rw,relatime,space_cache,clear_cache,subvolid=258,subvol=/sub2)

Thanks,
Qu
>
> From what I've read in the documentation one modifies fstab, reboots,
> removes modification from fstab, and it's fixed.
>
> Cheers,
> Nicholas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


