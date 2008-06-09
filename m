From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs device management
Date: Mon, 9 Jun 2008 06:06:09 -0400
Message-ID: <20080609060609.01e5c1d6@think.oraclecorp.com>
References: <62325.68.145.107.21.1212882817.squirrel@avalon.arbitraryconstant.com>
	<20080609064358.GA27849@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: btrfs-devel@arbitraryconstant.com, linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080609064358.GA27849@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 9 Jun 2008 02:43:58 -0400
Christoph Hellwig <hch@infradead.org> wrote:

> On Sat, Jun 07, 2008 at 05:53:37PM -0600,
 
> Yes, I plan to work on adding properly designed multiple device
> support for btrfs and my upcoming similar xfs work.  I'll live in
> good old mount and libvolume_id.
> 

I won't say no to a mount patch either.  The only downside is that
we'll need to update it (in mount) as the format goes through changes
over the summer.  But that is a temporary problem.

-chris
