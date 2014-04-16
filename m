Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:63963 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbaDPLMs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Apr 2014 07:12:48 -0400
Received: from fuchsia.localnet (p57A57371.dip0.t-ipconnect.de [87.165.115.113])
	by smtp.strato.de (RZmta 32.35 DYNA|AUTH)
	with ESMTPSA id R07d03q3GBClAcz
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	for <linux-btrfs@vger.kernel.org>;
	Wed, 16 Apr 2014 13:12:47 +0200 (CEST)
From: Michael Schuerig <michael.lists@schuerig.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Copying a disk containing a btrfs filesystem
Date: Wed, 16 Apr 2014 13:12:47 +0200
Message-ID: <2723219.5o4fQymcSy@fuchsia>
In-Reply-To: <5347C663.4050704@swiftspirit.co.za>
References: <4783411.VVGoQz5kVU@fuchsia> <5347C663.4050704@swiftspirit.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 11 April 2014 12:39:31 Brendan Hide wrote:
> If you're 100% happy with your old disk's *content*/layout/etc (just
> not  happy with the disk's reliability), try an
> overnight/over-weekend ddrescue instead

Thanks again to everyone who replied and especially for suggesting 
ddrescue. In the meantime, I've got a suitable new disk and copied the 
data to it using ddrescue (it took about 12 hours for 1TB). The disk had 
one fault extending over a few successive sectors.

For some reason, I had to repair the first partition, which I use for 
swap. The large second with btrfs on it seems fine. I ran btrfs scrub on 
it and it found one error:

Apr 16 09:48:27 fuchsia kernel: [ 6792.829186] btrfs: checksum error at 
logical 74443923456 on dev /dev/sdb2, sector 145398288, root 1228, inode 
59102093, offset 929792, length 4096, links 1 (path: 
usr/lib/debug/.build-id/8f/b82df57b7b6fff7033f6abd7de914b82f98160.debug)

That file is part of a "historical" snapshot which I have deleted by now 
and thus presumably dealt with the problem.

Michael

-- 
Michael Schuerig
mailto:michael@schuerig.de
http://www.schuerig.de/michael/

