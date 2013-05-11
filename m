Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:58877 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab3EKLMT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 May 2013 07:12:19 -0400
Received: by mail-ee0-f44.google.com with SMTP id b57so623921eek.3
        for <linux-btrfs@vger.kernel.org>; Sat, 11 May 2013 04:12:18 -0700 (PDT)
Message-ID: <518E278D.6070508@gmail.com>
Date: Sat, 11 May 2013 13:12:13 +0200
From: Andreas Philipp <philipp.andreas@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>,
        =?ISO-8859-1?Q?Marcus_L=F6vgren?= <marcuslvgrn@gmail.com>,
        Remco Hosman - Yerf IT <remco@yerf-it.nl>
CC: Andreas Philipp <philipp.andreas@gmail.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [PATCH RESEND 0/2] Two small patches for the raid56 code
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

The last few days I have been playing around with Chris Mason's
raid56-experimental branch (Thanks!) and discovered two minor issues.

Thanks,
Andreas

Andreas Philipp (2):
  Minor format cleanup.
  Correct allowed raid levels on balance.

 fs/btrfs/ctree.h   |  4 ++--
 fs/btrfs/volumes.c | 11 +++++------
 2 files changed, 7 insertions(+), 8 deletions(-)

-- 
1.7.12.4

