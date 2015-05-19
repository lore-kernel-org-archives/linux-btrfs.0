Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.humilis.net ([80.100.93.5]:47330 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755081AbbESGiZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 May 2015 02:38:25 -0400
Date: Tue, 19 May 2015 08:38:22 +0200
From: Sander <sander@humilis.net>
To: Wolfgang Mader <Wolfgang.Mader@fdm.uni-freiburg.de>
Cc: linux-btrfs@vger.kernel.org
Subject: home server (was: Re: Kernel oops: 17 on PREEMPT ARM when scrubbing)
Message-ID: <20150519063822.GA12325@panda>
Reply-To: sander@humilis.net
References: <5446053.ssUlp5hNAW@fuckup>
 <1836565.Anox2V7X2S@discus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1836565.Anox2V7X2S@discus>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wolfgang Mader wrote (ao):
> By the way. Since the last two years I server my files in my home network 
> using low-power arm devices, but by now I am a little frustrated to depend on 
> the manufacturer when it comes to u-boot updates. What are you guys using for 
> your home network as server hardware?

Currently an Arndale (uefi), which replaced a Pandaboard (barebox), but
now I'm looking at a Supermicro 5028D-TN4T for (much) better fs
performance and more reliability (ecc memory), but still a bit low power
(45W Xeon).

I hoped for 64bit arm with ecc and all as announced quite some time ago
(AMD), but I'm pretty much done waiting.

	Sander
