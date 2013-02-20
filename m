Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60767 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933919Ab3BTSSC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 13:18:02 -0500
Date: Wed, 20 Feb 2013 19:17:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>,
        Mike Fleetwood <mike.fleetwood@googlemail.com>,
        Audrius Butkevicius <audrius.butkevicius@elastichosts.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: add '-b' option to filesystem df and show
Message-ID: <20130220181759.GB27541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130201095947.GA32445@gmail.com>
 <20130201103031.GQ16285@carfax.org.uk>
 <5124CA35.2080009@elastichosts.com>
 <CAMU1PDhjNpJTO14oB26Dxy+HoEwKEEKcxByh6CO+8DiTd1Grfw@mail.gmail.com>
 <20130220145409.GA14283@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130220145409.GA14283@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 20, 2013 at 02:54:09PM +0000, Hugo Mills wrote:
>    Option 1 has an icky global (but one that's pretty much read-only,
> so it's not all that bad). Option 2 pushes a piece of information
> through a whole load of functions which really don't have to know
> about it themselves.
> 
>    Either way, it's not particularly elegant, but either way would
> work. Unless someone else (Chris? Dave?) has any particular feelings
> either way, I'd probably go for option 1.

I prefer option 1 as well.

>    I'd _like_ to see "bytes" as the default option (which also means
> that we don't need to use up -b), but that changes the behaviour of
> the tool (for anyone who was parsing the output of it in scripts), so
> we probably shouldn't do that. OTOH, we're going to be changing the
> output of the tool anyway with this change, so maybe it's worth doing
> it all at once...

For brief overview of the filesytem, the values with suffixes are much easier
to grasp.

This is what I use in scripts:

# perl
sub tobytes($$) {
        my ($a,$suff)=@_;
        $a*=1024*1024*1024*1024 if($suff eq "TiB");
        $a*=1024*1024*1024 if($suff eq "GiB");
        $a*=1024*1024 if($suff eq "MiB");
        $a*=1024 if($suff eq "KiB");

        return $a;
}

so it'll use raw value in case of an unrecognized suffix (forget for now that
it does not recognize the 1000x variants).

david
