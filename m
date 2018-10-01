Return-Path: <SRS0=adn4=MN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A398AC43143
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 11:17:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 304082064A
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 11:17:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GivIoOoG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 304082064A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbeJARyb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Oct 2018 13:54:31 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:40054 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728972AbeJARyb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Oct 2018 13:54:31 -0400
Received: by mail-it1-f196.google.com with SMTP id i191-v6so5027041iti.5
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Oct 2018 04:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=GuT/SOir/yQ3CERfVYQjKYCuL38vxPX7qmSZ6W+VfEI=;
        b=GivIoOoGrfgscnloIg+sUx6bWvWha48hD3GHWcy4ldCG26+INpmzMNlAQ+pC7Hz05K
         w/tAYuN4co1R1VV3XjNcdk4rnCu2G3JGxBiteYqqKn8ZU8Cv7caozeH7Lvm6Rz4YMyc+
         rYlInxXXL9aEg6mgHNXjBB5QVP+wMUqpRiSflPIxW9C7pbNk0OIhGx6mBVbSUrHPhj/Y
         hwTwj49XgE/P3nvhJ94JdGux8dKZ1SWbm9sWKuD570EDsTKaJ6lKTm7HRKOVAwIjpajG
         EjN1vSSIxm3SCyM9ca2aRuQnSkD/9RTVMdBeIIfSYQ3MshlqFOCq01lcAls19X9oLKxl
         7UBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GuT/SOir/yQ3CERfVYQjKYCuL38vxPX7qmSZ6W+VfEI=;
        b=XRjZjmMaoccbNxMY4fICLCdMqCkETUKXxa6IlAc9gaUwdZ8oTSyShH0r0rASfaid/q
         R4QR97o7EDGv8QDpTNtjqqlZwnOAc8mJrNmWNN/BMLGiJ6pzF2ogJUzk+EEH58a/fsCT
         YeSROLgNqDxZL8N4WySBaAK2Gnvq0Pc068B4prwwe5DxTYfb402tuAAk3lY2xU5TlEnc
         ekC6o+BJULv4v0ueNEKwajYvBPTkCKmDnM7dbNsDV3Spw7kg298+ZXRsyjnvWbIgumLS
         UHh4ewuhBu2ZdONwS9hyvjQNLuBY3MJswmYVux7yXvG8WKVu4bf34Nyy95n6ORXQxkDa
         iXCg==
X-Gm-Message-State: ABuFfohmwHcYmn+D+SbII0s76dnQC4Od9+IihUs3OriaWrBmZBI4H63h
        f96uVIA+4LPFlA0+MT1Ef3IAm3Opx5U=
X-Google-Smtp-Source: ACcGV61TtdF0K+J06r0evB65jbTSz44FTta2UJiPQj8c6hAb0eZIbb7ZPpmHACJSqOJWg/EDvIGiiA==
X-Received: by 2002:a24:73c1:: with SMTP id y184-v6mr9357628itb.93.1538392633187;
        Mon, 01 Oct 2018 04:17:13 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id m5-v6sm4771020itb.6.2018.10.01.04.17.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Oct 2018 04:17:12 -0700 (PDT)
Subject: Re: [PATCH RFC] btrfs: harden agaist duplicate fsid
To:     Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <1538384164-3030-1-git-send-email-anand.jain@oracle.com>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <98cd974b-d817-c30b-5cd7-d69214f44f39@gmail.com>
Date:   Mon, 1 Oct 2018 07:17:10 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1538384164-3030-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2018-10-01 04:56, Anand Jain wrote:
> Its not that impossible to imagine that a device OR a btrfs image is
> been copied just by using the dd or the cp command. Which in case both
> the copies of the btrfs will have the same fsid. If on the system with
> automount enabled, the copied FS gets scanned.
> 
> We have a known bug in btrfs, that we let the device path be changed
> after the device has been mounted. So using this loop hole the new
> copied device would appears as if its mounted immediately after its
> been copied.
> 
> For example:
> 
> Initially.. /dev/mmcblk0p4 is mounted as /
> 
> lsblk
> NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
> mmcblk0     179:0    0 29.2G  0 disk
> |-mmcblk0p4 179:4    0    4G  0 part /
> |-mmcblk0p2 179:2    0  500M  0 part /boot
> |-mmcblk0p3 179:3    0  256M  0 part [SWAP]
> `-mmcblk0p1 179:1    0  256M  0 part /boot/efi
> 
> btrfs fi show
>     Label: none  uuid: 07892354-ddaa-4443-90ea-f76a06accaba
>     Total devices 1 FS bytes used 1.40GiB
>     devid    1 size 4.00GiB used 3.00GiB path /dev/mmcblk0p4
> 
> Copy mmcblk0 to sda
>     dd if=/dev/mmcblk0 of=/dev/sda
> 
> And immediately after the copy completes the change in the device
> superblock is notified which the automount scans using
> btrfs device scan and the new device sda becomes the mounted root
> device.
> 
> lsblk
> NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
> sda           8:0    1 14.9G  0 disk
> |-sda4        8:4    1    4G  0 part /
> |-sda2        8:2    1  500M  0 part
> |-sda3        8:3    1  256M  0 part
> `-sda1        8:1    1  256M  0 part
> mmcblk0     179:0    0 29.2G  0 disk
> |-mmcblk0p4 179:4    0    4G  0 part
> |-mmcblk0p2 179:2    0  500M  0 part /boot
> |-mmcblk0p3 179:3    0  256M  0 part [SWAP]
> `-mmcblk0p1 179:1    0  256M  0 part /boot/efi
> 
> btrfs fi show /
>   Label: none  uuid: 07892354-ddaa-4443-90ea-f76a06accaba
>   Total devices 1 FS bytes used 1.40GiB
>   devid    1 size 4.00GiB used 3.00GiB path /dev/sda4
> 
> The bug is quite nasty that you can't either unmount /dev/sda4 or
> /dev/mmcblk0p4. And the problem does not get solved until you take
> sda out of the system on to another system to change its fsid
> using the 'btrfstune -u' command.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> 
> Hi,
> 
> There was previous attempt to fix this bug ref:
>     www.spinics.net/lists/linux-btrfs/msg37466.html
> 
> which broke the Ubuntu subvol mount at boot. The reason
> for that is, Ubuntu changes the device path in the boot
> process, and the earlier fix checked for the device-path
> instead of block_device as in here and so we failed the
> subvol mount request and thus the bootup process.
> 
> I have tested this with Oracle Linux with btrfs as boot device
> with a subvol to be mounted at boot. And also have verified
> with new test case btrfs/173.
> 
> It will be good if someone run this through Ubuntu boot test case.
> 
>   fs/btrfs/volumes.c | 23 +++++++++++++++++++++++
>   1 file changed, 23 insertions(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index f4405e430da6..62173a3abcc4 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -850,6 +850,29 @@ static noinline struct btrfs_device *device_list_add(const char *path,
>   			return ERR_PTR(-EEXIST);
>   		}
>   
> +		/*
> +		 * we are going to replace the device path, make sure its the
> +		 * same device if the device mounted
> +		 */
> +		if (device->bdev) {
> +			struct block_device *path_bdev;
> +
> +			path_bdev = lookup_bdev(path);
> +			if (IS_ERR(path_bdev)) {
> +				mutex_unlock(&fs_devices->device_list_mutex);
> +				return ERR_CAST(path_bdev);
> +			}
> +
> +			if (device->bdev != path_bdev) {
> +				bdput(path_bdev);
> +				mutex_unlock(&fs_devices->device_list_mutex);
> +				return ERR_PTR(-EEXIST);
It would be _really_ nice to have an informative error message printed 
here.  Aside from the possibility of an admin accidentally making a 
block-level copy of the volume, this code triggering could represent an 
attempted attack against the system, so it's arguably something that 
should be reported as happening.  Personally, I think a WARN_ON_ONCE for 
this would make sense, ideally per-volume if possible.
> +			}
> +			bdput(path_bdev);
> +			pr_info("BTRFS: device fsid:devid %pU:%llu old path:%s new path:%s\n",
> +				disk_super->fsid, devid, rcu_str_deref(device->name), path);
> +		}
> +
>   		name = rcu_string_strdup(path, GFP_NOFS);
>   		if (!name) {
>   			mutex_unlock(&fs_devices->device_list_mutex);
> 

