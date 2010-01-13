From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Btrfs: add a "df" ioctl for btrfs
Date: Wed, 13 Jan 2010 05:25:03 -0500
Message-ID: <20100113102503.GA6887@infradead.org>
References: <20100112202513.GA13414@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100112202513.GA13414@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 12, 2010 at 03:25:13PM -0500, Josef Bacik wrote:
> df is a very loaded question in btrfs.  This gives us a way to get the per-space
> usage information so we can tell exactly what is in use where.  This will help
> us figure out ENOSPC problems, and help users better understand where their disk
> space is going.

Just as discussed before I think it's a really bad idea.  We always had
df reporting inconsistencies due to the way metadata is managed, and
btrfs isn't special in that way.

so, NACK
