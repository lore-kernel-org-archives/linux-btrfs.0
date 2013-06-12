Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:52856 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab3FLM7i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Jun 2013 08:59:38 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 286879A0691
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Jun 2013 06:59:38 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
From: Chris Mason <clmason@fusionio.com>
In-Reply-To: <20130610223958.GL24721@lenny.home.zabbo.net>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <JBacik@fusionio.com>
References: <1370384280-28652-1-git-send-email-zab@redhat.com>
 <20130604231653.4088.91500@localhost.localdomain>
 <20130604232657.GE24721@lenny.home.zabbo.net>
 <20130610223958.GL24721@lenny.home.zabbo.net>
Message-ID: <20130612125935.4914.78649@localhost.localdomain>
Subject: Re: [PATCH 0/6] fix INT_MAX readdir hang, plus cleanups
Date: Wed, 12 Jun 2013 08:59:35 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Zach Brown (2013-06-10 18:39:58)
> On Tue, Jun 04, 2013 at 04:26:57PM -0700, Zach Brown wrote:
> > On Tue, Jun 04, 2013 at 07:16:53PM -0400, Chris Mason wrote:
> > > Quoting Zach Brown (2013-06-04 18:17:54)
> > > > Hi gang,
> > > > 
> > > > I finally sat down to fix that readdir hang that has been in the back
> > > > of my mind for a while.  I *hope* that the fix is pretty simple: just
> > > > don't manufacture a fake f_pos, I *think* we can abuse f_version as an
> > > > indicator that we shouldn't return entries.  Does this look reasonable?
> > > 
> > > I like it, and it doesn't look too far away from how others are abusing
> > > f_version.  Have you tried with NFS?  I don't think it'll hurt, but NFS
> > > loves to surprise me.
> > 
> > Mm, no, I hadn't.  I'll give it a go tomorrow.  What could go wrong? :)
> 
> Or a week later.  Pretty close!
> 
> I couldn't get NFS to break.  Clients see new entries created directly
> in the exported btrfs and on either of noac and actime=1 client mounts.
> For whatever that's worth.

Great.

> 
> But I did find that I'd broken the case of trying to re-enable readdir
> results by seeking past the last entry (which happens to be the current
> f_pos now that we're using f_version).
> 
> Here's the incremental fix against what Josef has in -next.  I'm cool
> with either squashing or just committing it.

Lets squash it in, Josef loves to rebase.

-chris
