From: "Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>
Subject: Re: severe hardlink bug
Date: Sun, 24 Jan 2010 14:27:11 +0100
Message-ID: <20100124142711.4afe8a81@simplux>
References: <20100124015138.092c4959@simplux>
	<201001240909.44753.kreijack@libero.it>
	<20100124140837.5efcd526@simplux>
	<201001241415.47519.kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Goffredo Baroncelli <kreijack@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201001241415.47519.kreijack@inwind.it>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Goffredo!

I understood that a disk layout change will be necessary to accomodate for a
bigger total filename-space per file. So it is best done at once when more
issues arise that will need layout changes.

To recreate the error situation you need a Gentoo Linux with a btrfs root file
system and then try to install the plt-scheme package:

> emerge plt-scheme

Compilation works quite fine, but the installation aborts with a "Too many
links" error.

I reinstalled over 700 packages - plt-scheme beeing the only one failing due to
the btrfs link restriction.

Greetings, Michael
