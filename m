Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:47652 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbaDUXBm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Apr 2014 19:01:42 -0400
Date: Mon, 21 Apr 2014 16:01:41 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Do quota groups cost noticeable performance in 3.14?
Message-ID: <20140421230141.GT26949@merlins.org>
References: <20140420195901.GP7884@merlins.org> <pan$a2f12$b2daf6bc$70ff71c$1a6edc97@cox.net> <pan$32bc6$efdaee98$c580d086$1cd467bd@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$32bc6$efdaee98$c580d086$1cd467bd@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 21, 2014 at 10:45:43PM +0000, Duncan wrote:
> New information.  See Josef Bacik's new thread:
 
Very good info, thank you.

It looks however like the use case I'm looking at (mostly write once backups
with snapshots), should not be affected.

I'll give it a shot, and if performance really sucks, I can remove the
quotas, reboot, and that should clear the issues.
I can definitely live with that, especially vs du -sh which could take a
_long_ time to run on my trees :)

Thanks,
Marc

> Snapshot aware defrag and qgroups thoughts
> Monday, 21 April, 7:55:46 -0700
> 
> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/34405
> 
> Looks like he's going to be rewriting qgroups accounting to rework 
> sequence numbers, as part of his work to get a reasonable scalable 
> snapshot-aware-defrag.  But he's on paternity leave ATM, so my guess is 
> that's iffy for the 3.16 commit-window and thus may not make it until 
> 3.17, which @ ~10 weeks a kernel cycle and being ~2 weeks past the 3.15 
> commit window (we're on rc2), leaves us ~18 weeks until 3.17-rc1, early 
> September.
> 
> Anyway, with that rewrite coming, unless you're really itchy to get into 
> qgroups now, I'd wait until after that to dive in.
> 
> Meanwhile, his explanation of the present interaction between qgroups and 
> the (currently disabled) snapshot-aware-defrag was an entirely new thing 
> for me.  As I haven't any current need for qgroups I had somewhat walled 
> that area off as something I didn't mess with or need to know about at 
> this time, but his explanation certainly goes quite some way to 
> explaining why snapshot-aware-defrag was so horribly bad for some people, 
> those unlucky enough to be doing heavy snapshotting, with qgroups active, 
> on very active heavy-internal-rewrite-pattern files.
> 
> I was already (and still) recommending a good snapshot thinning program 
> for those doing automated snapshotting, keeping the number of snapshots 
> per subvolume under 500 and preferably 200-300 max (quite reasonable with 
> a good thinning setup, even with originally per-minute snapshots).  And I 
> was already recommending that people keep large (>1 GiB) heavy-internal-
> rewrite-pattern files NOCOW, on dedicated subvolumes to avoid 
> snapshotting (using conventional backup for them).  But I had no /idea/ 
> qgroups threw another geometric-scaling factor into the mix!
> 
> That definitely adds a new recommendation to the set -- avoid qgroups on 
> subvolumes with heavy-internal-rewrite-pattern files.  And if you MUST 
> qgroup OR heavily snapshot, choose one OR the other, DEFINITELY NOT 
> BOTH!  At least until that qgroups accounting rewrite gets done.
> 
> -- 
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
