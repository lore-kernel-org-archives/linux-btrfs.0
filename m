From: Calvin Walton <calvin.walton@kepstin.ca>
Subject: Re: Abysmal Performance
Date: Wed, 22 Jun 2011 11:57:25 -0400
Message-ID: <1308758246.484.6.camel@ayu>
References: <7da312412980843ba746e4e8809060f8@localhost>
	 <1308669852.2106.7.camel@ayu> <e5b85820126546a3369499aebb166c60@localhost>
	 <4E020CAF.6080705@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Henning Rohlfs <x+btrfs@xehonk.de>, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E020CAF.6080705@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2011-06-22 at 11:39 -0400, Josef Bacik wrote:
> On 06/22/2011 10:15 AM, Henning Rohlfs wrote:
> > On Tue, 21 Jun 2011 11:24:11 -0400, Calvin Walton wrote:
> >> On Mon, 2011-06-20 at 23:51 +0200, Henning Rohlfs wrote:
> >>> Hello,
> >>>
> >>>  I've migrated my system to btrfs (raid1) a few months ago. Since=
 then
> >>>  the performance has been pretty bad, but recently it's gotten
> >>>  unbearable: a simple sync called while the system is idle can ta=
ke
> >>> 20 up
> >>>  to 60 seconds. Creating or deleting files often has several seco=
nds
> >>>  latency, too.
> >>
> >> I think I=E2=80=99ve been seeing a fairly similar, or possibly the=
 same? issue
> >> as well. It looks like it=E2=80=99s actually a regression introduc=
ed in 2.6.39 -
> >> if I switch back to a 2.6.38 kernel, my latency issues magically g=
o
> >> away! (I'm curious: does using the older 2.6.38.x kernel help with
> >> anyone else that's seeing the issue?)

> >> I think I can reproduce the issue well enough to bisect it, so I m=
ight
> >> give that a try. It'll be slow going, though.
> >=20
> > You are right. This seems to be a regression in the .39 kernel. I t=
ested
> > with 2.6.38.2 just now and the performance is back to normal.
>=20
> Would you mind bisecting?

Just before I was going to try bisecting, I tried the 3.0-rc4 kernel ou=
t
of curiosity. And it seems to be quite a bit better; at the very least,
I=E2=80=99m not seeing gui applications stalling for ~10 seconds when d=
oing
things like opening or writing files. Latencytop is reporting fsync()
latencies staying pretty steady in the range of under 300ms, with
occasional outliers at up to 2s, and it's not getting worse with time.

I'll still look into doing a bisect between 2.6.38 and 2.6.39, I'm
curious what went wrong.

--=20
Calvin Walton <calvin.walton@kepstin.ca>

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
