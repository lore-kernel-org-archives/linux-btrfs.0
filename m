Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f172.google.com ([74.125.82.172]:44281 "EHLO
        mail-ot0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932479AbeFGUu2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jun 2018 16:50:28 -0400
Received: by mail-ot0-f172.google.com with SMTP id w13-v6so13149971ote.11
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jun 2018 13:50:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtStcPseu+2KNYQN2C3wKkAenuQm59yiK_X8jOsfAA-Myg@mail.gmail.com>
References: <CAHac6AspsJ5iu+HECOr1ytVRjqB1JyVtqKVwxBF-H+t_18-Tnw@mail.gmail.com>
 <CAJCQCtStcPseu+2KNYQN2C3wKkAenuQm59yiK_X8jOsfAA-Myg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 7 Jun 2018 14:50:27 -0600
Message-ID: <CAJCQCtTsWq_wZP-MO2-aXmzFAyR-QoT8147NFEiMqyGa7bbDNQ@mail.gmail.com>
Subject: Re: Bad superblock when mounting rw, ro mount works
To: Chris Murphy <lists@colorremedies.com>
Cc: Daniel Underwood <daniel.underwood13@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 7, 2018 at 2:38 PM, Chris Murphy <lists@colorremedies.com> wrote:


> Your very first task right now is to mount ro, and update your
> backups. Don't do anything else until you've done that. It's a
> testimony to Btrfs that this file system mounts at all, even ro, so
> take advantage of this fact before you can't mount it anymore.

After you've done the backup, you need to find out why one of these
devices is being so unreliable. That has to be fixed first. You can
recreate a new Btrfs or some other file system, and you'll just run
into the exact same problem down the road. Next, it might be useful to
see the output from btrfs-progs 4.16.1 'btrfs check' and 'btrfs check
--mode=lowmem'  both of which are slow, the second one is really slow
but is a different implementation so it's helpful to see both outputs.
That's safe as long as you do not use --repair.

Also we need to see the output from 'btrfs fi us <mountpoint>' with
the volume mounted (ro). Off  hand I think the most likely outcome is
that you get a backup from the ro mounted file system, and you'll have
to recreate it from scratch and restore from backups. In other words,
no matter what you need a current backup.

-- 
Chris Murphy
