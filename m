From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC][PATCH] Sector Size check during Mount
Date: Wed, 30 Nov 2011 10:06:48 -0500
Message-ID: <20111130150648.GB24338@shiny>
References: <1322617452.10304.15.camel@keith-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Keith Mannthey <kmannth@us.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1322617452.10304.15.camel@keith-laptop>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 29, 2011 at 05:44:12PM -0800, Keith Mannthey wrote:
> Gracefully fail when trying to mount a BTRFS file system that has a
> sectorsize smaller than PAGE_SIZE.  
> 
> On PPC it is possible to build a FS while using a 4k PAGE_SIZE kernel
> then boot into a 64K PAGE_SIZE kernel.  Presently open_ctree fails in an
> endless loop and hangs the machine in this situation. 
> 
> My debugging has show this Sector size < Page size to be a non trivial
> situation and a graceful exit from the situation would be nice for the
> time being. 

Thanks.  The large block size patches should finally go into 3.3, which
will make a big difference.

-chris
