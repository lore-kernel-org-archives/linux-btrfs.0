Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:33373 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752014AbcHZTAu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Aug 2016 15:00:50 -0400
Received: by mail-ua0-f170.google.com with SMTP id l94so90289810ual.0
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Aug 2016 12:00:49 -0700 (PDT)
MIME-Version: 1.0
From: E V <eliventer@gmail.com>
Date: Fri, 26 Aug 2016 15:00:48 -0400
Message-ID: <CAJtFHUSSEd0ABBRi1-Ko4ciu+-tr62KvkBDVRc4zYf8PF_g4cA@mail.gmail.com>
Subject: linux 4.7.2 & btrfs & rsync & OOM gone crazy
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just upgraded from 4.6.5 to 4.7.2 for my btrfs backup server with 32GB
of ram. Only thing that run's on it is an rsync of an NFS filesystem
to the local btrfs. Cached mem tends to hang out around 26-30GB, but
with 4.7.2 the OOM is now going crazy and trying to kill whatever it
can including my ssh and rsync process. Anyone seen anything similar?
Trying it again with /proc/sys/vm/swappiness at 0 will see if that
makes a difference.
