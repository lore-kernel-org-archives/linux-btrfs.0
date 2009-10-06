From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: fix possible softlockup in the allocator
Date: Tue, 6 Oct 2009 10:07:14 -0400
Message-ID: <20091006140714.GB25780@think>
References: <20091005193039.GA2308@localhost.localdomain>
 <200910060814.55559.johannes.hirte@fem.tu-ilmenau.de>
 <20091006132942.GB6908@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091006132942.GB6908@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 06, 2009 at 09:29:42AM -0400, Josef Bacik wrote:
> > My box survived 6h of dbench with this patch whereas without it hangs within 
> > the first thwo minutes.
> > 
> 
> Great, I'm glad it fixed it for you.  Thanks for testing and reporting it.

Pushed out to the master branch.  Thanks!

-chris

