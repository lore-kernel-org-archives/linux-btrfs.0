Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f170.google.com ([209.85.216.170]:65394 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab3ESNnR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 May 2013 09:43:17 -0400
Received: by mail-qc0-f170.google.com with SMTP id s11so1270424qcw.15
        for <linux-btrfs@vger.kernel.org>; Sun, 19 May 2013 06:43:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <10727333.ycOo9UTNXM@merkaba>
References: <1367830418-26865-1-git-send-email-zwu.kernel@gmail.com>
	<CAEH94LgHqyFHhmdPE439hQQFGNCVyraDq0ta0XV1kCGnNDi0yg@mail.gmail.com>
	<10727333.ycOo9UTNXM@merkaba>
Date: Sun, 19 May 2013 21:43:14 +0800
Message-ID: <CAEH94LjW-5azrjN+fz8YDMqT4jW3hjm3mLj7HVeuSKrXWS=MBQ@mail.gmail.com>
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
I also really want to see this will happen.
>
> ZFS and BTRFS have shown that RAID support within the filesystem can make a lot
> of sense. I think hot relocation is another area which can be done more
> accurate within the filesystem. I think there are several features only
> possible by going this route:
>
> 1) Mark files as hot via ioctl. MySQL can mark InnoDB journal files for example.
It has been implemented to get its hot status of one specified file
via ioctl. It is not hard to enable its set function. Before it is
done, i more hope that the core of VFS hot tracking can get merged by
kernel upstream. You know, it is harder if too new functions have been
done.
We can put it in to-do list at first, what do you think?
>
> 2) Proper BTRFS RAID support (as noted elsewhere in this thread)
>
> 3) Easier setup. With BTRFS flexibility I would expect that a SSD as hot data
> cache can be added and removed on the fly during filesystem is mounted. Only
> seems supported at mkfs-time as I read the patch docs, but from my basic
> technical understanding of BTRFS it can be extented to be done on the fly with
> a mounted FS as well.
Yes, it is supported only at mkfs time. It shouldn't be hard to enable
adding or removing a nonrotating disk as hot cache on the fly. You
know, before this is done, i would like to make sure that the current
design for BTRFS hot relocation is this RFC patchset is going in the
direction and is appropriate. If it is going in wrong direction, we
will be doing a lot of meanless work. E.g. How about the current idea
on introducing one new block group for nonrotating disks.
When working on this work, i were trying to change the least current
btrfs code as far as possible. You know, if we change too many current
btrfs code, it will introduce regression bug more easily, and so the
patchset will be also harder to get accepted by btrfs upstream.

What do you think?

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
