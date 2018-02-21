Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:60919 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932826AbeBUOvr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Feb 2018 09:51:47 -0500
Message-ID: <1519224704.4313.13.camel@scientia.net>
Subject: Re: BUG: unable to handle kernel paging request at ffff9fb75f827100
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Nikolay Borisov <nborisov@suse.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Wed, 21 Feb 2018 15:51:44 +0100
In-Reply-To: <1519222829.4313.10.camel@scientia.net>
References: <1519186148.24817.1.camel@scientia.net>
         <478320b9-1972-2615-2e91-adc3d3f5112b@suse.com>
         <1519222829.4313.10.camel@scientia.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Interestingly, I got another one only within minutes after the scrub:
Feb 21 15:23:49 heisenberg kernel: BTRFS warning (device dm-0): csum failed root 257 ino 7703 off 56852480 csum 0x42d1b69c expected csum 0x3ce55621 mirror 1
Feb 21 15:23:52 heisenberg kernel: BTRFS warning (device dm-0): csum failed root 257 ino 7703 off 66146304 csum 0xc739c174 expected csum 0x62e6ce8b mirror 1
Feb 21 15:23:56 heisenberg kernel: BTRFS warning (device dm-0): csum failed root 257 ino 7703 off 87212032 csum 0x183aff6d expected csum 0x3dacaab0 mirror 1


The file (a tgz - which seems to unpack fine) was probably read, but
definitely not written to in ages...

SMART for the SSD looks ok...

Strange...

Cheers,
Chris.

