Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f43.google.com ([209.85.213.43]:32944 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbbCSCzG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Mar 2015 22:55:06 -0400
Received: by yhpt93 with SMTP id t93so22109413yhp.0
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2015 19:55:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <550A1CA1.9040303@suse.com>
References: <5509E34F.6010504@graphitesystems.com>
	<CAJCQCtSmV63H4OnEgv2ZXSFq4s8npEGmDxUBDO5dHb7pmoC0zw@mail.gmail.com>
	<5509F08E.6070702@graphitesystems.com>
	<20150318215512.GC31762@carfax.org.uk>
	<550A03B3.8020005@graphitesystems.com>
	<CAJCQCtRvbiKAQ3iwA6y0QXNaYPnXUh7nf7AGF89Xj48q3GWUpw@mail.gmail.com>
	<550A1CA1.9040303@suse.com>
Date: Wed, 18 Mar 2015 20:55:05 -0600
Message-ID: <CAJCQCtThNYw+DDnWuBst5=T5yAEN25xaTWFZB=YcPaKPwNBC+A@mail.gmail.com>
Subject: Re: syntax for deleting subvolumes?
From: Chris Murphy <lists@colorremedies.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 18, 2015 at 6:47 PM, Jeff Mahoney <jeffm@suse.com> wrote:
> We use this layout in SLES too and it's necessary for both compliance
> and principle-of-lease-surprise purposes in concert with our
> snapshot-rollback facility.

I understand the logic, I'm just not convinced it's the only way to
achieve that. It's kinda like 28 GPT partitions on the typical
Android/Cyanogen mobile phone — as long as everything works and you
don't interact with it, it's fine. But as soon as you need to
understand it, I think this layout and what's going on is non-obvious.

After a clean installation, and updates, it looks like this:

# btrfs sub list /
ID 257 gen 36 top level 5 path boot/grub2/i386-pc
ID 258 gen 36 top level 5 path boot/grub2/x86_64-efi
ID 259 gen 24 top level 5 path opt
ID 260 gen 36 top level 5 path srv
ID 261 gen 101 top level 5 path tmp
ID 262 gen 36 top level 5 path usr/local
ID 263 gen 36 top level 5 path var/crash
ID 264 gen 36 top level 5 path var/lib/mailman
ID 265 gen 36 top level 5 path var/lib/named
ID 266 gen 36 top level 5 path var/lib/pgsql
ID 267 gen 101 top level 5 path var/log
ID 268 gen 36 top level 5 path var/opt
ID 269 gen 101 top level 5 path var/spool
ID 270 gen 101 top level 5 path var/tmp
ID 275 gen 101 top level 5 path .snapshots
ID 276 gen 38 top level 275 path .snapshots/1/snapshot
ID 277 gen 41 top level 275 path .snapshots/2/snapshot
ID 278 gen 43 top level 275 path .snapshots/3/snapshot
ID 279 gen 46 top level 275 path .snapshots/4/snapshot
ID 282 gen 81 top level 275 path .snapshots/5/snapshot
ID 283 gen 97 top level 275 path .snapshots/6/snapshot

I reckognize that these subvolumes exist to *exclude* them from the
snapshotting policies, rather than to include them. That's part of the
typical user confusion, since subvolumes are associated with making
snapshots rather than avoiding them.

Plus it also confuses the hell out of the RH/Fedora installer which
ends up seeing every snapshot as a completely separate unique openSUSE
installation - because the distros haven't had any sort of
conversation about interoperability in this brave new world.
https://bugzilla.redhat.com/attachment.cgi?id=983116



> If you roll back your root file system,
> would you really expect to lose all your logs? How about your mail?

Of course not. I just disagree that there's only one way to manage this.

For the most part the "OS" is in /usr, and users' stuff is in /home,
and then there's everything else which includes /etc, /var, and /boot
being the things that change state the most at a system level. I would
like to see applications have an explicit home. This is a huge problem
on linux as they spread themselves throughout the filesystem. And
mobile platforms, apps are in a separate place, on Linux
desktop/server I should be able to revert applications separate from
an OS update, those two things aren't the same thing.

I'd also prefer seeing updates/upgrades handled differently. Create
the proper snapshots, upgrade the snapshots in a container, boot the
upgraded snapshot in a container to test its viability, and if
successful then make it a new boot option at next boot; if it fails
then obliterate the snapshot. This makes for atomic upgrades that
aren't yanking or modifying files out from running processes, and
permits indefinitely delayed reboots.

And eventually I really want to get to stateless systems on Linux.
Mobile platforms have surpassed desktop/server Linux in this regard.
Even Windows 8+ have surpassed it, with system refresh and reset
options.

I'm all for refining the granularity, but I think the subvolume as
snapshot exclusion is messy and confusing. I have to use snapper to
figure out the relationship of anything in .snapshot. And anything in
.snapshot is accessible from the normally mounted fs hierarchy. AND
when doing backups I have to make really really sure that I exclude
.snapshot or I've got a very good chance of encountering an ENOSPC on
the backup target due to what will appear to be dozens or hundreds of
OS's - the deduplication aspect of those snapshots is lost


>Do
> you want snapshots of /tmp to hang around eating up disk space,
> causing you to reduce the number of snapshots you can retain?

Well I put /tmp on tmpfs so I don't worry about that.

> Keeping
> these as separate subvolumes also allows us to mount them seamlessly
> when you boot from a snapshot to either recover or reset your system.
>
> Does it look nice and neat? That's a matter of style. But the reasons
> for having separate subvolumes are well thought out and completely
> necessary.

I understand the logic, I just happen to disagree this is the only way
to achieve the desired outcome. And I also think it's possible to come
up with one layout that is compatible with both snapshot+rollback, and
stateless systems paradigms.

-- 
Chris Murphy
