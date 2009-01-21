From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [Patch] bit-radix.c: fix declarations
Date: Wed, 21 Jan 2009 09:58:22 -0500
Message-ID: <1232549902.17244.5.camel@think.oraclecorp.com>
References: <20090119141921.GA8507@hack.private>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090119141921.GA8507@hack.private>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-01-19 at 22:19 +0800, Am=C3=A9rico Wang wrote:
> bit-radix.c should #include "bit-radix.h", and add a missing declarat=
ion
> for find_next_bit().
>=20
> Signed-off-by: WANG Cong <wangcong@zeuux.org>
>=20

I fixed this a little differently, the bit-radix code wasn't being used
anymore.  It's gone now ;)

-chris


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
