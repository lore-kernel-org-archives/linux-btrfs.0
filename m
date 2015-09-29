Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:41258 "EHLO mail.bouton.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985AbbI2OtS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 10:49:18 -0400
Received: from [192.168.0.32] (adsl.bouton.name [82.234.193.23])
	by mail.bouton.name (Postfix) with ESMTP id BF726B84D
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2015 16:49:15 +0200 (CEST)
Subject: Re: btrfs fi defrag interfering (maybe) with Ceph OSD operation
To: linux-btrfs@vger.kernel.org
References: <56080C9A.6030102@bouton.name>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <560AA4EB.4050504@bouton.name>
Date: Tue, 29 Sep 2015 16:49:15 +0200
MIME-Version: 1.0
In-Reply-To: <56080C9A.6030102@bouton.name>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 27/09/2015 17:34, Lionel Bouton a écrit :
> [...]
> It's not clear to me that "btrfs fi defrag <file>" can't interfere with
> another process trying to use the file. I assume basic reading and
> writing is OK but there might be restrictions on unlinking/locking/using
> other ioctls... Are there any I should be aware of and should look for
> in Ceph OSDs? This is on a 3.8.19 kernel (with Gentoo patches which
> don't touch BTRFS sources) with btrfs-progs 4.0.1. We have 5 servers on
> our storage network : 2 are running a 4.0.5 kernel and 3 are running
> 3.8.19. The 3.8.19 servers are waiting for an opportunity to reboot on
> 4.0.5 (or better if we have the time to test a more recent kernel before
> rebooting : 4.1.8 and 4.2.1 are our candidates for testing right now).

Apparently this isn't the problem : we just had another similar Ceph OSD
crash without any concurrent defragmentation going on.

Best regards,

Lionel Bouton
