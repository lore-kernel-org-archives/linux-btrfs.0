From: Chris Mason <chris.mason@oracle.com>
Subject: Re: weird bash autocomplete issue
Date: Wed, 17 Dec 2008 18:58:09 -0500
Message-ID: <1229558289.27170.109.camel@think.oraclecorp.com>
References: <545246795@web.de>
	 <ac3eb2510812161341x6af4b26erc4254850f11a6fcc@mail.gmail.com>
	 <1229482522.7574.6.camel@nga>
	 <120501c96025$3bfca7c0$0301a8c0@bui.materna.com>
	 <ac3eb2510812170559o32e1942mbaac558dfc380f19@mail.gmail.com>
	 <1229523456.27170.4.camel@think.oraclecorp.com>
	 <ac3eb2510812170646t5f02a9dfp6b01382c84db939d@mail.gmail.com>
	 <ac3eb2510812171415u1b2fc166r2ba10999542808fe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Roland <devzero@web.de>, linux-btrfs@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ac3eb2510812171415u1b2fc166r2ba10999542808fe@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-12-17 at 23:15 +0100, Kay Sievers wrote:
> > There are other filesystems doing the same, usually with 32bit int max
> > instead of 64 bit int max, I guess that should work fine.
> >
> >> This should be fixed in git by now, so I can drop it if that really is
> >> causing problems in bash.
> >
> > I'll come back if I can reproduce it with the same environment Roland is using.
> 
> I see the same issue on x86 32 bit, with the additional __llseek()
> between the getdents64(), and the last entry returned by readdir
> ignored.
> 
> If I change the returned LLONG_MAX to LONG_MAX in inode.c, it all
> works fine, and the __llseek() disappears.

Ok, thanks I'll work up a patch.

-chris


