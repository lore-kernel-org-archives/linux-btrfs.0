Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:37151 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750729Ab2LCHyc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Dec 2012 02:54:32 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: 64KB "boot sector" gap
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAMRmmpJM_BSr9Q7aPWBdHiOqtpegiz03H=eJSwB5Wm5EgCFheA@mail.gmail.com>
Date: Mon, 3 Dec 2012 00:54:30 -0700
Message-Id: <91713ECE-00FA-4074-9C21-5375E374FEC1@colorremedies.com>
References: <B41E960E-A16B-4856-AFFE-FC5C99DDC7D5@colorremedies.com> <CAMRmmpJM_BSr9Q7aPWBdHiOqtpegiz03H=eJSwB5Wm5EgCFheA@mail.gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No idea what that means.


On Dec 3, 2012, at 12:52 AM, Rock Lee <zimilo@code-trick.com> wrote:

> Maybe this function could give you a little explanation.
> 
> static inline u64 btrfs_sb_offset(int mirror)
> {
>    u64 start = 16 * 1024;
>    if (mirror)
>        return start << (BTRFS_SUPER_MIRROR_SHIFT * mirror);
>    return BTRFS_SUPER_INFO_OFFSET;
> }
> 
> and BTRFS_SUPER_INFO_OFFSET is (64 * 1024)
> 
> 
> 2012/12/3 Chris Murphy <lists@colorremedies.com>:
>> When creating a btrfs volume with mkfs.btrfs, I'm noticing that the first 64KB are completely blank. Is this gap expressly intended for installing a boot manager/loader? e.g. GRUB 2 allows installation of boot.img + core.img into a btrfs formatted partition, without using block lists (the --force flag). It appears to produce a bootable system.
>> 
>> However, the man page says -A, --alloc-start specifies the offset to the start of the file system, and that the default is zero. If the default is zero, the file system starts immediately, which implies those 64KB of zero aren't actually intended for a boot loader.
>> 
>> In all three of these examples:
>> mkfs.btrfs /dev/sda1
>> mkfs.btrfs -A 5000 /dev/sda1
>> mkfs.btrfs -A 50000 /dev/sda1
>> 
>> I get the same results for:
>> hexdump -C /dev/sda1
>> 
>> 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>> *
>> 00010000  66 0d 21 28 00 00 00 00  00 00 00 00 00 00 00 00  |f.!(….........|
>> 
>> The file system appears to start at the same point in all cases. I zero'd the first 500MB of the partition in between each mkfs attempt.
>> 
>> What am I misunderstanding, or is this a bug?
>> 
>> 
>> Chris Murphy--
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



