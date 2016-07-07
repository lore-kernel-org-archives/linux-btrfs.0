Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:34829 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbcGGRkz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jul 2016 13:40:55 -0400
Received: by mail-oi0-f42.google.com with SMTP id r2so33016978oih.2
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jul 2016 10:40:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPmG0jZZ7FB0teBGGHojPoGctRyVC3D2cS56q1kYDMFrC=fOnA@mail.gmail.com>
References: <96f8022e-4209-2498-62e4-50ccbee46e37@freenet.de> <CAPmG0jZZ7FB0teBGGHojPoGctRyVC3D2cS56q1kYDMFrC=fOnA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 7 Jul 2016 11:40:53 -0600
Message-ID: <CAJCQCtQt2A7w4JNUuhU7YOHTyj_z8M_RqsZCDw0G2YEENXaBvg@mail.gmail.com>
Subject: Re: rollback to a snapshot and delete old top volume - missing of "@"
To: Henk Slager <eye1tm@gmail.com>
Cc: Kai Herlemann <nesadaw@freenet.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 7, 2016 at 10:01 AM, Henk Slager <eye1tm@gmail.com> wrote:

> What the latest debian likes as naming convention I dont know, but in
> openSuSE @ is a directory in the toplevel volume (ID=5 or ID=0 as
> alias) and that directory contains subvolumes.

No, opensuse doesn't use @ at all. They use a subvolume called
.snapshots to contain snapper snapshots.

On a system using snapper, its snapshots should probably be deleted
via snapper so it's aware of the state change.

And very clearly from the OP's output from 'btrfs sub list' there are
no subvolumes with @ in the path, so there is no subvolume @, nor are
there any subvolumes contained in a directory @.

Assuming the posted output from btrfs sub list is the complete output,
.snapshots is a directory and there are three subvolumes in it. I
suspect the OP is unfamiliar with snapper conventions and is trying to
delete a snapshot outside of snapper, and is used to some other
(Debian or Ubuntu) convention where snapshots somehow relate to @,
which is a mimicking of how ZFS does things.

Anyway the reason why the command fails is stated in the error
message. The system appears to be installed in the top level of the
file system (subvolid=5), and that can't be deleted. First it's the
immutable first subvolume of a Btrfs file system, and second it's
populated with other subvolumes which would inhibit its removal even
if it weren't the top level subvolume.

What can be done is delete the directories in the top level, retaining
the subvolumes that are there.




-- 
Chris Murphy
