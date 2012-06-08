Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nm21-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.137]:26766 "HELO
	nm21-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757438Ab2FHT3m convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jun 2012 15:29:42 -0400
Message-ID: <1339183466.55421.YahooMailNeo@web160803.mail.bf1.yahoo.com>
Date: Fri, 8 Jun 2012 12:24:26 -0700 (PDT)
From: Matthew Hawn <steamraven@yahoo.com>
Reply-To: Matthew Hawn <steamraven@yahoo.com>
Subject: Moving top level to a subvolume
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I just converted my root filesystem to btrfs with btrfs-convert.  However, since I am running Ubuntu, I would like to have the same subvolume structure as a default install,. How do I move the top-level subvolume (where all my files currently are) to another subvolume?

Matt
