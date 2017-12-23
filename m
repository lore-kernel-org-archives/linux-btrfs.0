Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:39749 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750713AbdLWLTs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 23 Dec 2017 06:19:48 -0500
Received: by mail-oi0-f42.google.com with SMTP id r63so20438199oia.6
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Dec 2017 03:19:47 -0800 (PST)
MIME-Version: 1.0
From: James Courtier-Dutton <james.dutton@gmail.com>
Date: Sat, 23 Dec 2017 11:19:06 +0000
Message-ID: <CAAMvbhEL4gw29ttxN9xbey3YFwUpmeYht2_m4rPFn9F3fn1rqQ@mail.gmail.com>
Subject: btrfs balance problems
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

During a btrfs balance, the process hogs all CPU.
Or, to be exact, any other program that wishes to use the SSD during a
btrfs balance is blocked for long periods. Long periods being more
than 5 seconds.
Is there any way to multiplex SSD access while btrfs balance is
operating, so that other applications can still access the SSD with
relatively low latency?

My guess is that btrfs is doing a transaction with a large number of
SSD blocks at a time, and thus blocking other applications.

This makes for atrocious user interactivity as well as applications
failing because they cannot access the disk in a relatively low latent
manner.
For, example, this is causing a High Definition network CCTV
application to fail.

What I would really like, is for some way to limit SSD bandwidths to
applications.
For example the CCTV app always gets the bandwidth it needs, and all
other applications can still access the SSD, but are rate limited.
This would fix my particular problem.
We have rate limiting for network applications, why not disk access also?

Kind Regards

James
