Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vs2.lukas-pirl.de ([5.45.100.90]:43904 "EHLO pim.lukas-pirl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697AbbKHC7P (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 7 Nov 2015 21:59:15 -0500
Subject: Re: corrupted RAID1: unsuccessful recovery / help needed
To: Duncan <1i5t5.duncan@cox.net>, hugo@carfax.org.uk, ahferroin7@gmail.com
References: <562DC606.3070602@lukas-pirl.de>
 <pan$deb9e$70dd599$c247d7fb$410817e7@cox.net>
 <5632930D.4040000@lukas-pirl.de>
 <pan$2c57b$16ebecd2$7cec1c09$cc5ded39@cox.net>
Cc: linux-btrfs@vger.kernel.org
From: Lukas Pirl <btrfs@lukas-pirl.de>
Message-ID: <563EBA79.6040808@lukas-pirl.de>
Date: Sun, 8 Nov 2015 15:59:05 +1300
MIME-Version: 1.0
In-Reply-To: <pan$2c57b$16ebecd2$7cec1c09$cc5ded39@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the answers Duncan, Hugo and Austin.

I'll try a recovery as soon as I can and might (probably) come back to
the list then.

On 10/30/2015 11:58 PM, Duncan wrote:
> Meanwhile, this does reinforce the point that snapshots don't
> replace full backups, that being the reason I don't use them here,
> since if the filesystem goes bad, it'll very likely take all the
> snapshots with it.

It is very true that snapshots do not replace full backups (in case of
software or hardware failures). However, they are a very suited
strategy to recover from unintentional deletions (most likely human,
but could also be software failures)

Best,

Lukas

-- 
+49 174 940 74 71
+64 21 150 86 86
GPG: http://lukas-pirl.de/media/attachments/lukas_pirl.pub
