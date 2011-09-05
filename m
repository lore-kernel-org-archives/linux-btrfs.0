From: =?ISO-8859-1?Q?Bj=F6rn_Kalkbrenner?= <terminar@cyberphoria.org>
Subject: Re: Problems with set-default, home subvolume and snapshot
Date: Mon, 05 Sep 2011 16:31:48 +0200
Message-ID: <4E64DD54.5000507@cyberphoria.org>
References: <4E64A0C5.2060409@cyberphoria.org> <20110905103033.GL9907@carfax.org.uk> <4E64BE74.7040000@cyberphoria.org> <20110905124544.GN9907@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110905124544.GN9907@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


>    Did you manage to capture that output at all? (A photo would do).
Not yet, i am still on recovery from backup, that may take some time. I=
f
i am done, i'll re-attach the broken btrfs system and dump some informa=
tion.
It shouldn't be a big problem to redirect the kernel messages to a file=
=2E

>    What kernel version are you running? (anything earlier than 2.6.39
> is probably considered too old for comfort)

3.0.0 is my current running kernel. Due to the fact that i created the
whole btrfs filesystem around two weeks before i think i also created i=
t
with 3.0.0 but i am not sure.

> btrfsck doesn't generally achieve much at the moment. However, having
> mount hang is quite odd. It usually either succeeds, or causes a
> kernel oops (if the latter has already happened, then *subsequent*
> mount attempts may hang, but the original oops is still of interest)=20

>    It'd be good if you have the time to try to reproduce this,
> particularly with the latest kernels (3.0 or 3.1-rcX)

I can, with 3.0.0.

Give me some hours of recovery :)


Bj=F6rn

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
