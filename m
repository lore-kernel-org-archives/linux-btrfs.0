From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Subject: Re: [Patch] version.sh: clean up the code
Date: Fri, 23 Jan 2009 00:10:08 +0800
Message-ID: <20090122161008.GE9732@hack.private>
References: <20090119135105.GB7863@hack.private> <1232550093.17244.6.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1232550093.17244.6.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 21, 2009 at 10:01:33AM -0500, Chris Mason wrote:
>On Mon, 2009-01-19 at 21:51 +0800, Am=C3=A9rico Wang wrote:
>> - In bash, integer comparation should use '-eq', not '=3D=3D'.
>> - Remove code for Mercurial, since btrfs now uses git.
>>=20
>
>version.sh should be removed from the mainline sources and only live i=
n
>the standalone tree.  So, I'll apply this one a bit later.
>

OK then.

--=20
"Against stupidity, the gods themselves, contend in vain."

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
