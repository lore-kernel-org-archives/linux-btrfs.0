Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f50.google.com ([209.85.216.50]:37438 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab3ESNq3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 May 2013 09:46:29 -0400
Received: by mail-qa0-f50.google.com with SMTP id bn16so1135573qab.9
        for <linux-btrfs@vger.kernel.org>; Sun, 19 May 2013 06:46:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <10727333.ycOo9UTNXM@merkaba>
References: <1367830418-26865-1-git-send-email-zwu.kernel@gmail.com>
	<CAEH94LgHqyFHhmdPE439hQQFGNCVyraDq0ta0XV1kCGnNDi0yg@mail.gmail.com>
	<10727333.ycOo9UTNXM@merkaba>
Date: Sun, 19 May 2013 21:46:28 +0800
Message-ID: <CAEH94LiQCVRrESkppE2jAwpVQdfM+6GcN5zA6p4Y3CAAmsktzA@mail.gmail.com>
Subject: Re: [RFC 0/5] BTRFS hot relocation support
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org, sekharan@us.ibm.com, chris.mason@fusionio.com,
        Ilya Dryomov <idryomov@gmail.com>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 19, 2013 at 6:41 PM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> Am Donnerstag, 9. Mai 2013, 07:13:56 schrieb Zhi Yong Wu:
>> HI, all
>
> Hi!
>
>>    I saw that bcache will be merged into kernel upstream soon, so i
>> want to know if btrfs hot relocation support is still meanful, if no,
>> i will not continue to work on it. can anyone let me know this?
>> thanks.
>
> I really look forward to VFS hot data tracking with BTRFS (and other
> filesystem) support.
>
> ZFS and BTRFS have shown that RAID support within the filesystem can make a lot
> of sense. I think hot relocation is another area which can be done more
> accurate within the filesystem. I think there are several features only
> possible by going this route:
>
> 1) Mark files as hot via ioctl. MySQL can mark InnoDB journal files for example.
>
> 2) Proper BTRFS RAID support (as noted elsewhere in this thread)
After the current design draft for BTRFS hot relocation in this RFC
get basic agreement as btrfs community, maintainer or main developers,
i will dive into this further.
By the way, it is in my to-do list, thanks.
>
> 3) Easier setup. With BTRFS flexibility I would expect that a SSD as hot data
> cache can be added and removed on the fly during filesystem is mounted. Only
> seems supported at mkfs-time as I read the patch docs, but from my basic
> technical understanding of BTRFS it can be extented to be done on the fly with
> a mounted FS as well.
>
>
> Block based caching can make sense for other use cases like raw device with
> Oracle DB on it or maybe a swap device. Or for filesystems not (yet) supporting
> VFS hot data tracking.
>
> Thanks,
> --
> Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
> GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7



--
Regards,

Zhi Yong Wu
