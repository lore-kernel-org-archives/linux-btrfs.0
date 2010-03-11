From: Sander <sander@humilis.net>
Subject: Re: SSD Optimizations
Date: Thu, 11 Mar 2010 08:38:53 +0100
Message-ID: <20100311073853.GA26129@attic.humilis.net>
References: <4B97F7CE.4030405@bobich.net>
 <93cdabd21003101512n6d773084hcf5e4a85aa180480@mail.gmail.com>
 <4B9829B1.1020706@bobich.net>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Gordan Bobic <gordan@bobich.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B9829B1.1020706@bobich.net>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Gordan,

Gordan Bobic wrote (ao):
> Mike Fedyk wrote:
> >On Wed, Mar 10, 2010 at 11:49 AM, Gordan Bobic <gordan@bobich.net> wrote:
> >>Are there options available comparable to ext2/ext3 to help reduce
> >>wear and improve performance?

With SSDs you don't have to worry about wear.

> And while I appreciate hopeful remarks along the lines of "I think
> you'll get more out of btrfs", I am really after specifics of what
> the ssd mount option does, and what features comparable to the
> optimizations that can be done with ext2/3/4 (e.g. the mentioned
> stripe-width option) are available to get the best possible
> alignment of data and metadata to increase both performance and life
> expectancy of a SSD.

Alignment is about the partition, not the fs, and thus taken care of
with fdisk and the like.

If you don't create a partition, the fs is aligned with the SSD.

> Also, for drives that don't support TRIM, is there a way to make the
> FS apply aggressive re-use of erased space (in order to help the
> drive's internal wear-leveling)?

TRIM has nothing to do with wear-leveling (although it helps reducing
wear).
TRIM lets the OS tell the disk which blocks are not in use anymore, and
thus don't have to be copied during a rewrite of the blocks.
Wear-leveling is the SSD making sure all blocks are more or less equally
written to avoid continuous load on the same blocks.

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
