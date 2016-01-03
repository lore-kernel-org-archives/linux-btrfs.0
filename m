Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:33719 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbcACVdk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Jan 2016 16:33:40 -0500
Received: by mail-io0-f170.google.com with SMTP id q21so139219986iod.0
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Jan 2016 13:33:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$671e2$87d221b4$c1b40d79$6f794584@cox.net>
References: <CAJCQCtS59TFek+g9x_aoqGzepySMrRn6DcOQkuwi=VQYR9M4tw@mail.gmail.com>
	<pan$671e2$87d221b4$c1b40d79$6f794584@cox.net>
Date: Sun, 3 Jan 2016 14:33:40 -0700
Message-ID: <CAJCQCtSCvzoOdqFx9dB9sbT-dR0XsQVzWwVcK3zBnwC17+ZV_Q@mail.gmail.com>
Subject: Re: evidence of persistent state, despite device disconnects
From: Chris Murphy <lists@colorremedies.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

kernel-4.4.0-0.rc6.git0.1.fc24.x86_64
btrfs-progs 4.3.1

There was some copy pasting, hence /mnt/brick vs /mnt/brick2
confusion, but the volume was always cleanly mounted and umounted.

The biggest problem I have with all of this is the completely silent
addition of single chunks. That made the volume, in effect, no longer
completely raid1. No other details matter, except to try and reproduce
the problem, and find its source so it can be fixed. It is a bug,
because it's definitely not sane or expected behavior at all.


Chris Murphy
