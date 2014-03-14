Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.221]:57175 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764AbaCNI4X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 04:56:23 -0400
Received: from fuchsia.localnet (p57A57AA4.dip0.t-ipconnect.de [87.165.122.164])
	by smtp.strato.de (RZmta 32.27 DYNA|AUTH)
	with ESMTPSA id f06362q2E8uLDnE
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	for <linux-btrfs@vger.kernel.org>;
	Fri, 14 Mar 2014 09:56:21 +0100 (CET)
From: Michael Schuerig <michael.lists@schuerig.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Incremental backup for a raid1
Date: Fri, 14 Mar 2014 09:56:20 +0100
Message-ID: <1549230.7yEi5AM4H9@fuchsia>
In-Reply-To: <pan$60e7c$45de97e1$2fb9daeb$288befdc@cox.net>
References: <1564384.fRV1HUkfCq@fuchsia> <pan$60e7c$45de97e1$2fb9daeb$288befdc@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 14 March 2014 06:42:27 Duncan wrote:
> N-way-mirroring is actually my most hotly anticipated feature for a 
> different reason[2], but for you it would work like this:
> 
> 1) Setup the 3-way (or 4-way if preferred) mirroring and balance to 
> ensured copies of all data on all devices.
> 
> 2) Optionally scrub to ensure the integrity of all copies.
> 
> 3) Disconnect the backup device(s).  (Don't btrfs device delete, this 
> would remove the copy.  Just disconnect.)
> 
> 4) Store the backups.
> 
> 5) Periodically get them out and reconnect.
> 
> 6) Rebalance to update.  (Since the devices remain members of the
> mirror,  simply outdated, the balance should only update, not rewrite
> the entire thing.)
> 
> 7) Optionally scrub to verify.
> 
> 8) Repeat steps 3-7 as necessary.

Judging from your description, N-way mirroring is (going to be) exactly 
what I was hoping for.

Michael

-- 
Michael Schuerig
mailto:michael@schuerig.de
http://www.schuerig.de/michael/

