Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:19436 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab2JHGIh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2012 02:08:37 -0400
Message-ID: <50726DE1.20101@petaramesh.org>
Date: Mon, 08 Oct 2012 08:08:33 +0200
From: =?UTF-8?B?U3fDom1pIFBldGFyYW1lc2g=?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Goffredo Baroncelli <kreijack@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS, getting darn slower everyday
References: <50714AC8.4010100@petaramesh.org> <loom.20121007T141248-114@post.gmane.org> <50718151.8090506@petaramesh.org> (sfid-20121007_163445_311645_DBA4D8EF) <201210071644.19815.Martin@lichtvoll.de> <5072066B.4020604@gmail.com>
In-Reply-To: <5072066B.4020604@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 08/10/2012 00:47, Goffredo Baroncelli a écrit :
> Please could you clarify if you are using the "autodefrag" options
> when you have the performance problem ?

I use autodefrag on all volumes systematically, except on volumes that I
use for really big files that would always be defragmenting (i.e.
virtual machines, but I seldom use virtual machines, and my performance
problem is general, I don't take VMs into consideration in this respect...)

> Are you in position to to reduce the number of snapshot from hundreds
> to few  ?

I might do this as an experiment, but it would defeat one of the
prominent purposes for which I use BTRFS, and the number of snapshots
would grow immediately again, as I use the excellent OpenSuSE "snapper"
tool, that makes a snapshot every single hour...

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

