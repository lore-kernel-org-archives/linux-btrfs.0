From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Using SDs for caching?
Date: Thu, 18 Jun 2009 15:56:23 +0200
Message-ID: <D3FA806D-C1A1-455F-A4E0-81AAD3E5C615@karlsbakk.net>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed	delsp=yes
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all

I have heard/read about systems from Sun and NetApp using SDs for =20
caching. Sun uses different SDs for read and write caching (one being =20
faster for reads and the other for writes). The storage solution from =20
Sun is based on Solaris with ZFS.

I know too little about filesystems design to know exactly how they do =
=20
this, but can someone think of a way this could be implemented in =20
btrfs? I would think such a cache level could speed up things rather =20
well.

Best regards

roy
--
Roy Sigurd Karlsbakk
(+47) 97542685
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
