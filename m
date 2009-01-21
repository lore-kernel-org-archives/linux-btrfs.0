From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [Patch] version.sh: clean up the code
Date: Wed, 21 Jan 2009 10:01:33 -0500
Message-ID: <1232550093.17244.6.camel@think.oraclecorp.com>
References: <20090119135105.GB7863@hack.private>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090119135105.GB7863@hack.private>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-01-19 at 21:51 +0800, Am=C3=A9rico Wang wrote:
> - In bash, integer comparation should use '-eq', not '=3D=3D'.
> - Remove code for Mercurial, since btrfs now uses git.
>=20

version.sh should be removed from the mainline sources and only live in
the standalone tree.  So, I'll apply this one a bit later.

-chris


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
