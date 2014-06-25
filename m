Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f174.google.com ([209.85.160.174]:39368 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbaFYHZ6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 03:25:58 -0400
Received: by mail-yk0-f174.google.com with SMTP id 19so870521ykq.19
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jun 2014 00:25:57 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 25 Jun 2014 09:25:57 +0200
Message-ID: <CACQTm-go5jGan9kP-dVq7Oi4b+AGWuFkb0Nudc2i9V1SG-oc3Q@mail.gmail.com>
Subject: btrfs data dup on single device?
From: Daniel Landstedt <daniel.landstedt@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Will it be possible to use DUP for data as well as for metadata on a
single device?
And if so, am I going to be able to specify more than 1 copy of the data?

Storage is pretty cheap now, and to have multiple copies in btrfs is
something that I think could be used a lot. I know I will use multiple
copies of my data if made possible.

Is it something that might be available when RAID1 gets N mirrors
instead of just 1 mirror?



Daniel
