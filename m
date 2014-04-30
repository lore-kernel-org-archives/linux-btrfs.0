Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43664 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756344AbaD3MLm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Apr 2014 08:11:42 -0400
Date: Wed, 30 Apr 2014 14:11:41 +0200
From: David Sterba <dsterba@suse.cz>
To: kreijack@inwind.it
Cc: David Sterba <dsterba@suse.cz>,
        Mike Fleetwood <mike.fleetwood@googlemail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 07/14] btrfs-progs: Print more info about device sizes
Message-ID: <20140430121140.GI5988@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1398786620.git.dsterba@suse.cz>
 <cfc78e5581e0142caf9a5fe049213c8e5de90efa.1398786620.git.dsterba@suse.cz>
 <CAMU1PDj3CwYJgiGG27cR+XgZvRFLxY8sAQocRavi8oT9-2Kz+Q@mail.gmail.com>
 <5360E0EF.8030109@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5360E0EF.8030109@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 30, 2014 at 01:39:27PM +0200, Goffredo Baroncelli wrote:
> >> Sample:
> >> /dev/sda7, ID: 3
> >>    Device size:            10.00GiB
> >>    FS occuppied:            5.00GiB
> > 
> > Spelling mistake.  s/occuppied/occupied/.
> 
> I found a bit unclear the "FS occupied" terms. 

We're running out of terms to describe and distinguish the space that
the filesystem uses.

Here's what we have already:

- used
- allocated
- reserved
- total

'occupied' seemed like a good choice to me, though it may be not obvious
at first. The rationale behind is to denote space that the filesystem
can potentially use on the device - in one word.

> Can I suggest "Resized to:" instead of "FS occupied:", and to show it
> only when the two values differ ? In fact this value has a meaning
> only if a filesystem is resized.

'Resized to' sounds good to me and makes sense in the context of the
output:

/dev/sda6, ID: 2
   Device size:            10.00GiB
   Resized to:              5.00GiB
   Data,RAID10:           512.00MiB
   Metadata,RAID10:       512.00MiB
   System,RAID10:           4.00MiB
   Unallocated:             9.00GiB

The next point, display only if it's different from size. This makes
calculating the filesystem size conditional and if eg. I filter the
output I can't simply do 'grep -i occupied'.

The points against that are that this makes the output longer and the
resized devices are probably not the most common scenario.

So as a compromise, we can add an option to enable more verbose output.
