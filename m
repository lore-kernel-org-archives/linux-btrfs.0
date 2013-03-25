Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:51113 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757826Ab3CYN7d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Mar 2013 09:59:33 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 3E0B39A0645
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2013 07:59:33 -0600 (MDT)
Date: Mon, 25 Mar 2013 09:59:30 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Roger Binns <rogerb@rogerbinns.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: document mount options in
 Documentation/fs/btrfs.txt
Message-ID: <20130325135930.GF1955@localhost.localdomain>
References: <514DEB06.7000606@redhat.com>
 <kil9uq$210$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <kil9uq$210$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 23, 2013 at 04:22:22PM -0600, Roger Binns wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 23/03/13 10:48, Eric Sandeen wrote:
> > Btrfs is a new copy on write filesystem for Linux aimed at
> 
> How much longer does "new" get to be there as the filesystem has been
> going for well over half a decade.
> 
> > +  autodefrag +	Detect small random writes into files and queue them up
> > for the +	defrag process.  Works best for small files; Not well suited
> > for +	large database workloads.
> 
> What is "large"?  One man's large database is another's trivial database!
>  Same applies to "small".  Virtual machines are also in the category of
> large files with small random writes.
> 

Any write below i_size that is less than 64k.

Josef
