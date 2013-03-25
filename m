Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758527Ab3CYP5s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Mar 2013 11:57:48 -0400
Date: Mon, 25 Mar 2013 16:57:43 +0100
From: David Sterba <dsterba@suse.cz>
To: Roger Binns <rogerb@rogerbinns.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: document mount options in
 Documentation/fs/btrfs.txt
Message-ID: <20130325155743.GB12745@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <514DEB06.7000606@redhat.com>
 <kil9uq$210$1@ger.gmane.org>
 <514E2F69.1030204@redhat.com>
 <kiljrq$efp$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <kiljrq$efp$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 23, 2013 at 06:11:26PM -0700, Roger Binns wrote:
> On 23/03/13 15:40, Eric Sandeen wrote:
> > I imagine it depends on the details of the workload & storage as well.
> 
> If the people who write btrfs can't come up with some measures to deem
> appropriateness, then how can the administrators who have even less
> information :-)
> 
> I suspect file size has nothing to do with it, and it is entirely about
> the volume of random writes.  (But as a correlator smaller files are
> unlikely to get many random writes because they contain less useful
> information than larger files.)

I'd say not the volume but the write pattern. A single 4k write may read
and rewrite the surrounding 64k when autodefrag is on. So, several
rewrites close to each other may actually benefit from autodefrag, while
the same number of a completely random 4k rewrites may end up rewriting
16x more data.

(http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg18926.html)

david
