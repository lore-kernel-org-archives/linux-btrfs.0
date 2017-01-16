Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:36044 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750994AbdAPLFx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jan 2017 06:05:53 -0500
Received: by mail-lf0-f47.google.com with SMTP id z134so76255100lff.3
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jan 2017 03:05:52 -0800 (PST)
Subject: Re: corruption: yet another one after deleting a ro snapshot
From: Giuseppe Della Bianca <g.dellabianca@gestiware.it>
To: quwenruo@cn.fujitsu.com, calestyo@scientia.net
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Jan 2017 12:06:35 +0100
Message-ID: <1484564795.3527.18.camel@localhost>
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

If it can be helpful.

How to double checking the status of my filesystem, I launched ' btrfs
scrub / ' and/or ' du -sh /* '.
If the file system is corrupt, in my case, the command have aborted.


Regards.


gdb

