Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.220]:25597 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758535AbaDJPv2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Apr 2014 11:51:28 -0400
Received: from fuchsia.localnet (p57A571D5.dip0.t-ipconnect.de [87.165.113.213])
	by smtp.strato.de (RZmta 32.33 DYNA|AUTH)
	with ESMTPSA id y04923q3AFpQ1hR
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	for <linux-btrfs@vger.kernel.org>;
	Thu, 10 Apr 2014 17:51:26 +0200 (CEST)
From: Michael Schuerig <michael.lists@schuerig.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Copying a disk containing a btrfs filesystem
Date: Thu, 10 Apr 2014 17:51:26 +0200
Message-ID: <3414746.Gera7uWrI1@fuchsia>
In-Reply-To: <pan$2aca0$96a1810f$3919e968$6678f073@cox.net>
References: <4783411.VVGoQz5kVU@fuchsia> <CAPpBBdMCAFASLgGpbWo7-Pp74S_KQdZ2A7qrSNzo0rGrZAbqMw@mail.gmail.com> <pan$2aca0$96a1810f$3919e968$6678f073@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 10 April 2014 15:15:02 Duncan wrote:
> Meanwhile (2), given the existence of those tested backups, there's
> yet  another way to accomplish things.  Simply restore from the
> backups the same way you would if the working copy went down and you
> had to restore it, only restore to the new device instead of the old
> one.  =:^)

As the OP, let me insist that I have multiple backups. However and 
unfortunately, those backups do not contain the snapshots that I'd like 
to preserve when exchanging the disk. What makes the case complicate is 
not the question how to preserve and copy the current data; it's how to 
retain the historic data embodied in snapshots.

Michael

-- 
Michael Schuerig
mailto:michael@schuerig.de
http://www.schuerig.de/michael/

