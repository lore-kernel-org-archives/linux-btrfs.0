Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38577 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab3KFQyH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 11:54:07 -0500
Date: Wed, 6 Nov 2013 17:54:01 +0100
From: David Sterba <dsterba@suse.cz>
To: John Williams <jwilliams4200@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: csum failure messages
Message-ID: <20131106165401.GX16662@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201311051224.44255.russell@coker.com.au>
 <CAD_cGvE-FtFxZerOKN7T11-L=cEgh_8i-=YcgwG+g1aye6Zn6w@mail.gmail.com>
 <201311052316.34979.russell@coker.com.au>
 <49B5E6AD-795D-4839-A360-7F3782ED7F2F@colorremedies.com>
 <20131105143438.GM14405@carfax.org.uk>
 <CAJBj3veWmB4m+pR2SdZ=y4pRVXfR5aGpfjH2HhoFXbARcZy34w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJBj3veWmB4m+pR2SdZ=y4pRVXfR5aGpfjH2HhoFXbARcZy34w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 05, 2013 at 04:20:58PM -0800, John Williams wrote:
> Is there now a verification test that could detect an issue like this?
> It seems like the sort of thing that needs to be added to automated
> testing.

Yes there is:

xfstests/btrfs/013
https://bugzilla.kernel.org/show_bug.cgi?id=63411
