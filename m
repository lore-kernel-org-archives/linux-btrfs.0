Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41064 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369AbaHZKzY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Aug 2014 06:55:24 -0400
Date: Tue, 26 Aug 2014 12:55:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Goffredo Baroncelli <kreijack@libero.it>
Cc: Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/3] btrfs-progs: remove full /dev scanning
Message-ID: <20140826105522.GN29981@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <53F51F4D.2090203@redhat.com>
 <53F635B9.6050900@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53F635B9.6050900@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 21, 2014 at 08:08:57PM +0200, Goffredo Baroncelli wrote:
> Of course I (we) don't care cdrom and/or floppy, but this raises 
> the question: are there other block devices which aren't showed in 
> proc/partitions ? 

cdrom appears as /dev/sr0, floppy is /dev/fd0 if the respective modules
are loaded, no breakage here.

> I am thinking to some less common hardware like
> NON USB sd disk (I saw this kind of hardware, but now I don't have 
> it in my hands....).

A block device whose driver calls register_blkdev should appear in
proc/partitions, if not then I think it's a bug or a very non-standard
interface.

I don't know about any other cases where full /dev scan would reveal
something that /proc/partitions not, so I guess it's safe to remove it.
