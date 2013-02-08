Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.vapor.com ([83.220.149.2]:48705 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947297Ab3BHXiL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Feb 2013 18:38:11 -0500
Date: Sat, 9 Feb 2013 00:37:59 +0100
From: Ian Kumlien <pomac@vapor.com>
To: David Sterba <dsterba@suse.cz>
Cc: kreijack@inwind.it, Ian Kumlien <pomac@demius.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/6] Btrfs-progs: add btrfsck functionality to btrfs
Message-ID: <20130208233759.GP15780@pomac.netswarm.net>
References: <1360283822-23452-1-git-send-email-pomac@demius.net>
 <1360283822-23452-3-git-send-email-pomac@demius.net>
 <51153846.7020304@gmail.com>
 <20130208181713.GO15780@pomac.netswarm.net>
 <20130208230749.GL12339@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130208230749.GL12339@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 09, 2013 at 12:07:50AM +0100, David Sterba wrote:
> On Fri, Feb 08, 2013 at 07:17:13PM +0100, Ian Kumlien wrote:
> > On Fri, Feb 08, 2013 at 06:39:18PM +0100, Goffredo Baroncelli wrote:
> > > H Iam,
> > > 
> > > On 02/08/2013 01:36 AM, Ian Kumlien wrote:
> > > > This patch includes the functionality of btrfs, it's
> > > > found as "btrfs check" however it makes the binary
> > > > behave differently depending on what it's run as.
> > > [...]
> > > 
> > > >  
> > > > +static int cmd_dummy(int argc, char **argv)
> > > > +{
> > > > +	return 0;
> > > 
> > > I think we should warn that fsck.btrfs does nothing. Something like:
> > >  +	fprintf(stderr, "WARNING: fsck.btrfs does nothing. "
> > > 		"Try 'btrfs check'\n");
> > 
> > Yes, will do, perhaps not a big warning but atleast alert the user to
> > the fact.
> 
> I'm not yet decided if I like the no-op functionality merged or if
> fsck.btrfs should be a script like fsck.xfs
> (http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfsprogs.git;a=blob;f=fsck/xfs_fsck.sh;h=c5a96e688b994c36d9ab1b0206225f2f5e7b12e8;hb=HEAD)
> 
> Your version of cmd_dummy is too simple, the mentioned fsck.xfs at least
> checks if the device exists, handles the automatic check options and
> prints a sensible message what to do if the user runs the utility
> expecting it to actually do something.
> 
> I think that a binary named 'btrfsck' should be equvalent to 'btrfs
> check' for backward compatibility, so I'd take this patch without the
> fsck.btrfs bits. Ok?

Thats fine by me, =)

I didn't know that fsck.xfs did that and i agree that it's a much saner
approach, should we do something similar already or just put it in tha
backlock for when it might be... or, when it would actually be usefull?

> david

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
