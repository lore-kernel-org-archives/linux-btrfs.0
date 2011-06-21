From: Calvin Walton <calvin.walton@kepstin.ca>
Subject: Re: Abysmal Performance
Date: Tue, 21 Jun 2011 11:24:11 -0400
Message-ID: <1308669852.2106.7.camel@ayu>
References: <7da312412980843ba746e4e8809060f8@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Henning Rohlfs <x+btrfs@xehonk.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <7da312412980843ba746e4e8809060f8@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2011-06-20 at 23:51 +0200, Henning Rohlfs wrote:
> Hello,
>=20
>  I've migrated my system to btrfs (raid1) a few months ago. Since the=
n=20
>  the performance has been pretty bad, but recently it's gotten=20
>  unbearable: a simple sync called while the system is idle can take 2=
0 up=20
>  to 60 seconds. Creating or deleting files often has several seconds=20
>  latency, too.

I think I=E2=80=99ve been seeing a fairly similar, or possibly the same=
? issue
as well. It looks like it=E2=80=99s actually a regression introduced in=
 2.6.39 -
if I switch back to a 2.6.38 kernel, my latency issues magically go
away! (I'm curious: does using the older 2.6.38.x kernel help with
anyone else that's seeing the issue?)

Some hardware/configuration details:
btrfs on a single disc (Seagate Momentus XT hybrid), lzo compression an=
d
space cache enabled. Some snapshots in use.

I notice that in latencytop I'm seeing a lot of lines with (cropped)
traces like

sleep_on_page wait_on_page_bit read_extent_buffer_ 13.3 msec          0=
=2E5 %

showing up that I didn't see with the 2.6.38 kernel. I occasionally see
latencies as bad as 20-30 seconds on operations like fsync or
synchronous writes.

I think I can reproduce the issue well enough to bisect it, so I might
give that a try. It'll be slow going, though.

--=20
Calvin Walton <calvin.walton@kepstin.ca>

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
