From: Subrata Modak <subrata@linux.vnet.ibm.com>
Subject: Re: [LTP] Btrfs TODO
Date: Mon, 13 Apr 2009 18:44:08 +0530
Message-ID: <1239628449.16922.18.camel@subratamodak.linux.ibm.com>
References: <20090409162418.GC20769@unused.rdu.redhat.com>
	 <1239345763.5029.18.camel@subratamodak.linux.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Cc: ltp-list <ltp-list@lists.sf.net>, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1239345763.5029.18.camel@subratamodak.linux.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

On Fri, 2009-04-10 at 12:12 +0530, Subrata Modak wrote:
> Hi Josef,
> 
> On Thu, 2009-04-09 at 12:24 -0400, Josef Bacik wrote:
> > Hello,
> > 
> > Trying to put together a list of TODO items for btrfs so we can update the wiki
> > page fully.  So far these things are on the list
> > 
> > * Proper ENOSPC handling 
> > * O_DIRECT support (without checksumming) 
> > * AIO support 
> > * Subvolume quotas and inherited space usage information 
> > * Snapshot removal
> > * QA Suite for automated regression testing 
> 
> We at LTP would be interested in the above. Please let us know your
> plans in doing Btrfs testing in any ways you do.
> 

Any thoughts for us ?

Regards--
Subrata

> Regards--
> Subrata
> 
> > * Reserved space for online fsck and the ability to add storage so that a
> > * background extent allocation check can proceed 
> > * Additional ioctls to set per-inode attributes (nodatacow, nodatasum, etc)
> > 
> > So I think all of those are still true.  Things that I know are being worked on
> > are
> > 
> > * async block group cacheing - me
> > * locking changes - Chris
> > * backref stuff - Yan
> > 
> > Som other things off the top of my head are
> > 
> > * a better way to cache block groups in general, for this I was thinking of a
> > 	bitmap or something like that per block group of free space
> > * space balancing.  this will likely need to wait on proper ENOSPC handling
> > * grub support :)
> > 
> > Thats all that I can think of atm.  Add things to the list if you think of them,
> > and hopefully we can update the wiki early next week.  Thanks,
> > 
> > Josef
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> ------------------------------------------------------------------------------
> This SF.net email is sponsored by:
> High Quality Requirements in a Collaborative Environment.
> Download a free trial of Rational Requirements Composer Now!
> http://p.sf.net/sfu/www-ibm-com
> _______________________________________________
> Ltp-list mailing list
> Ltp-list@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ltp-list

