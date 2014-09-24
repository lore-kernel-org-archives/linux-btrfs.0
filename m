Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:44072 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbaIXUnp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Sep 2014 16:43:45 -0400
Received: by mail-lb0-f181.google.com with SMTP id b6so6121616lbj.40
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Sep 2014 13:43:43 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 24 Sep 2014 16:43:43 -0400
Message-ID: <CAPL5yKfTfzkqBT9dQBpJAjuBtq2-=QqdCn_Pzfnnd1URKA_q4A@mail.gmail.com>
Subject: 3.16 Managed to ENOSPC with <80% used
From: Dan Merillat <dan.merillat@gmail.com>
To: BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Any idea how to recover?  I can't cut-paste but it's
Total devices 1 FS bytes used 176.22GiB
size 233.59GiB used 233.59GiB

Basically it's been data allocation happy, since I haven't deleted
53GB at any point.  Unfortunately, none of the chunks are at 0% usage
so a balance -dusage=0 finds nothing to drop.

Attempting a balance with -dusage=25 instantly dies with ENOSPC, since
100% of space is allocated.

Is this recoverable, or do I need to copy to another disk and back?
This is a really unfortunate failure mode for BTRFS.  Usually I catch
it before I get exactly 100% used and can use a balance to get it back
into shape.

What causes it to keep allocating datablocks when it's got so much
free space?  The workload is pretty standard (for devs, at least): git
and kernel builds, and git and android builds.
