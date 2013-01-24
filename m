Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:48067 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755893Ab3AXXOg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 18:14:36 -0500
Date: Thu, 24 Jan 2013 18:14:34 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Zach Brown <zab@redhat.com>
CC: Eric Sandeen <sandeen@redhat.com>, Anand Jain <anand.jain@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "dsterba@suse.cz" <dsterba@suse.cz>, "gene@czarc.net" <gene@czarc.net>
Subject: Re: [PATCH 10/10] Btrfs-progs: add show subcommand to subvol cli
Message-ID: <20130124231434.GA18554@shiny.int.fusionio.com>
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>
 <1358928771-31960-11-git-send-email-anand.jain@oracle.com>
 <5100C156.6010107@redhat.com>
 <20130124194238.GE14246@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130124194238.GE14246@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 24, 2013 at 12:42:38PM -0700, Zach Brown wrote:
> 
> > > +	if (sv_id == 5) {
> > > +		printf("%s is btrfs root\n", fullpath);
> > > +		close(fd);
> > > +		close(mntfd);
> > > +		free(mnt);
> > > +		free(fullpath);
> > > +		return 1;
> > 
> > Just wondering, at this point might a "goto out;" be cleaner error
> > handling?  Every error case is getting longer ;)
> 
> No wondering needed!  This pattern is a source of bugs.  I'm hitting
> cases in the static analysis reports of people adding return paths
> without recognizing the pile of state they're expected to cleanup.
> 
> Use safe unwinding in one exit path at the end, please.  It's less
> maddening to audit and less likely to fail over time.

Really, goto is your friend ;)

-chris

