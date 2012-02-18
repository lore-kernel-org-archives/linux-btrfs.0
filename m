From: Marc MERLIN <marc@merlins.org>
Subject: Re: brtfs on top of dmcrypt with SSD. No corruption iff write cache off?
Date: Sat, 18 Feb 2012 08:07:02 -0800
Message-ID: <20120218160702.GB32373@merlins.org>
References: <20120130003754.GD4380@merlins.org> <20120213001400.GD31989@merlins.org> <201202181339.24502.Martin@lichtvoll.de> <201202181349.23385.Martin@lichtvoll.de> <20120130003754.GD4380@merlins.org> <4F384FAA.5060506@redhat.com> <20120213001400.GD31989@merlins.org> <201202181339.24502.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Milan Broz <mbroz@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	jeff@deserettechnology.com
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201202181349.23385.Martin@lichtvoll.de> <201202181339.24502.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 18, 2012 at 01:39:24PM +0100, Martin Steigerwald wrote:
> To Milan Broz: Well now I noticed that you linked to your own blog entry. 

He did not, I'm the one who did.
I asked a bunch of questions since the online docs didn't address them for
me. Some of you answered those for me, I asked access to the wiki and I
updated the wiki to have the information you gave me.

While I have no inherent bias one way or another, obviously I did put some
of your opinions on the wiki :)

> Please do not take my below statements personally - I might have written 
> them a bit harshly. Actually I do not really know whether your statement 
> that TRIM is overrated is correct, but before believing that TRIM does not 
> give much advantage, I would like to see at least some evidence of any 
> sort, cause for me my explaination below that it should make a difference 
> at least seems logical to me.

That sounds like a reasonable request to me.

In the meantime I changed the page to 
'Does Btrfs support TRIM/discard?

"-o discard" is supported, but can have some negative consequences on
performance on some SSDs or at least whether it adds worthwhile performance
is up for debate depending on who you ask, and makes undeletion/recovery
near impossible while being a security problem if you use dm-crypt
underneath (see
http://asalor.blogspot.com/2011/08/trim-dm-crypt-problems.html ), therefore
it is not enabled by default. You are welcome to run your own benchmarks and
post them here, with the caveat that they'll be very SSD firmware specific.'

I'll leave further edits to others ;)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
