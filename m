Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:55371 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757789Ab3FTN3u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 09:29:50 -0400
Received: by mail-we0-f182.google.com with SMTP id p60so5521267wes.13
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 06:29:47 -0700 (PDT)
Message-ID: <51C303C7.4020102@gmail.com>
Date: Thu, 20 Jun 2013 15:29:43 +0200
From: Gabriel <g2p.code@gmail.com>
MIME-Version: 1.0
To: "Kevin O'Kelley" <kevin@kevinokelley.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Two identical copies of an image mounted result in changes to
 both images if only one is modified
References: <CAFvQSYRgvsqMxk_yZf6cPyoECJsUzn2g+cW-j7ktrWnhRL+0jA@mail.gmail.com> <20130620091622.GL11290@carfax.org.uk> <kpul4f$ei7$1@ger.gmane.org> <20130620103404.GN11290@carfax.org.uk> <kpum9h$ei7$2@ger.gmane.org> <20130620105607.GO11290@carfax.org.uk> <FDFB4977-0209-4F58-92CB-EF80E3575873@kevinokelley.com>
In-Reply-To: <FDFB4977-0209-4F58-92CB-EF80E3575873@kevinokelley.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Thank you for your reply. I appreciate it. Unfortunately this issue is a deal killer for us. The ability to take very fast snapshots and replicate them to another site is key for us. We just can't us Btrfs with this setup. That's too bad. Good luck and thank you.

The issue we were discussing is: how to fail early when there are 
duplicate UUIDs.
Duplicate UUIDs will never be supported.
If *your* problem has to do with fast snapshots and fast replication, 
that's supported, see btrfs send/receive.

