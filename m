Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:24477 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932198Ab3KHSfW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Nov 2013 13:35:22 -0500
Received: from out.poczta.wp.pl ([212.77.101.240])
          (envelope-sender <yzb3@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with SMTP
          for <linux-btrfs@vger.kernel.org>; 8 Nov 2013 19:35:18 +0100
Date: Fri, 08 Nov 2013 19:35:18 +0100
From: yzb3@wp.pl
To: linux-btrfs@vger.kernel.org
Subject: Btrfs might be gradually slowing the boot process
Message-ID: <527d2ee689e077.81319728@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I recently noticed that my boot has become slower - it took around 29s, while at the beginning it was ~6s. I thought it was an issue with systemd, because it failed to properly indicate at which stage the slowdown occurred and how long it took. I rolled back to a pretty fresh root subvolume and the boot was fast again. However, after several reboots it started lagging again (10s? preposterous!). I decided to try the *clear_cache* mount option; it was only a guess, but it did speed the boot to 
the proper ~6s.

The question is - why? My filesystem is really small - I see no reason for a 5x boot slowdown. Is this a known issue? I will be glad to give any additional details about my fs.


