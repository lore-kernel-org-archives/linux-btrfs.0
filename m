Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.160]:37119 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaCOOmG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Mar 2014 10:42:06 -0400
Received: from fuchsia.localnet (p5DE8D06B.dip0.t-ipconnect.de [93.232.208.107])
	by smtp.strato.de (RZmta 32.27 DYNA|AUTH)
	with ESMTPSA id 604c18q2FEg3YcL
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	for <linux-btrfs@vger.kernel.org>;
	Sat, 15 Mar 2014 15:42:03 +0100 (CET)
From: Michael Schuerig <michael.lists@schuerig.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Snapper on Ubuntu
Date: Sat, 15 Mar 2014 15:42:02 +0100
Message-ID: <12151050.DOANbtdZpp@fuchsia>
In-Reply-To: <53245E22.1060407@friedels.name>
References: <53245E22.1060407@friedels.name>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 15 March 2014 15:05:22 Hendrik Friedel wrote:
> Hello,
> 
> I am not sure, whether this is the right place to ask this question
> -if not, please advise.
> 
> Ubuntu installs on btrfs, creating subvolumes for the homes (/home),
> the root home (/root) and the root (/) named @home, @root and @
> respectively.
> 
> When I install snapper I configure it like this
> snapper -c rt create-config /
> snapper -c home create-config /home
> snapper -c root create-config /root
> snapper -c Video create-config /mnt/BTRFS/Video/
> 
> After executing snapper create several times, this results in
> 
> #btrfs subvolume list /
> ID 258 gen 2615 top level 5 path @
> ID 259 gen 2611 top level 5 path @root
> ID 260 gen 2555 top level 5 path @home
> ID 281 gen 2555 top level 5 path @home/.snapshots
> ID 282 gen 2606 top level 5 path @root/.snapshots
> ID 283 gen 2562 top level 5 path @root/.snapshots/1/snapshot
> ID 284 gen 2563 top level 5 path @root/.snapshots/2/snapshot
> ID 285 gen 2573 top level 5 path @root/.snapshots/3/snapshot
[...]
> So, this all works for @root only, not for the other subvolumes.
> 
> Do you have any suggestions, how to find the cause?

I think you may have forgotten to specify the config snapper is supposed 
to use. Try

# snapper -c home create
# snapper -c Video create

Michael

-- 
Michael Schuerig
mailto:michael@schuerig.de
http://www.schuerig.de/michael/

