Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41499 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbaBECCl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Feb 2014 21:02:41 -0500
Date: Wed, 5 Feb 2014 03:02:39 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: Kai Krakow <hurikhan77+btrfs@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Are nocow files snapshot-aware
Message-ID: <20140205020239.GP1364@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <mh08sa-5tp.ln1@hurikhan77.spdns.de>
 <52F1923D.8090306@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52F1923D.8090306@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 04, 2014 at 08:22:05PM -0500, Josef Bacik wrote:
> On 02/04/2014 03:52 PM, Kai Krakow wrote:
> >Hi!
> >
> >I'm curious... The whole snapshot thing on btrfs is based on its COW design.
> >But you can make individual files and directory contents nocow by applying
> >the C attribute on it using chattr. This is usually recommended for database
> >files and VM images. So far, so good...
> >
> >But what happens to such files when they are part of a snapshot? Do they
> >become duplicated during the snapshot? Do they become unshared (as a whole)
> >when written to? Or when the the parent snapshot becomes deleted? Or maybe
> >the nocow attribute is just ignored after a snapshot was taken?
> >
> >After all they are nocow and thus would be handled in another way when
> >snapshotted.
> >
> When snapshotted nocow files fallback to normal cow behaviour.

This may seem unclear to people not familiar with the actual
implementation, and I had to think for a second about that sentence. The
file will keep the NOCOW status, but any modified blocks will be newly
allocated on the first write (in a COW manner), then the block location
will not change anymore (unlike ordinary COW).

HTH
