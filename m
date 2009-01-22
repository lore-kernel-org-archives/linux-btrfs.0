From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Subject: Re: [Patch] bit-radix.c: fix declarations
Date: Fri, 23 Jan 2009 00:09:01 +0800
Message-ID: <20090122160901.GD9732@hack.private>
References: <20090119141921.GA8507@hack.private> <1232549902.17244.5.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1232549902.17244.5.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 21, 2009 at 09:58:22AM -0500, Chris Mason wrote:
>On Mon, 2009-01-19 at 22:19 +0800, Am=C3=A9rico Wang wrote:
>> bit-radix.c should #include "bit-radix.h", and add a missing declara=
tion
>> for find_next_bit().
>>=20
>> Signed-off-by: WANG Cong <wangcong@zeuux.org>
>>=20
>
>I fixed this a little differently, the bit-radix code wasn't being use=
d
>anymore.  It's gone now ;)
>

Thanks for your explanation!


--=20
"Against stupidity, the gods themselves, contend in vain."

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
