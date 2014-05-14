Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58414 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbaENSAR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 14:00:17 -0400
Date: Wed, 14 May 2014 20:00:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Frank Kingswood <frank@kingswood-consulting.co.uk>
Cc: dsterba@suse.cz, kreijack@inwind.it,
        Mike Fleetwood <mike.fleetwood@googlemail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 07/14] btrfs-progs: Print more info about device sizes
Message-ID: <20140514180015.GO6917@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1398786620.git.dsterba@suse.cz>
 <cfc78e5581e0142caf9a5fe049213c8e5de90efa.1398786620.git.dsterba@suse.cz>
 <CAMU1PDj3CwYJgiGG27cR+XgZvRFLxY8sAQocRavi8oT9-2Kz+Q@mail.gmail.com>
 <5360E0EF.8030109@libero.it>
 <20140430121140.GI5988@twin.jikos.cz>
 <5360FB26.9090009@kingswood-consulting.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5360FB26.9090009@kingswood-consulting.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 30, 2014 at 02:31:18PM +0100, Frank Kingswood wrote:
> >>>>    Device size:            10.00GiB
> >>>>    FS occuppied:            5.00GiB
> >>>
> >>I found a bit unclear the "FS occupied" terms.
> >
> >We're running out of terms to describe and distinguish the space that
> >the filesystem uses.
> 
> >'occupied' seemed like a good choice to me, though it may be not obvious
> 
> The space that the filesystem uses in total seems to me is called the
> "size". It has nothing to do with utilization.
> 
> /dev/sda6, ID: 2
>     Device size:            10.00GiB
>     Filesystem size:         5.00GiB
> 
> and perhaps only show that "Device size" line if it differs from the
> filesystem size by more than a block.

I have noticed that the help text of 'btrfs fi resize' already uses
'occupy':

$ btrfs fi resize --help
usage: btrfs filesystem resize [devid:][+/-]<newsize>[gkm]|[devid:]max <path>

    Resize a filesystem

    If 'max' is passed, the filesystem will occupy all available space
    on the device 'devid'.


First appeared in

commit 35401ac1902544637ac26634e139f04ae31c2cbf
Author: Goffredo Baroncelli <kreijack@inwind.it>
Date:   Thu Mar 11 22:32:50 2010 +0100

I've been thinking about all the proposals and I'm not feeling
comfortable to pick the winner yet.

So, I'll hide the entry from the output for now so the patchset can be
pushed next step upstream but does not introduce something that's
visible in UI but not agreed on.


