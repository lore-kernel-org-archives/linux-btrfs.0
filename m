From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs Bug?
Date: Fri, 9 Apr 2010 07:18:44 -0400
Message-ID: <20100409111844.GD13327@think>
References: <20100408.114640.18413.0@webmail01.vgs.untd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Justin <yoosty69@netzero.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100408.114640.18413.0@webmail01.vgs.untd.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 08, 2010 at 06:46:40PM +0000, Justin wrote:
> Unfortunately I did reformat.
> Actually, I did a complete zero-out of the drive with dd, and then I ran "badblocks -w" on the drive, which returned 0 bad blocks (not sure if this is really a good test for SSD's as there's some amount of internal voo-doo on the drive itself).
> 
> For future reference, how would I go about getting an image of the drive without being able to use btrfs-image?

Well, we'll have to fixup btrfs-image to make it more tolerant of
errors.  It needs options to skip corrupted sections of the btree and
encode what it can.

In this case, I would have had you run btrfs-map-logical, which will
just read the one bad block and save its contents.

We've had cases on ssd where every other byte was ff, so I was curious
how the bad block looked on your intel.

Were you running with trim enabled?

-chris

