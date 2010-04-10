From: "Justin" <yoosty69@netzero.com>
Subject: Re: btrfs Bug?
Date: Sat, 10 Apr 2010 03:10:55 GMT
Message-ID: <20100409.201055.8629.0@webmail06.vgs.untd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

As far as I know TRIM was enabled. I didn't forcibly disable it and I'm under the assumption that btrfs enables it when an SSD is detected.


---------- Original Message ----------
From: Chris Mason <chris.mason@oracle.com>
To: Justin <yoosty69@netzero.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs Bug?
Date: Fri, 9 Apr 2010 07:18:44 -0400

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



____________________________________________________________
Penny Stock Jumping 2000%
Sign up to the #1 voted penny stock newsletter for free today!
http://thirdpartyoffers.netzero.net/TGL3231/4bbfec7c95e751a3b6bst04vuc
