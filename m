From: Chris Mason <chris.mason@ORACLE.COM>
Subject: Re: btrfs Bug?
Date: Mon, 12 Apr 2010 10:03:13 -0400
Message-ID: <20100412140313.GM13327@think>
References: <20100409.201055.8629.0@webmail06.vgs.untd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Justin <yoosty69@netzero.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100409.201055.8629.0@webmail06.vgs.untd.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 10, 2010 at 03:10:55AM +0000, Justin wrote:
> As far as I know TRIM was enabled. I didn't forcibly disable it and I'm under the assumption that btrfs enables it when an SSD is detected.

Btrfs won't use trim unless you do mount -o discard.  So, if you weren't
doing this that wasn't the cause.

-chris

> 
> 
> ---------- Original Message ----------
> From: Chris Mason <chris.mason@oracle.com>
> To: Justin <yoosty69@netzero.com>
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: btrfs Bug?
> Date: Fri, 9 Apr 2010 07:18:44 -0400
> 
> On Thu, Apr 08, 2010 at 06:46:40PM +0000, Justin wrote:
> > Unfortunately I did reformat.
> > Actually, I did a complete zero-out of the drive with dd, and then I ran "badblocks -w" on the drive, which returned 0 bad blocks (not sure if this is really a good test for SSD's as there's some amount of internal voo-doo on the drive itself).
> > 
> > For future reference, how would I go about getting an image of the drive without being able to use btrfs-image?
> 
> Well, we'll have to fixup btrfs-image to make it more tolerant of
> errors.  It needs options to skip corrupted sections of the btree and
> encode what it can.
> 
> In this case, I would have had you run btrfs-map-logical, which will
> just read the one bad block and save its contents.
> 
> We've had cases on ssd where every other byte was ff, so I was curious
> how the bad block looked on your intel.
> 
> Were you running with trim enabled?
> 
> -chris
> 
> 
> 
> ____________________________________________________________
> Penny Stock Jumping 2000%
> Sign up to the #1 voted penny stock newsletter for free today!
> http://thirdpartyoffers.netzero.net/TGL3231/4bbfec7c95e751a3b6bst04vuc
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
