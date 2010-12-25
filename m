From: Christian Thaeter <ct@pipapo.org>
Subject: Re: kernel BUG
Date: Sat, 25 Dec 2010 12:46:28 +0100
Message-ID: <20101225124628.33c47ed0@pluto.pipapo.org>
References: <20101223191213.50848c09@simplux>
	<m3hbe446ms.fsf@pullcord.laptop.org>
	<20101223215500.4f177913@simplux>
	<m3d3os3tuz.fsf@pullcord.laptop.org>
	<20101224013224.43c0f9b3@simplux>
	<m38vzg3sd8.fsf@pullcord.laptop.org>
	<20101225105028.7891342b@simplux>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org, Chris Ball <cjb@laptop.org>,
	Christian Kujau <lists@nerdbynature.de>
To: "Michael Niederle" <mniederle@gmx.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101225105028.7891342b@simplux>
List-ID: <linux-btrfs.vger.kernel.org>

Am Sat, 25 Dec 2010 10:50:28 +0100
schrieb "Michael Niederle" <mniederle@gmx.at>:

> Hi!
> 
> It seems that in my case the bug (fs/btrfs/disk-io.c:2311) was caused
> by a hardware problem.
> 
> I plugged by accident an usb-3.0-drive (that worked quite well for
> several weeks) into an usb-2.0-port (which worked quite well for
> several years). It seems that the two didn't like each other and
> caused these crashes after some time of idling (it seems that the
> idling is necessary for the crash, cause it never crashed while I was
> actually working).
> 
> Greetings, Michael

yes looks the same case here too, I only wanted to point
out that this has to be fixed *someday*, Retrying after a bus reset,
mounting the filesystem readonly or block all IO on the filesystem, but
not bring down the kernel.

	Christian
