Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:48493 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbaJ0NKq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 09:10:46 -0400
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: Marc Dietrich <marvin24@gmx.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: nocow and compression
Date: Mon, 27 Oct 2014 14:10:42 +0100
Message-ID: <1443833.UFNBsg354b@vajra>
In-Reply-To: <2583846.rYj5NyAvhi@fb07-iapwap2>
References: <2033879.2EPALEPetI@fb07-iapwap2> <2878318.cpxBgqOiao@vajra> <2583846.rYj5NyAvhi@fb07-iapwap2>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As far as I understood, "NOCOW" means that modified parts of files be rewritten 
into place, whereas compression causes compressed blocks of variable sizes to 
be created (depending upon their compression ratio). Changing a block in a file 
will most probably change its compressed size, and then you see why it cannot 
be rewritten into place...

Somebody correct me if I'm wrong ;-)


Le lundi 27 octobre 2014, 14:06:36 Marc Dietrich a écrit :
> > 
> > « Compression does not work for NOCOW files » is clearly stated in
> > 
> > https://btrfs.wiki.kernel.org/index.php/Compression#How_does_compression_i
> > nt eract_with_direct_IO_or_COW.3F
> 
> ah, sorry, I somehow overlooked this.
> 
> Thanks
> 
> Marc

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

Tout être manifesté est là pour embaumer, pour exprimer la Présence.
-- Jean-Marc Mantel

