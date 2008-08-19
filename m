From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] NFS support for btrfs - v2
Date: Tue, 19 Aug 2008 15:49:12 +0100
Message-ID: <1219157352.3184.481.camel@pmac.infradead.org>
References: <200807210201.56690.balajirrao@gmail.com>
	 <200808171821.43874.balajirrao@gmail.com>
	 <1218977763.3184.288.camel@pmac.infradead.org>
	 <200808171854.14275.balajirrao@gmail.com>
	 <1218980439.3184.304.camel@pmac.infradead.org>
	 <1219087412.14063.22.camel@think.oraclecorp.com>
	 <1219088029.3184.413.camel@pmac.infradead.org>
	 <1219088859.14063.35.camel@think.oraclecorp.com>
	 <1219090839.3184.436.camel@pmac.infradead.org>
	 <1219091550.14063.44.camel@think.oraclecorp.com>
	 <1219096342.3184.453.camel@pmac.infradead.org>
	 <1219146885.14063.54.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Balaji Rao <balajirrao@gmail.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1219146885.14063.54.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-08-19 at 07:54 -0400, Chris Mason wrote:
> 
> > What if the parent inode actually _is_ inode #0xffffffffffffffff? Can
> > that happen? In that case it would return zero, and I shouldn't subtract
> > 1 from the slot number -- I've actually found what I'm looking for?
> > 
> 
> The max inode will be 2^64 - 1

Which is what we're searching for -- so it's _possible_, albeit
vanishingly unlikely, that btrfs_search_slot() will actually return
zero, having found precisely what we wanted?

And in that case, path->slots[0] being zero is fine. And we shouldn't be
subtracting one from it to find the slot we want?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



