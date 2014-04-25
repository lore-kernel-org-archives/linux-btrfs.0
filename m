Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45443 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbaDYOrG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 10:47:06 -0400
Date: Fri, 25 Apr 2014 16:47:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Marc MERLIN <marc@merlins.org>
Cc: Justin Maggard <jmaggard10@gmail.com>, Daniel Lee <longinus00@gmail.com>,
        linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: Which companies are using Btrfs in production?
Message-ID: <20140425144704.GC5988@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20140424011834.GN26949@merlins.org>
 <20140424011952.GO26949@merlins.org>
 <535912E5.7080106@gmail.com>
 <CAKgsxVQcNGUU2Jt3PefwwTodVdy-QzujO69Nrby-BnkYzASY4A@mail.gmail.com>
 <20140424231456.GW26949@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140424231456.GW26949@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 24, 2014 at 04:14:56PM -0700, Marc MERLIN wrote:
> > > Netgear uses BTRFS as the filesystem in their refreshed ReadyNAS line.
> > > They apparently use Oracle's linux distro so I assume they're relying on
> > > them to do most of the heavy lifting as far as support BTRFS and
> > > backporting goes since they're still on 3.0! They also have raid5/6
> > > support so they are probably running BTRFS on top of md.
> > >
> > 
> > Yes, and any contributions you see coming from me so far, come from
> > NETGEAR.  I've been using my gmail account because I can't make our
> 
> Thanks. 
> https://btrfs.wiki.kernel.org/index.php/Contributors
> Updated :)

There are lots of contributors with the same small amout of patches
contributed and are not listed there.  This is first time I hear about
Netgear being a contributor and it looks strange to see that name among
the major contributors.

If there's demand to list all the minor contributors, then let's add a
separate section, otherwise I'm going to remove the entry.

This is a sensitive PR topic that I'm normally avoiding, but in this
case I don't see the amount of contributions that would qualify to the
"hall of fame".
