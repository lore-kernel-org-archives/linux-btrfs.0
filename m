From: Xavier Nicollet <nicollet@jeru.org>
Subject: Re: Metadata size
Date: Thu, 14 Oct 2010 15:42:21 +0200
Message-ID: <20101014134220.GC13205@jeru.org>
References: <20101014112058.GA2315@selene> <20101014113239.GB2315@selene>
Reply-To: nicollet@jeru.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101014113239.GB2315@selene>
List-ID: <linux-btrfs.vger.kernel.org>

Le 14 octobre 2010 =E0 12:32, Hugo Mills a =E9crit:
>    cwillu on IRC just answered this for me: it's mostly checksums.
>=20
>    Also, it seems that this isn't representative. It's considerably
> lower than normal. :)

Your metadata might be stored twice depending on the options you used
when doing mkfs.

--=20
Xavier Nicollet
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
