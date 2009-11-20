From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC] proposal for a btrfs filesystem layout
Date: Fri, 20 Nov 2009 14:54:08 -0500
Message-ID: <20091120195408.GA3110@think>
References: <200911201950.06662.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Chris Ball <cjb@laptop.org>
To: Goffredo Baroncelli <kreijack@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200911201950.06662.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 20, 2009 at 07:50:06PM +0100, Goffredo Baroncelli wrote:
> Hi all,
> 
> after the Chirs (Ball) email, I thought about a possible btrfs file-system 
> layout, which may permit to snapshot the root and mount (if required) an old 
> snapshot of the root.

[ very clear description of a filesystem tree layout ]
> 
> 
> Any comments ? 

This is definitely possible, but not strictly required.  We'll be able
to create an ioctl (or mount option) that replaces the default subvolume
('.' in your examples) pointer with a pointer to another subvolume, and
an ioctl to delete the old root.

Basically it will end up hiding the extra layer of indirection your
proposal adds.  This doesn't mean your ideas were bad, my plan all along
has been to leave this up to the distros to work out with the users, and
give them enough tools that they have the flexibility to do what they
need.

-chris

