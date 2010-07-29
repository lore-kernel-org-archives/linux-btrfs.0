From: Josef Bacik <josef@redhat.com>
Subject: Re: Hardlinks-per-directory limit?
Date: Thu, 29 Jul 2010 09:50:52 -0400
Message-ID: <20100729135046.GA2452@localhost.localdomain>
References: <7836277d97c74d44d8f2132e87db0b67.squirrel@webmail.jots.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: "Ken D'Ambrosio" <ken@jots.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <7836277d97c74d44d8f2132e87db0b67.squirrel@webmail.jots.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 29, 2010 at 12:35:59AM -0400, Ken D'Ambrosio wrote:
> Hello, all.  I'm thinking of rolling out a BackupPC server, and -- based
> on the strength of the recent Phoronix benchmarks
> (http://benchmarkreviews.com/index.php?option=com_content&task=view&id=11156&Itemid=23)
> -- had been strongly considering btrfs.  But I do seem to recall that
> there was some sort of hardlinks-per-directory limitation, and BackupPC
> *loves* hardlinks.  Would someone care to either remind me what the issue
> was, or reassure me that it's been rectified?
> 

It's because we pack inode ref's into the same item, so once the item fills up
we can't add anymore refs.  It's still a problem, not sure if/when its getting
fixed.  Thanks,

Josef
