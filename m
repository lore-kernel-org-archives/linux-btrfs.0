From: "Michael Niederle" <mniederle@gmx.at>
Subject: Re: kernel BUG
Date: Sat, 25 Dec 2010 10:50:28 +0100
Message-ID: <20101225105028.7891342b@simplux>
References: <20101223191213.50848c09@simplux>
	<m3hbe446ms.fsf@pullcord.laptop.org>
	<20101223215500.4f177913@simplux>
	<m3d3os3tuz.fsf@pullcord.laptop.org>
	<20101224013224.43c0f9b3@simplux>
	<m38vzg3sd8.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Chris Ball <cjb@laptop.org>, Christian Thaeter <ct@pipapo.org>,
	Christian Kujau <lists@nerdbynature.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m38vzg3sd8.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

It seems that in my case the bug (fs/btrfs/disk-io.c:2311) was caused by a
hardware problem.

I plugged by accident an usb-3.0-drive (that worked quite well for several
weeks) into an usb-2.0-port (which worked quite well for several years). It
seems that the two didn't like each other and caused these crashes after some
time of idling (it seems that the idling is necessary for the crash, cause it
never crashed while I was actually working).

Greetings, Michael
