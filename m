Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:55817 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab2JHPuX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2012 11:50:23 -0400
Message-ID: <5072F63B.5060608@petaramesh.org>
Date: Mon, 08 Oct 2012 17:50:19 +0200
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

Hi again Goffredo,

Le 08/10/2012 13:38, Goffredo Baroncelli a écrit :
> I fear that both the combination of autodefrag and the high number of
> snapshot could be the root-cause of the the bad performance.
I've removed, on one of my machines, all snapshots but three per subvol
(keeping the oldests and newest), going from about 30 per subvol to 3,
for the complete filesystem from 120+ to about a dozen.

Then I let btrfs-cleaner do its job

After that the machine boots to GUI in a bit less than 2 minutes, where
it was more than 4 minutes previously.

The machine now seems much more reactive and swift.

So it seems that the number or active snapshots (or is it the number of
subvols whatsoever ??) dramatically impacts performance...

Thanks for the suggestion.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

