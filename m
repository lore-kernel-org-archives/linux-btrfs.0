Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 110-174-82-20.static.tpgi.com.au ([110.174.82.20]:54307 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754042Ab3FOKd4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Jun 2013 06:33:56 -0400
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Josef Bacik <jbacik@fusionio.com>
Subject: Re: Stale NFS file handle after power loss
Date: Sat, 15 Jun 2013 20:33:50 +1000
Cc: Thomas Koch <thomas@koch.ro>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <65278856.dWSg6uQ8zb@x121e> <201306132145.29326.thomas@koch.ro> <20130614012756.GF658@localhost.localdomain>
In-Reply-To: <20130614012756.GF658@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201306152033.50799.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 14 Jun 2013, Josef Bacik <jbacik@fusionio.com> wrote:
> and put the image up somewhere I can pull it down so I can fix btrfsck to
> fix your file system and test it locally before I send you the
> patch.  Thanks,

Would it be possible to get this sort of thing fixed in the kernel by a scrub?

I've had a similar problem to Thomas (coincidentally also under /var/lib/dpkg) 
and I created a new filesystem and copied all the files across.  That wasn't 
particularly difficult as the system was a virtual machine, but it was still 
rather annoying.

Also if a file is corrupted then I think that rm -f should work to remove it. 
In the example cited the system would be in a good functional state after
"rm -f /var/lib/dpkg/tmp.ci/*" and it seems to me that file corruption 
shouldn't be a good reason to prevent that operation from completing.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
