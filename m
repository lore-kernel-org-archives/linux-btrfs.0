From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Blocksizes and deduplication
Date: Fri, 29 May 2009 21:49:56 +0200
Message-ID: <1A3E162E-474B-4422-9826-C89577D6E03F@karlsbakk.net>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed	delsp=yes
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I've seen a few posts in here about deduplication, and I wonder, would =
=20
it be better if we abstracted the block size for deduplication to =20
something more than just a page? Data deduplication isn't found in any =
=20
other open source file systems as far as I know, so this could help =20
btrfs out a bit.

roy
--
Roy Sigurd Karlsbakk
(+47) 97542685 / 98013356
roy@karlsbakk.net
http://blogg.karlsbakk.net/
--
I all pedagogikk er det essensielt at pensum presenteres =20
intelligibelt. Det er et element=E6rt imperativ for alle pedagoger =E5 =
=20
unng=E5 eksessiv anvendelse av idiomer med fremmed opprinnelse. I de =20
fleste tilfeller eksisterer adekvate og relevante synonymer p=E5 norsk.

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
