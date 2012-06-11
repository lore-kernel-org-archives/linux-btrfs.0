Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nm38-vm0.bullet.mail.bf1.yahoo.com ([72.30.239.16]:26505 "HELO
	nm38-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751664Ab2FKX1v convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jun 2012 19:27:51 -0400
Message-ID: <1339456922.32583.YahooMailNeo@web160802.mail.bf1.yahoo.com>
Date: Mon, 11 Jun 2012 16:22:02 -0700 (PDT)
From: Matthew Hawn <steamraven@yahoo.com>
Reply-To: Matthew Hawn <steamraven@yahoo.com>
Subject: KVM on top of BTRFS
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

What are the recommendations for running KVM images on BTRFS systems using kernel 3.4?  I saw older posts on the web complaining about poor performance, but I know a lot of work has gone into btrfs since then.  There also seemed to be the nocow option, but I didn't find anything that said it actualy helped.

Anybody have ideas?

Thanks,
Matt
