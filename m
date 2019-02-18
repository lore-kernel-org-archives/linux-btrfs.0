Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3675C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 21:06:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7841F217F5
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 21:06:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="MQv4Y//5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbfBRVGw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 16:06:52 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37563 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfBRVGv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 16:06:51 -0500
Received: by mail-lj1-f193.google.com with SMTP id r10-v6so15579321ljj.4
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2019 13:06:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1TcnnakyoFuI7sus1zjPcpTaynWC9SRPIhuKuVO+81o=;
        b=MQv4Y//5Lq7ZI1UfDqcpLrrZZlAQqbai5iBduPUp80lXwOcmfsL3Z0addvLM0aWOM1
         MvhV+rHoC6RMSfyHfxhmZ9AJ7/4QhJhzf9YGakWdhzumvgGKnyg9QbFgu0ch95/exCvF
         QtFoqX04ZzWtOG6bqZiDsadUqntBgijwQwpOYGiqAyQNGDIMBaDCi+VzZEXDpcahBzoA
         slup3pMPUp40UKZmvlunfwlfqlbuOnLHbTbAgp1m7QsvXbKxL9CX5WWmtXyvMjtS+lr/
         lFek777cU7FLgi+fod64iVLc1roNFhqa77DIGLd8ZLJvGOuud1Ccj5PWI1z0SD+iLiJT
         BfUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1TcnnakyoFuI7sus1zjPcpTaynWC9SRPIhuKuVO+81o=;
        b=DtnYWS0ceGYOsJtTDUSNkFIjaVXsyflfnZCrQbNC0w8kj30aZo8Kq11fLzupZTL5tM
         jgSroDAfQ3yQo5v9PwU6WLOe0rx7srBdDzFDLixVVZ2E1tnw/yHG/bVFHioMdgdCISQJ
         3H9k5rRKhTfuHwrSUXvTT9I4cwctivamPHGItxTCwCb7Tq/rsmjv37sDapAHcOIlvN0p
         9zjdBcFBxeKy8Akoq8M5GA+mWQJ/j7pNDd4cMQD3fH4zhdsoelMfOIbbuK4M8uSfaJa6
         9GybrjgT4fIwOTqvMRuS398mkbDy7kL2Wo5G6/y4CzC0gD+CV6jCasD9zEEsNRTsrbHZ
         yFWA==
X-Gm-Message-State: AHQUAuZuBUNEMVnE7NB/xeuTxju3uEXOFdoa3GcSxRX5bwoGDscUrX/x
        HpYKOgWfgsKPWXkImT0oOgyHuHngjdH97cv6mr4trE8x
X-Google-Smtp-Source: AHgI3IbKxVHrfSpn3JElA3DLwDHbtN2he1Am9mBv3sjG4lV+EvT3hOkiiamNhHLnhNf//zJghUAS67vtFX54RN+bL4E=
X-Received: by 2002:a2e:9a09:: with SMTP id o9-v6mr15150775lji.132.1550524008438;
 Mon, 18 Feb 2019 13:06:48 -0800 (PST)
MIME-Version: 1.0
References: <7ef0e91501a04cd4c5e0d942db638a0b50ef3ec3.camel@seblu.net>
 <CAJCQCtQ+b9y7fBXPPhB-gQrHAH-pCzau6nP1OabsC1GNqNnE1w@mail.gmail.com> <91e2c9ef095eae21f9e88f7b5cf49102571dcba8.camel@seblu.net>
In-Reply-To: <91e2c9ef095eae21f9e88f7b5cf49102571dcba8.camel@seblu.net>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 18 Feb 2019 14:06:36 -0700
Message-ID: <CAJCQCtTq8YLmti_tf0oNaSGn94qvGxs-mQeDdvxddE61L0Rjdg@mail.gmail.com>
Subject: Re: Corrupted filesystem, looking for guidance
To:     =?UTF-8?Q?S=C3=A9bastien_Luttringer?= <seblu@seblu.net>
Cc:     Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 18, 2019 at 1:14 PM S=C3=A9bastien Luttringer <seblu@seblu.net>=
 wrote:
>
> On Tue, 2019-02-12 at 15:40 -0700, Chris Murphy wrote:
> > On Mon, Feb 11, 2019 at 8:16 PM S=C3=A9bastien Luttringer <seblu@seblu.=
net> wrote:
> >
> > FYI: This only does full stripe reads, recomputes parity and overwrites=
 the
> > parity strip. It assumes the data strips are correct, so long as the
> > underlying member devices do not return a read error. And the only way =
they
> > can return a read error is if their SCT ERC time is less than the kerne=
l's
> > SCSI command timer. Otherwise errors can accumulate.
> >
> > smartctl -l scterc /dev/sdX
> > cat /sys/block/sdX/device/timeout
> >
> > The first must be a lesser value than the second. If the first is disab=
led
> > and can't be enabled, then the generally accepted assumed maximum time =
for
> > recoveries is an almost unbelievable 180 seconds; so the second needs t=
o be
> > set to 180 and is not persistent. You'll need a udev rule or startup sc=
ript
> > to set it at every boot.
> All my disks firmwares doesn't allow ERC to be modified trough SCT.
>
>    # smartctl -l scterc /dev/sda
>    smartctl 7.0 2018-12-30 r4883 [x86_64-linux-4.19.20-seblu] (local buil=
d)
>    Copyright (C) 2002-18, Bruce Allen, Christian Franke, www.smartmontool=
s.org
>
>    SCT Error Recovery Control command not supported
>
> I was not aware of that timer. I needed time to read and experiment on th=
is.
> Sorry for the long response time. I hope you didn't timeout. :)
>
> After simulated several errors and timeouts with scsi_debug[1],
> fault_injection[2], and dmsetup[3], I don't understand why you suggest th=
is
> could lead to corruption. When an SCSI command timeout, the mid-layer[4] =
do
> several error recovery attempt. These attempts are logged into the kernel=
 ring
> buffer and at worst the device is put offline.

No at worst what happens if SCSI command timer is reached before the
drive's SCT ERC timeout, is the kernel assumes the device is not
responding and does a link reset. That link reset obiterates the
entire command queue on SATA drives. And that means it's no longer
possible to determine what sector is having a problem; and therefore
not possible to fix it by overwriting that sector with good data. This
is a problem for Btrfs raid, as well as md and LVM.


>
> From my experiment, the md layer has no timeout, and waits as long as the
> underlying layer doesn't return, either during check or normal read/write
> attempt.
>
> I understand the benefits of keeping the disk time to recover from errors=
 below
> the hba timeout. It prevents the disk to be kicked out of the array.

The md driver tolerates a fixed number or rate (I'm not sure which) of
read errors before a drive is marked faulty. The md driver I think
tolerates only one write failure, and then the drive is marked faulty.

So far there is no faulty concept in Btrfs, there are patches upstream
for this, but I don't know about their merge status.


> However, I don't see how this could lead to a difference between check an=
d
> repair in the md layer and even trigger some corruption between the chunk=
s
> inside a stipe.

It allows bad sectors to accumulate, because they never get repaired.
The only way they can be repaired is if the drive itself gives up on a
sector, and reports a discrete uncorrected read error along with the
sector LBA. That's the only way the md driver knows what md chunk is
affected, and where to get a good copy, read it, and then overwrite
the bad copy on the device with a read error.

The linux-raid@ list is full of examples of this. And it does
sometimes lead to the loss of the array, in particular in the case of
parity arrays where such read errors tend to be colocated. A read
error in a stripe is functionally identical to a single device loss
for that stripe. So if the bad sector isn't repaired, only one more
error is needed and you get a full stripe loss, and it's not
recoverable. If the lost stripe is (user) data only then you just lose
a file. But if the lost stripe contains file system metadata it can
mean the loss of the file system on that md array.


> After reading the whole md (5) manual, I realize how bad it is to rely on=
 the
> md layer to guaranty data integrity. There is no mechanism to known which=
 chunk
> is corrupted in a stripe.

Correct. There is a tool part of mdadm that will do this if it's a raid6 ar=
ray.

> I'm wondering if using btrfs raid5, despite its known flaws, it is not sa=
fer
> than md.

I can't point to a study that'd give us the various probabilities to
answer this question. In the meantime, I'd say all raid5 is fraught
with peril the instant there's any unhandled corruption or read error.
And it's a very common misconfiguration to have consumer SATA drives
that lack configurable SCT ERC so that it's less time to produce an
error, than for the SCSI command timer to cause a link reset.


>
> > Further, if the mismatches are consistently in the same sector range, i=
t
> > suggests the repair scrub returned one set of data, and the subsequent =
check
> > scrub returned different data - that's the only way you get mismatches
> > following a repair scrub.
> It was the same range. That was my understanding too.
>
> I finally get ride of these errors by removing a disk, wiping the superbl=
ock
> and adding it back to the raid. Since then, no check error (tested twice)=
.

*shrug* I'm not super familiar with all the mdadm features. It's
vaguely possible your md array is using the bad block mapping feature,
and perhaps that's related to this behavior. Something in my memory is
telling me that this isn't really the best feature to have enabled in
every use case; it's really strictly for continuing to use drives that
have all reserve sectors used up, which means bad sectors result in
write failures. The bad block mapping allows md to do its own
remapping so there won't be write failures in such a case.

Anyway, raids are complicated and they are something of a Rube
Goldberg contraption. If you don't understand all the  possible
outcomes, and aren't prepared for failures, it can lead to panic. And
I've read on linux-raid a lot of panic induced dataloss. Really common
is people do google searches first and get bad advice like recreating
an array and then they wonder why there array is wiped... *shrug*

My advice is, don't be in a hurry to fix things when they go wrong.
Collect information. Do things that don't write changes anywhere. Post
all information to the proper mailing list working from the bottom
(start) of the storage stack to the top (the file system), and trust
their advise.


>
> > If it's bad RAM, then chances are both copies of metadata will be ident=
ically
> > wrong and thus no help in recovery.
> RAM is not ECC. I tested the RAM recently and no error was found.

You might check the archives about various memory testing strategies.
A simple hour long test often won't find the most pernicious memory
errors. At least do it over a weekend.

Quick search austin hemmelgarn memory test compile and I found this thread:

Re: btrfs ate my data in just two days, after a fresh install. ram and
disk are ok. it still mounts, but I cannot repair
Wed, May 4, 2016, 10:12 PM


> But, I needed more RAM to rsync all the data w/ hardlinks, so I added a s=
wap
> file on my system disk (an ssd). The filesystem on it is also btrfs, so I=
 used
> a loop device to workaround the hole issue.
> I can find some link reset on this drive at time it was used as swap file=
.
> Maybe this could be a reason.

Yeah, if there is a link reset on the drive, the whole command queue
is lost. It could cause a bunch of i/o errors that look scary but are
one time errors that are related to the link reset. So you really
don't want the link resets happening.

Conversely many applications get mad if there really is a hang for 180
seconds for a consumer drive to do deep recovery. So it's a catch 22
if you use case can tolerate it. But hopefully you only rarely have
bad sectors anyway. Once nice thing about Btrfs is you can do a
balance and it causes everything to be written out, which itself
"refreshens" sector data with a stronger signal. You probably
shouldn't have to do that too often, maybe once every 12-18 months.
Otherwise, too many bad sectors is a valid warranty claim.


> I think I will remove the md layer and use only BTRFS to be able to recov=
er
> from silent data corruption.

Btrfs on top of md will still repair metadata from data corruption if
the metadata profile is DUP.

And in the case of (user) data corruption, it's still not silent.
Btrfs will tell you what file is corrupt and you can recover it from a
backup.

I can't tell you that Btrfs raid5 with a missing/failed drive is
anymore reliable than md raid5. In a way it's simpler so that might be
to your advantage, it really depends on your comfort and experience
with user space tools.

If you do want to move to strictly Btrfs, I suggest raid5 for data but
use raid1 for metadata instead of raid5. Metadata raid 5 writes can't
really be assured to be atomic. Using raid1 metadata is less fragile.

No matter what, keep backups up to date, always be prepared to have to
use them. The main idea of any raid is to just give you some extra
uptime in the face of a failure. And the uptime is for your
applications.

> But I'm curious to be able to repair a broken BTRFS without moving all th=
e
> dataset to another place. It's the second time it happen to me.
>
> I tried:
> # btrfs check --init-extent-tree /dev/md127
> # btrfs check --clear-space-cache v2 /dev/md127
> # btrfs check --clear-space-cache v1 /dev/md127
> # btrfs rescue super-recover /dev/md127
> # btrfs check -b --repair /dev/md127
> # btrfs check --repair /dev/md127
> # btrfs rescue zero-log /dev/md127

Wrong order. Not obvious either that it's the wrong order, the tools
don't do a great job of telling us what order to do things in. Also,
all of these involve writes. You really need to understand the problem
first.

zero log means some last minute writes will be lost, and it should
only be used if there's difficulty mounting and the kernel errors
point to a problem with log replay.

clear-space is safe, the cache is recreated at next mount time, so it
might result in slow initial mount after use.

super-recover is safe by itself or with -v. It should be safe with -y
but -y does write changes to disk.

--init-extent-tree is about the biggest hammer in the arsenal and
fixes only a very specific problem with the extent tree and usually
doesn't help just makes things worse.

--repair should be safe but even in 4.20.1 tools you'll see the man
page says it's dangerous and you should ask on list before using it.


> The detailed output is here [6]. But none of the above allowed me to drop=
 the
> broken part of the btrfs tree to move forward. Is there a way to repair (=
by
> loosing corrupted data) without need to drop all the correct data?

Well at this point if you ran a those commands the file system is
different so you should refresh the thread by posting current normal
mount (no options) kernel messages; and also 'btrfs check' output
without repair; and also output from btrfs-debug-tree. If the problem
is simple enough and a dev has time it might be they get you a file
system specific patch to apply and it can be fixed. But it's really
important that you stop making changes to the file system in the
meantime. Just gather information. Be deliberate.


--
Chris Murphy
