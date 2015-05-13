Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37677 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932845AbbEMQsQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 12:48:16 -0400
Date: Wed, 13 May 2015 18:48:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>, Learner Study <learner.study@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Mark Fasheh <mfasheh@suse.de>
Subject: Re: de-duplication algos
Message-ID: <20150513164815.GT23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAP8+hKVLpwT7fFqMods0++SKqQSXF5Z1tXNcAgFw_i3utfFeVQ@mail.gmail.com>
 <20150513163553.GV18480@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150513163553.GV18480@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 13, 2015 at 04:35:53PM +0000, Hugo Mills wrote:
> On Wed, May 13, 2015 at 09:24:17AM -0700, Learner Study wrote:
> > Hello,
> > 
> > I have been reading on de-duplication and how algorithms such as Bloom
> > and Cuckoo filters are used for this purpose.
> > 
> > Does BTRFS dedup use any of these, or are there plans to incorporate
> > these in future?
> 
>    There was a long discussion on IRC about different approaches that
> could be taken. I think Mark Fasheh captured most of that somewhere --
> I thought he'd put it on the duperemove github site somewhere, but I
> can't see it right now.

The bloom filter for duperemove has been implemented (as of commit
b7c03422ea9fd11f915804df2b6598a6ed10dfce) and works fine, the memory
footprint is much lower than before.
