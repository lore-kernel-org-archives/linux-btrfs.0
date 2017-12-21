Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:40112 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755834AbdLUBeU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 20:34:20 -0500
Received: by mail-oi0-f65.google.com with SMTP id w125so15909142oie.7
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Dec 2017 17:34:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <7313f511-e4e9-3ceb-b2a1-c3d197a9625b@gmail.com>
References: <5A357909.8010206@yandex.ru> <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk> <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
 <20171218194351.GA25245@polanet.pl> <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
 <20171219144644.GA9855@polanet.pl> <639c6928-4f27-5c33-738a-385e5b4f299f@gmail.com>
 <20171219175633.GA19477@polanet.pl> <CAJCQCtT+DjUDf3NBEQNxYm6SRhDL_FFXpz===fgub_k+AMmABg@mail.gmail.com>
 <2532cc1d-bbe4-a140-8c69-beecb2b73f79@gmail.com> <CAJCQCtR5HnDSOepiv4r4=kiL1P969oSyS1fr6UGUz23ksj-OYg@mail.gmail.com>
 <CAJCQCtTAbZ9Uf2pL_2KtHV3pSkpVhuo+DzwA9M2ZFL8=QUJxAg@mail.gmail.com> <7313f511-e4e9-3ceb-b2a1-c3d197a9625b@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 20 Dec 2017 18:34:19 -0700
Message-ID: <CAJCQCtQMztjXJCF7DaEEx+zBjx6PtifAnidya8Z3fpu-3hYLcA@mail.gmail.com>
Subject: Re: Unexpected raid1 behaviour
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>, Tomasz Pala <gotar@polanet.pl>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 20, 2017 at 1:14 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2017-12-20 15:07, Chris Murphy wrote:

>> There is an irony here:
>>
>> YaST doesn't have Btrfs raid1 or raid10 options; and also won't do
>> encrypted root with Btrfs either because YaST enforces LVM to do LUKS
>> encryption for some weird reason; and it also enforces NOT putting
>> Btrfs on LVM.
>
> The 'LUKS must use LVM' thing is likely historical.  The BCP for using LUKS
> is that it's at the bottom level (so you leak absolutely nothing about how
> your storage stack is structured), and if that's the case you need something
> on top to support separate filesystems, which up until BTRFS came around has
> solely been LVM.

*shrug* Anaconda has supported plain partition LUKS without
device-mapper for ext3/4 and XFS since forever, even before the
rewrite.


>> Meanwhile, Fedora/Red Hat's Anaconda installer has supported both of
>> these use cases for something like 5 years (does support Btrfs raid1
>> and raid10 layouts; and also supports Btrfs directly on dmcrypt
>> without LVM) - with the caveat that it enforces /boot to be on ext4.
>
> And this caveat is because for some reason Fedora has chosen not to
> integrate BTRFS support into their version of GRUB.

No. The Fedora patchset for upstream GRUB doesn't remove Btrfs
support. However, they don't use grub-mkconfig to rewrite the grub.cfg
when a new kernel is installed. Instead, they use an unrelated project
called grubby, which modifies the existing grub.cfg (and also supports
most all other configs like syslinux/extlinux, yaboot, uboot, lilo,
and others). And grubby gets confused [1] if the grub.cfg is on a
subvolume (other than ID 5). If the grub.cfg is in the ID 5 subvolume,
in a normal directory structure, it works fine.

Chris Murphy



[1] Gory details

The central part of the confusion appears to be this sequence of
comments in this insanely long bug:
https://bugzilla.redhat.com/show_bug.cgi?id=864198#c3
https://bugzilla.redhat.com/show_bug.cgi?id=864198#c5
https://bugzilla.redhat.com/show_bug.cgi?id=864198#c6
https://bugzilla.redhat.com/show_bug.cgi?id=864198#c7

The comments from Gene Czarcinski (now deceased, that's how old this
bug is) try to negotiate understanding the problem and he had a fix
but it didn't meet some upstream grubby requirement, and so the patch
wasn't accepted. Grubby is sufficiently messy that near as I can tell
no other distribution uses it, and no one really cares to maintain it
until something in RHEL breaks and then *that* gets attention.

Upstream bug
https://github.com/rhboot/grubby/issues/22
