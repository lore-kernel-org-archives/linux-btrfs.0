Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61742 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab2LBWRt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Dec 2012 17:17:49 -0500
Received: by mail-ie0-f174.google.com with SMTP id c11so3244017ieb.19
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Dec 2012 14:17:49 -0800 (PST)
MIME-Version: 1.0
From: Aastha Mehta <aasthakm@gmail.com>
Date: Sun, 2 Dec 2012 23:17:26 +0100
Message-ID: <CAEx9m478rbpHCSSNsSv4yyOk3-yrAuSk0DQQ23X+iFWMocAhzg@mail.gmail.com>
Subject: basic questions regarding some btrfs features
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I hope this is the right mailing list for beginners' questions. If
not, please direct me to the right place.

I am looking at btrfs to understand some of its features. One of them
is the snapshot feature. Please tell me if my following understanding
about snapshots in btrfs is correct or not.

Btrfs supports both readonly and writeable snapshots. Writeable
snapshots are like clone volumes (or subvolumes as in btrfs). We get a
point in time copy of the subvolume in both case.

I looked through the kernel code and it seems that creating a
subvolume and taking a snapshot (readonly and writeable) all have a
common ioctl interface.

What I am not completely clear about is whether snapshots get same
fsid as the source subvolume fsid or different.

Also, I do not understand what does it mean to be able to take
snapshot of a snapshot. What are benefits compared to say, being able
to take snapshots only of the active subvolume and not of the
snapshots?

Probably before that, I need to get some clarity on why does a
subvolume always belong in the directory of some parent subvolume. Is
it possible to have more than one root subvolumes or more than one
subvolumes in the same parent subvolume directory?

Thanks,
Aastha Mehta.
