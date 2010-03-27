From: "Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>
Subject: directory order in btrfs
Date: Sat, 27 Mar 2010 10:52:11 +0100
Message-ID: <20100327105211.1285e637@simplux>
References: <20100326111807.24dcc2f0@simplux>
	<20100326212207.424db8af@simplux>
	<20100326202646.GG13680@think>
	<201003262136.32330.kreijack@libero.it>
	<20100326211124.GK13680@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100326211124.GK13680@think>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Chris!

I'm writing the btrfs snapshot diff tool and I would like to know, whether the
entries in a btrfs directory are ordered in some way.

I want to find missing entries in a new snapshot's directory. Can I do a "linear
compare" of the old and new directories or do I have to sort the entries first
(or do some kind of hashing)?

Greetings, Michael
