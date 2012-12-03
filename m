Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m59-178.qiye.163.com ([123.58.178.59]:46136 "EHLO
	m59-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab2LCHwr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2012 02:52:47 -0500
Received: from mail-lb0-f174.google.com (mail-lb0-f174.google.com [209.85.217.174])
	by m59-178.qiye.163.com (HMail) with ESMTPA id 5C98D810459
	for <linux-btrfs@vger.kernel.org>; Mon,  3 Dec 2012 15:52:42 +0800 (CST)
Received: by mail-lb0-f174.google.com with SMTP id gi11so2090055lbb.19
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Dec 2012 23:52:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <B41E960E-A16B-4856-AFFE-FC5C99DDC7D5@colorremedies.com>
References: <B41E960E-A16B-4856-AFFE-FC5C99DDC7D5@colorremedies.com>
From: Rock Lee <zimilo@code-trick.com>
Date: Mon, 3 Dec 2012 15:52:00 +0800
Message-ID: <CAMRmmpJM_BSr9Q7aPWBdHiOqtpegiz03H=eJSwB5Wm5EgCFheA@mail.gmail.com>
Subject: Re: 64KB "boot sector" gap
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Maybe this function could give you a little explanation.

static inline u64 btrfs_sb_offset(int mirror)
{
    u64 start = 16 * 1024;
    if (mirror)
        return start << (BTRFS_SUPER_MIRROR_SHIFT * mirror);
    return BTRFS_SUPER_INFO_OFFSET;
}

and BTRFS_SUPER_INFO_OFFSET is (64 * 1024)


2012/12/3 Chris Murphy <lists@colorremedies.com>:
> When creating a btrfs volume with mkfs.btrfs, I'm noticing that the first 64KB are completely blank. Is this gap expressly intended for installing a boot manager/loader? e.g. GRUB 2 allows installation of boot.img + core.img into a btrfs formatted partition, without using block lists (the --force flag). It appears to produce a bootable system.
>
> However, the man page says -A, --alloc-start specifies the offset to the start of the file system, and that the default is zero. If the default is zero, the file system starts immediately, which implies those 64KB of zero aren't actually intended for a boot loader.
>
> In all three of these examples:
> mkfs.btrfs /dev/sda1
> mkfs.btrfs -A 5000 /dev/sda1
> mkfs.btrfs -A 50000 /dev/sda1
>
> I get the same results for:
> hexdump -C /dev/sda1
>
> 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00010000  66 0d 21 28 00 00 00 00  00 00 00 00 00 00 00 00  |f.!(….........|
>
> The file system appears to start at the same point in all cases. I zero'd the first 500MB of the partition in between each mkfs attempt.
>
> What am I misunderstanding, or is this a bug?
>
>
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

