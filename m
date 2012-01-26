From: cwillu <cwillu@cwillu.com>
Subject: Re: Will BTRFS repair or restore data if corrupted?
Date: Thu, 26 Jan 2012 14:22:37 -0600
Message-ID: <CAE5mzvhMxQ-Xs2MSrTs4jcJjcL_L34AQ+rX7-j9ept9keGCU+Q@mail.gmail.com>
References: <4F208FFD.4020508@online.no>
	<20120126085938.GC5531@carfax.org.uk>
	<4F211DCF.90707@giantdisaster.de>
	<4F21A687.3010506@online.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Stefan Behrens <sbehrens@giantdisaster.de>,
	Hugo Mills <hugo@carfax.org.uk>, Waxhead <waxhead@online.no>,
	linux-btrfs@vger.kernel.org
To: Zoiled <zoiled@online.no>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F21A687.3010506@online.no>
List-ID: <linux-btrfs.vger.kernel.org>

> So if I for example edit a text file three times and store it I can get the
> following.
> Version1: I currently like cheese
> Version2: I currently like onions
> Version3: I currently like apples
> As far as I understand a disk corruption might result in me suddenly liking
> onions (or even cheese) instead of apples without any warning except in
> syslog.?! I really hope I have misunderstood the concept and that there is
> some error correction codes somewhere.

Yes, you've completely misunderstood the concept :p

There are crc's on each 4k block of data; if one copy fails the
checksum, and a second copy is available, and that copy does match,
then the good data will be returned and btrfs will overwrite the
corrupted copy with the good copy.  If there isn't another copy, then
an io error will be returned instead.
