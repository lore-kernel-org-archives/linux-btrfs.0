Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:36333 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbaFPM1F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 08:27:05 -0400
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS, SSD and single metadata
Date: Mon, 16 Jun 2014 14:26:59 +0200
Message-ID: <5397989.Rnm13cYs7v@vajra>
In-Reply-To: <pan$5075b$6568c7ca$c4158fb1$b65edba2@cox.net>
References: <1723493.aXdklhDgAK@vajra> <pan$5075b$6568c7ca$c4158fb1$b65edba2@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le lundi 16 juin 2014, 12:16:33 Duncan a écrit :
> Does btrfs automatically add the ssd mount option or do you have to add 
> it?  If you have to add it, that means btrfs isn't detecting the ssd, 

First time I mounted the freshly created filesystem, it actually added the 
"ssd" option by itself. Thus indeed, it could see this was a SSD...

> However, it occurs to me that with the LUKS encryption layer, I'm not 
> entirely sure if duplication at the btrfs level would end up as the same 
> encrypted stream headed to the hardware in any case.  If it would encrypt 
> the two copies of the dup-mode metadata as different, then the hardware 
> dedup/compression wouldn't work on it anyway.  OTOH, if it encrypts them 
> as the same stream headed to hardware, then again, it would matter.

That makes an excellent point. 2 copies of the same binary data in different 
filesystem sectors, process thru LUKS, will create entirely different binary 
ciphertext, so for sure both metadata copies will always be different and 
cannot be "deduped" by SSD firmware...

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

Les êtres humains, cernés par leurs besoins, s'agitent sans but comme des
lapins pris au piège. Ainsi, moine, détourne-toi de ces besoins et trouve
la liberté.
-- Buddha Shakyamuni

