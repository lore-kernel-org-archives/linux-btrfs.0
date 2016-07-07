Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:34713 "EHLO
	mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbcGGSdE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jul 2016 14:33:04 -0400
Received: by mail-vk0-f52.google.com with SMTP id d67so31432097vkh.1
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jul 2016 11:33:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQt2A7w4JNUuhU7YOHTyj_z8M_RqsZCDw0G2YEENXaBvg@mail.gmail.com>
References: <96f8022e-4209-2498-62e4-50ccbee46e37@freenet.de>
 <CAPmG0jZZ7FB0teBGGHojPoGctRyVC3D2cS56q1kYDMFrC=fOnA@mail.gmail.com> <CAJCQCtQt2A7w4JNUuhU7YOHTyj_z8M_RqsZCDw0G2YEENXaBvg@mail.gmail.com>
From: Henk Slager <eye1tm@gmail.com>
Date: Thu, 7 Jul 2016 20:27:16 +0200
Message-ID: <CAPmG0jbF3dj=7pK7qdL+zQYj5Z2G0xPZjQGZ7WTkfDsyj1tuZA@mail.gmail.com>
Subject: Re: rollback to a snapshot and delete old top volume - missing of "@"
To: Chris Murphy <lists@colorremedies.com>
Cc: Kai Herlemann <nesadaw@freenet.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 7, 2016 at 7:40 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Thu, Jul 7, 2016 at 10:01 AM, Henk Slager <eye1tm@gmail.com> wrote:
>
>> What the latest debian likes as naming convention I dont know, but in
>> openSuSE @ is a directory in the toplevel volume (ID=5 or ID=0 as
>> alias) and that directory contains subvolumes.

Sorry, I mixed-up latest opensuse and my own adaptions to older installations.

> No, opensuse doesn't use @ at all. They use a subvolume called
> .snapshots to contain snapper snapshots.

On current fresh install "openSUSE Tumbleweed (20160703) (x86_64)" you get this:

# btrfs sub list /
ID 257 gen 24369 top level 5 path @
ID 258 gen 24369 top level 257 path @/.snapshots
ID 259 gen 24369 top level 258 path @/.snapshots/1/snapshot
ID 265 gen 25404 top level 257 path @/tmp
ID 267 gen 24369 top level 257 path @/var/cache
ID 268 gen 20608 top level 257 path @/var/crash
ID 269 gen 20608 top level 257 path @/var/lib/libvirt/images
ID 270 gen 3903 top level 257 path @/var/lib/mailman
ID 271 gen 2996 top level 257 path @/var/lib/mariadb
ID 272 gen 3904 top level 257 path @/var/lib/mysql
ID 273 gen 3903 top level 257 path @/var/lib/named
ID 274 gen 22228 top level 257 path @/var/lib/pgsql
ID 275 gen 25404 top level 257 path @/var/log
ID 276 gen 20611 top level 257 path @/var/opt
ID 277 gen 25404 top level 257 path @/var/spool
ID 278 gen 24369 top level 257 path @/var/tmp
ID 300 gen 10382 top level 258 path @/.snapshots/15/snapshot
[..]

@ is the only thing in the toplevel

I have changed it a bit for this particular PC, so that more is in one subvol.
Just after default install, subvol with ID 259 is made default and rw

I had also updated my older linux installs a bit like this, but with @
a dir, not a subvol, so that at least I can easily swap
'latestroofs' subvol with something else. My interpretation of the
OP's report was that he basically wants something like that too.

> On a system using snapper, its snapshots should probably be deleted
> via snapper so it's aware of the state change.

You can do that, but also with btrfs sub del in re-organisation
actions like described here. If you delete the .xml files in the
subvol .snapshots, it starts counting from 1 again. Changing the
latest .xml file can make it start counting from some higher number if
that is important for many-months history for example.

> And very clearly from the OP's output from 'btrfs sub list' there are
> no subvolumes with @ in the path, so there is no subvolume @, nor are
> there any subvolumes contained in a directory @.
>
> Assuming the posted output from btrfs sub list is the complete output,
> .snapshots is a directory and there are three subvolumes in it. I
> suspect the OP is unfamiliar with snapper conventions and is trying to
> delete a snapshot outside of snapper, and is used to some other
> (Debian or Ubuntu) convention where snapshots somehow relate to @,
> which is a mimicking of how ZFS does things.
>
> Anyway the reason why the command fails is stated in the error
> message. The system appears to be installed in the top level of the
> file system (subvolid=5), and that can't be deleted. First it's the
> immutable first subvolume of a Btrfs file system, and second it's
> populated with other subvolumes which would inhibit its removal even
> if it weren't the top level subvolume.
>
> What can be done is delete the directories in the top level, retaining
> the subvolumes that are there.

Indeed, yes, as a last cleanup step.
