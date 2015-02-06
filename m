Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36735 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753704AbbBFSE5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Feb 2015 13:04:57 -0500
Date: Fri, 6 Feb 2015 19:04:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Lutz Vieweg <lvml@5t9.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Can I get a checksum for a file from btrfs (without reading the
 whole file)?
Message-ID: <20150206180455.GN24227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <mavhab$f8m$1@ger.gmane.org>
 <54D44F2A.8090108@cn.fujitsu.com>
 <mb2du5$esf$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <mb2du5$esf$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 06, 2015 at 02:00:53PM +0100, Lutz Vieweg wrote:
> On 02/06/2015 06:20 AM, Qu Wenruo wrote:
> > From: Lutz Vieweg <lvml@5t9.de>
> >> use case: You have two huge files on a btrfs, you assume they contain the same bytes,
> >> but you do not know for sure.
> >>
> >> Is there a way to get a checksum of both files from btrfs with less effort than
> >> reading the whole of both files and computing a hash sum?
> > For short, NO.
> >
> > For long:
> > For current implement, btrfs use calculate 4K sector into 4bytes(32bit) crc32 and restore it into
> > csum tree.
> >
> > So, for large files, e.g. 1G(already quite small for modern storage), its checksum will be 1M in size.
> > Which means even using crc32 (same as kernel and crc32(a+b) = crc32(a) + crc32(b)), you still needs to
> > do crc32 on the all 1M crc32.
> 
> And yet, having to read only 1 MB checksums instead of 1 GB data sounds
> like a good deal - is there some userspace interface allowing to read
> (only) those per-4k checksums for a file?

Just a POC code how to get the csum for a given block (based on the
SEARCH ioctl, needs root):

http://repo.or.cz/w/btrfs-progs-unstable/devel.git/commit/33a4d171552736da2977323797f53d9cea830e2f

crc32 is weak but can be used to detect early(-ier) if the files are
different. A hash collision in the middle of huge files is possible but
I guess very low.
