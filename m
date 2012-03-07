From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: compressed btrfs "No space left on device"
Date: Wed, 7 Mar 2012 11:15:54 +0700
Message-ID: <CAG1y0sex2WYSwhtB9U1x_3fkb6DN_WVBmbvbsARmrjBL+BwF1Q@mail.gmail.com>
References: <4EC12C5A.2070304@arndnet.de>
	<4EC15CDB.90103@arndnet.de>
	<4EC3F9E5.60500@arndnet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EC3F9E5.60500@arndnet.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 17, 2011 at 12:59 AM, Arnd Hannemann <arnd@arndnet.de> wrot=
e:
> Am 14.11.2011 19:24, schrieb Arnd Hannemann:
>> Am 14.11.2011 15:57, schrieb Arnd Hannemann:
>>
>>> I'm using btrfs for my /usr/share/ partition and keep getting the f=
ollowing error
>>> while installing a debian package which should take no more than 22=
8 MB:
>>>
>>> Unpacking texlive-fonts-extra (from .../texlive-fonts-extra_2009-10=
ubuntu1_all.deb) ...
>>> =A0dpkg: error processing /var/cache/apt/archives/texlive-fonts-ext=
ra_2009-10ubuntu1_all.deb (--unpack):
>>> =A0unable to install new version of `/usr/share/texmf-texlive/fonts=
/type1/public/allrunes/frutlt.pfb': No space left on device


>> FYI: The problem is the same with mainline kernel v3.1.1.
>
> JFYI: the problem went away in 3.2-rc2 =A0so someone must
> have fixed something.

I just experienced the same thing in Ubuntu precise, 3.2.0-17-generic,
so I don't think it's fixed yet.

$ sudo btrfs fi df /
Data: total=3D43.47GB, used=3D38.47GB
System, DUP: total=3D8.00MB, used=3D12.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, DUP: total=3D3.25GB, used=3D912.47MB
Metadata: total=3D8.00MB, used=3D0.00

$ df -h /
=46ilesystem      Size  Used Avail Use% Mounted on
/dev/sda6        50G   41G  5.1G  89% /

the problem occur when copying precise lxc root template (322M, 13759
files/directories).

It only happens when using zlib compression though, using lzo works fin=
e.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
