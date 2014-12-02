Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-11v.sys.comcast.net ([96.114.154.170]:44043 "EHLO
	resqmta-po-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932550AbaLBUam (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Dec 2014 15:30:42 -0500
Message-ID: <547E216D.6000405@pobox.com>
Date: Tue, 02 Dec 2014 12:30:37 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Shriramana Sharma <samjnaa@gmail.com>, dsterba@suse.cz,
        Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Moving an entire subvol?
References: <CAH-HCWVcu9FW0c3zwEg_KR_yaPGRQ58yHbXsUx1JCKRu4s7NXQ@mail.gmail.com> <CAJCQCtT3EeGUOpZ9q78BcWv_Cc_5UGY=uPVJX+bqex9Zo_bWYg@mail.gmail.com> <CAH-HCWUSX+N2Byo4vpCxac89TSX2YGoP39VgFsq6952k9V9cmQ@mail.gmail.com> <20141202132842.GT12140@twin.jikos.cz> <CAH-HCWVubkp+viAEVqGoJFxJ_t1chTVC08xm6A15ucosqbWqxQ@mail.gmail.com>
In-Reply-To: <CAH-HCWVubkp+viAEVqGoJFxJ_t1chTVC08xm6A15ucosqbWqxQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/02/2014 07:11 AM, Shriramana Sharma wrote:
> On Tue, Dec 2, 2014 at 6:58 PM, David Sterba <dsterba@suse.cz> wrote:
>>
>> A subvolume is also a snapshotting barrier, so it's convenient to create
>> subvolumes in well-known paths that contain data that should not be
>> rolled back (/var/log, /srv, bootloader).

> That makes sense. Is there anywhere that the "official" SuSE
> recommended subvol layout is mentioned that I can refer to without
> having to start up an installer? (I currently chose ext4 for / for
> other reasons so I can't refer to my layout.)

There are lots of ways to arrange your system

My preference is to create the snapshots in a super-volume outside of 
the normally mounted hierarchy. This simplifies the normal operation of 
tools like "locate" which don't understand that the duplicate files from 
the snapshot are not interesting. It also means that live operations 
(e.g. anything using "find") naturally will not traverse the snapshots 
unless the supervolume is mounted explicitly.

I typically call the active root of the system /__System and set it as 
the default subvolume to make booting easier.

As in...

mkfs.btrfs /dev/whatever
mount /dev/whatever /mnt
btrfs sub create /mnt/__System
btrfs sub create /mnt/__System/home
btrfs sub set-default (number) /mnt
umount /mnt
mount /mnt
(create OS layout in /mnt)


Then when the snapshotting goes on...

mount -o subvol=/ /dev/whatever /maintenance
SUFFIX=$(date "+_BACKUP_%Y-%M-%d")
cd /maintenance
btrfs sub snap -r __System __System${SUFFIX}
btrfs sub snap -r __System/home __System_home${SIFFIX}
# etc
cd /
umount /maintenance


---

The Real Way™ to think about your active subvolume layouts is to think 
about what you really need to preserve and how often.

/home is an obvious candidate for frequent snapshots as it is the place 
individual users are most likely to mess up, and it has the most 
"irreplaceable" data.

/ (e.g. the semantic system root) [in my example /__System] [not 
counting its various subvolumes really only needs backing up before 
system software modifications via apt/yumm/portage/wahtever your distro 
uses. Or right before you start doing aything "tricky" in /etc

/etc  might rate its own subvolume if you are a tinker or your 
system-wide configuration needs a lot of motility.

/var tends to have per system configuration stuff


But the real question is "how much complexity of maintenance does the 
system _really_ need, and how much of it are you _really_ going to maintain.

The desire to use a feature "just 'cause it's there" should be resisted. 
If you are not going to be using the snapshots feature. If you are just 
dropping the box in and you are going to ignore it, then don't subvolume 
it at all.

You are looking for a balance between the theoretical ideal and the 
practical outcome. If you don't know exactly why you are putting the 
subvolume in place then it will likely just end up annoying you without 
giving any value.

Same for taking and positioning the snapshots.

This is a corollary of the rule that states "A backup script that you've 
never done a restore from, should be assumed to be an _unsafe_ or 
complete backup, or no backup at all."


