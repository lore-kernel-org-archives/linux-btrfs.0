Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57951 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbaLAJ0g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 04:26:36 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XvNFb-0000Ay-8F
	for linux-btrfs@vger.kernel.org; Mon, 01 Dec 2014 10:26:35 +0100
Received: from 94.250.180.197 ([94.250.180.197])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 10:26:35 +0100
Received: from gour by 94.250.180.197 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 10:26:35 +0100
To: linux-btrfs@vger.kernel.org
From: Gour <gour@atmarama.net>
Subject: Re: pro/cons of raid1 with mdadm/lvm2
Date: Mon, 1 Dec 2014 10:26:24 +0100
Message-ID: <20141201102624.1224bc54@atmarama>
References: <20141130121147.45884217@atmarama>
	<E4D50A09-CBA8-47DB-833B-D80D7BD6BD92@coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 01 Dec 2014 09:06:19 +1100
Russell Coker <russell@coker.com.au> wrote:

> When the 2 disks have different data mdadm has no way of knowing
> which one is correct and has a 50% chance of overwriting good data.
> But BTRFS does checksums on all reads and solves the problem of
> corrupt data - as long as you don't have 2 corrupt sectors in
> matching blocks.

Hmm, this is very interesting and valuable info. Thank you.


Sincerely,
Gour

-- 
Many, many births both you and I have passed. I can remember 
all of them, but you cannot, O subduer of the enemy!

-- 
One is understood to be in full knowledge whose every endeavor 
is devoid of desire for sense gratification. He is said by sages 
to be a worker for whom the reactions of work have been burned 
up by the fire of perfect knowledge.

http://www.atmarama.net | Hlapicina (Croatia) | GPG: 52B5C810


