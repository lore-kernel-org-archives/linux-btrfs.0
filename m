Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60911 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbbBMPdW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Feb 2015 10:33:22 -0500
Date: Fri, 13 Feb 2015 16:33:18 +0100
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>, Nishant Agrawal <nragrawal@cs.wisc.edu>,
        linux-btrfs@vger.kernel.org
Subject: Re: How to compile btrfs-progs?
Message-ID: <20150213153318.GG8720@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cc8040167122fea3f732a80a953ef78f@cs.wisc.edu>
 <20150212221018.GS28427@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150212221018.GS28427@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 12, 2015 at 10:10:18PM +0000, Hugo Mills wrote:
> On Thu, Feb 12, 2015 at 04:54:47PM -0500, Nishant Agrawal wrote:
> > Hi,
> > 
> > I am new to btrfs and trying to learn it.
> > 
> > I have download btrfs-progs code from the git repository but not
> > able to compile it.
> > 
> > Can someone help me with the steps to compile this user space programs?
> 
>    There's a bunch of prerequisites you need to install. The wiki
> documentation at [1], [2] may be of assistance. If you're still having
> problems after that, it'd be handy to know how things are going wrong
> for you, rather than "not able to compile".
> 
>    Hugo.
> 
> [1] https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories#Dependencies
> [2] https://btrfs.wiki.kernel.org/index.php/Getting_started#Compiling_the_userspace_utilities

The general build info should be in the INSTALL file at least. Right not
it's not entirely useful. (Hint for an easy patch.)
