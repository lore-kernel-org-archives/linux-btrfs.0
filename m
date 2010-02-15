From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] Btrfs: Full direct I/O and AIO read implementation.
Date: Mon, 15 Feb 2010 16:58:23 -0500
Message-ID: <20100215215823.GA3763@infradead.org>
References: <4B7300BE.5000909@hp.com> <20100212192804.GE4191@localhost.localdomain> <4B77521F.2060105@gmail.com> <20100215164255.GG11057@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>,
	jim owens <owens6336@gmail.com>,
	Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100215164255.GG11057@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 15, 2010 at 11:42:55AM -0500, Chris Mason wrote:
> We can record the smallest alignment while scanning the devices and just
> use that.  In general 4K is good enough, although some other database
> company might be more worried about smaller numbers.

How is access at 512 byte granularity supposed to work?  With 4k logical
sector drives that will require a manual read-modify write cycle in
the direct I/O code, which is counter the intentions.

