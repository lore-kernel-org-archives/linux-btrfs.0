From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: A Plumber???s Wish List for Linux
Date: Mon, 10 Oct 2011 09:09:37 -0400
Message-ID: <4C18E3B8-FA7E-4BC1-BE5D-B517004321A2@mit.edu>
References: <1317943022.1095.25.camel@mop> <20111007111231.6e11d18e@lxorguk.ukuu.org.uk> <CAPXgP12nDB2NX6hZabmkUZA9n0PZadi6Yv70LNms8fz9+MnVoA@mail.gmail.com> <20111007113820.3b8424a8@lxorguk.ukuu.org.uk> <CAPXgP11K4_eVn4_emEYVzCVUsm-BXDyStk7DnDmFpMTL=404Gg@mail.gmail.com> <20111007152137.GE28351@carfax.org.uk> <20111010111813.GF17912@twin.jikos.cz>
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Hugo Mills <hugo-lkml@carfax.org.uk>,
	Kay Sievers <kay.sievers@vrfy.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-kernel@vger.kernel.org, lennart@poettering.net,
	harald@redhat.com, david@fubar.dk, greg@kroah.com,
	Chris Mason <chris.mason@oracle.com>,
	Btrfs mailing list <linux-btrfs@vger.kernel.org>
To: dave@jikos.cz
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111010111813.GF17912@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 10, 2011, at 7:18 AM, David Sterba wrote:

> "Resetting the UUID on btrfs isn't a quick-and-easy thing - you have to
> walk the entire tree and change every object. We've got a bad-hack in
> meego that uses btrfs-debug-tree and changes the UUID while it runs
> the entire tree, but it's ugly as hell."

Changing the UUID is going to be harder for ext4 as well, once we integrate metadata checksums.   So while it makes sense to have on-line ways of updating labels for mounted file systems it probably makes muchness sense to support it for UUIDs.

I suspect what it means in practice is that it will be useful for file systems to provide fs image copying tools that also generate a new UUID while you're at it, for use by IT administrators and embedded systems manufacturers.

-- Ted