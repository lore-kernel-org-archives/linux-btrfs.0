Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53256 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbaEBNNh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 May 2014 09:13:37 -0400
Date: Fri, 2 May 2014 15:13:36 +0200
From: David Sterba <dsterba@suse.cz>
To: kreijack@inwind.it
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 07/14] btrfs-progs: Print more info about device sizes
Message-ID: <20140502131336.GM5988@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1398786620.git.dsterba@suse.cz>
 <cfc78e5581e0142caf9a5fe049213c8e5de90efa.1398786620.git.dsterba@suse.cz>
 <CAMU1PDj3CwYJgiGG27cR+XgZvRFLxY8sAQocRavi8oT9-2Kz+Q@mail.gmail.com>
 <5360E0EF.8030109@libero.it>
 <20140430121140.GI5988@twin.jikos.cz>
 <5360FB26.9090009@kingswood-consulting.co.uk>
 <20140430133715.GA7571@yadt.co.uk>
 <536134F8.2000908@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <536134F8.2000908@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 30, 2014 at 07:38:00PM +0200, Goffredo Baroncelli wrote:
> On 04/30/2014 03:37 PM, David Taylor wrote:
> > On Wed, 30 Apr 2014, Frank Kingswood wrote:
> >> On 30/04/14 13:11, David Sterba wrote:
> >>> On Wed, Apr 30, 2014 at 01:39:27PM +0200, Goffredo Baroncelli wrote:
> >>>>
> >>>> I found a bit unclear the "FS occupied" terms.
> >>>
> >>> We're running out of terms to describe and distinguish the space that
> >>> the filesystem uses.
> >>>
> >>> 'occupied' seemed like a good choice to me, though it may be not obvious
> >>
> >> The space that the filesystem uses in total seems to me is called the
> >> "size". It has nothing to do with utilization.
> >>
> >> /dev/sda6, ID: 2
> >>     Device size:            10.00GiB
> >>     Filesystem size:         5.00GiB
> > 
> > FS size was what I was about to suggest, before I saw your reply.
> 
> Pay attention that this value is not the Filesystem size, 
> but to the maximum space the of THE DEVICE the filesystem is allowed to use.

I agree that plain 'Filesystem size' could be misleading, using the same
term that has an established meaning can cause misuderstandings in
bugreports.
