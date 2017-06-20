Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:34573 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751060AbdFTOgJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Jun 2017 10:36:09 -0400
Received: by mail-pg0-f49.google.com with SMTP id e187so11026087pgc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Jun 2017 07:36:09 -0700 (PDT)
MIME-Version: 1.0
From: Alexander Peganz <a.peganz@gmail.com>
Date: Tue, 20 Jun 2017 16:35:48 +0200
Message-ID: <CADtmLM_wcKDix3RJz3m0_=YiZ=kFtvvT8p359PNq30BusPdHFA@mail.gmail.com>
Subject: does using different uid/gid/forceuid/... mount options for different
 subvolumes work / does fuse.bindfs play nice with btrfs?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I intend to provide different "views" of the data stored on btrfs subvolumes.
e.g. mount a subvolume in location A rw; and ro in location B while
also overwriting uids, gids, and permissions.
In the past I have been using fuse.bindfs for this. Now I'm trying to
find out if there is a 'native' way to do this in btrfs, and if it
works by design or by accident (I wouldn't want to rely on something
that might go away in a newer kernel version).

So here goes:
Do different uid/gid/... mount options for different subvolumes work?
Or does the first mounted subvolume "win"?
Can a subvolume be mounted more than once (I guess not, but btrfs
might surprise me)?
Is there some completely different way I don't know about to do this
in btrfs that might not even have anything to do with mount options?
If there is no magical btrfs way, does fuse.bindfs play nice with
btrfs or should I be worried?

Thank you for your help,
Alex
