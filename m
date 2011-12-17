From: David McBride <dwm@doc.ic.ac.uk>
Subject: Re: speeding up slow btrfs filesystem
Date: Sat, 17 Dec 2011 12:42:28 +0000
Message-ID: <1324125748.22624.14.camel@squire.doc.ic.ac.uk>
References: <201112161851.52011.Martin@lichtvoll.de>
	 <201112172211.25456.chris@csamuel.org>
	 (sfid-20111217_121719_705910_719A3D83) <201112171300.29833.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201112171300.29833.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2011-12-17 at 13:00 +0100, Martin Steigerwald wrote:

> BTW on my ThinkPad T520 I do not perceive performance issues for BTRFS as 
> /. But then thats located on an Intel SSD 320 where seeks should not 
> matter much.

Okay, that would be consistent with the slow behaviour observed by
others on fsync()-heavy workloads.  Presumably this produces much more
seeky IO patterns than current common filesystems; I wonder if this is a
limitation of the current implementation or something that is an
inherent properties of the data-structures being used?

Cheers,
David
-- 
David McBride <dwm@doc.ic.ac.uk>
Department of Computing, Imperial College, London

