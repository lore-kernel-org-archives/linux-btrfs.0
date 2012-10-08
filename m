Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:20288 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab2JHNgf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2012 09:36:35 -0400
Message-ID: <5072D6DE.1030600@petaramesh.org>
Date: Mon, 08 Oct 2012 15:36:30 +0200
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Goffredo Baroncelli <kreijack@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS, getting darn slower everyday
References: <50714AC8.4010100@petaramesh.org> <loom.20121007T141248-114@post.gmane.org> <50718151.8090506@petaramesh.org> <201210071644.19815.Martin@lichtvoll.de> <5072066B.4020604@gmail.com> <50726DE1.20101@petaramesh.org> <CAJHuE_CjXaSmWRagSLxOCQpnEkpc1_S_sxSm0pVbXLiGocVA9w@mail.gmail.com>
In-Reply-To: <CAJHuE_CjXaSmWRagSLxOCQpnEkpc1_S_sxSm0pVbXLiGocVA9w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 08/10/2012 13:38, Goffredo Baroncelli a écrit :
> The autodefrag option is per filesystem not per subvolume. The settings
> of the first subvolueme is used also for the other ones.
Uh !

So there is no interest in creating several subvols, some for which
files should be autodefragged, and some not ? That's to bad :-(

> I fear that both the combination of autodefrag and the high number of
> snapshot could be the root-cause of the the bad performance. 

As a test, I will try to remove *most* of my snapshots and see if it
helps...

Thanks for the suggestion !

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

