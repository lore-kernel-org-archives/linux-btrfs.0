Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49042 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988Ab3CBMp2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 Mar 2013 07:45:28 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UBlox-0005YH-7a
	for linux-btrfs@vger.kernel.org; Sat, 02 Mar 2013 13:45:47 +0100
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Mar 2013 13:45:47 +0100
Received: from g2p.code by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Mar 2013 13:45:47 +0100
To: linux-btrfs@vger.kernel.org
From: Gabriel de Perthuis <g2p.code@gmail.com>
Subject: Re: Permanent uncancellable balance
Date: Sat, 2 Mar 2013 12:45:12 +0000 (UTC)
Message-ID: <kgss8n$l3e$2@ger.gmane.org>
References: <kgsj1h$oo1$1@ger.gmane.org> <20130302171237.00afdc78@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 02 Mar 2013 17:12:37 +0600, Roman Mamedov wrote:
> Mount with the "skip_balance" option
> https://btrfs.wiki.kernel.org/index.php/Mount_options then you can issue
> "btrfs fi balance cancel" and it will succeed.

Excellent, thank you.
I had just thought of doing the same thing with ro and it worked.

