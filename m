From: "Michael Niederle" <mniederle@gmx.at>
Subject: Re: Number of hard links limit
Date: Mon, 2 Aug 2010 21:56:47 +0200
Message-ID: <20100802215647.7466601d@simplux>
References: <20100802114046.GA29926@lh.kyla.fi>
	<20100802130556.GF30325@jeru.org>
	<4ad406cb8ee6c52747b67b4c79a6d7dd@smtp.arbitraryconstant.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: <nicollet@jeru.org>, <linux-btrfs@vger.kernel.org>,
	<cbarratt@users.sourceforge.net>
To: Anthony Roberts <btrfs-devel@arbitraryconstant.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ad406cb8ee6c52747b67b4c79a6d7dd@smtp.arbitraryconstant.com>
List-ID: <linux-btrfs.vger.kernel.org>

> Also, I believe it's not strictly 256 links, it's dependent on the length
> of the names.
> 
> I recall Chris posting something about being able to fix this without a
> format change, though it wasn't a priority yet.

As to my knowledge the limit is 64KB for all names of a single file and due to
Chris it will take a format change to fix this.

I ran into the limit some month ago while installing some Gentoo packages.

Greetings, Michael
