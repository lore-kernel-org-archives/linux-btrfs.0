Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:35914 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750734AbdALK1H (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jan 2017 05:27:07 -0500
Received: by mail-wm0-f49.google.com with SMTP id c85so12876434wmi.1
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jan 2017 02:27:06 -0800 (PST)
Subject: Re: corruption: yet another one after deleting a ro snapshot
From: Giuseppe Della Bianca <g.dellabianca@gestiware.it>
To: calestyo@scientia.net
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Jan 2017 11:27:48 +0100
Message-ID: <1484216868.21190.3.camel@localhost>
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

I had issues with a case very similar to yours.

My experience is that subvolume delete and/or attempt to repair the file
system makes the situation worse.

To gain experience and accepting losing the data of the file system, I
have always tried to recover the file system.

But then I always had to recreate the partition from scratch.


Cheers.

gdb

