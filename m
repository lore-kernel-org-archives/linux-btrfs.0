Return-Path: <SRS0=M3t6=QH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5DCEC169C4
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 12:43:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DCD02075D
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 12:43:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732927AbfAaMnu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 31 Jan 2019 07:43:50 -0500
Received: from mail.scheunentor.de ([148.251.13.145]:48827 "EHLO
        ispmail01.scheunentor.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbfAaMnu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Jan 2019 07:43:50 -0500
X-Greylist: delayed 312 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jan 2019 07:43:49 EST
Received: from localhost (localhost [127.0.0.1])
        by ispmail01.scheunentor.de (Postfix) with ESMTP id 12DAB1FDA6
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2019 13:38:36 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at ispmail01.scheunentor.de
Received: from ispmail01.scheunentor.de ([127.0.0.1])
        by localhost (ispmail01.intra.scheunentor.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id kwpzoIcN7wLJ for <linux-btrfs@vger.kernel.org>;
        Thu, 31 Jan 2019 13:38:33 +0100 (CET)
Received: from shell.intra.scheunentor.de (shell.intra.scheunentor.de [192.168.0.206])
        by ispmail01.scheunentor.de (Postfix) with SMTP id 95A6D1FA33
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2019 13:38:33 +0100 (CET)
Received: (nullmailer pid 26463 invoked by uid 1000);
        Thu, 31 Jan 2019 12:38:33 -0000
Date:   Thu, 31 Jan 2019 13:38:33 +0100
From:   Ronald Schaten <ronald@schatenseite.de>
To:     linux-btrfs@vger.kernel.org
Subject: File alteration events?
Message-ID: <20190131123832.yqhp4fqavv6xjdif@shell.intra.scheunentor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello everybody...

This is my first mail to this list, and -- as much as I'd like to be --
I'm not a kernel developer. So please forgive me if this isn't the right
place for questions like this. I'm thankful for any pointer into the
right direction.


The question:

I'm looking for a solution to track file changes on a fairly large
filesystem. Many thousands of directories, millions of files.

The volume is shared to other computers, changes can come from different
sources (NFS, Samba, local access...). So I think the kernel or the
filesystem itself are the definitive source of information.

Does BTRFS have any mechanism that could be used to track every event?
Or do you happen to know if the kernel does?


What I tried till now:

- inotify: Doesn't work for a full volume, just for single inodes.

- fanotify: That's almost the solution, but I need to see rename and
  delete events, too.

- btrfs subvolume find-new: As far as I know that only finds changes
  between snapshots. I need something a little more real-timey, and I
  have to know if the file has been changed once or several times.


As I said: I'm thankful for any hint... thanks in advance!


Regards,
Ronald.

-- 
Ronald Schaten :: http://www.schatenseite.de
