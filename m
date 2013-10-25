Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:57951 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab3JYSbg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Oct 2013 14:31:36 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 8F5C17C040A
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 12:31:36 -0600 (MDT)
Date: Fri, 25 Oct 2013 14:31:34 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Martin <m_btrfs@ml1.co.uk>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-progs: allow --init-extent-tree to work when
 extent tree is borked
Message-ID: <20131025183134.GA4543@localhost.localdomain>
References: <1382724100-5276-1-git-send-email-jbacik@fusionio.com>
 <l4ed62$8r3$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <l4ed62$8r3$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 25, 2013 at 07:27:24PM +0100, Martin wrote:
> On 25/10/13 19:01, Josef Bacik wrote:
> > Unfortunately you can't run --init-extent-tree if you can't actually read the
> > extent root.  Fix this by allowing partial starts with no extent root and then
> > have fsck only check to see if the extent root is uptodate _after_ the check to
> > see if we are init'ing the extent tree.  Thanks,
> > 
> > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> > ---
> >  cmds-check.c |  9 ++++++---
> >  disk-io.c    | 16 ++++++++++++++--
> >  2 files changed, 20 insertions(+), 5 deletions(-)
> > 
> > diff --git a/cmds-check.c b/cmds-check.c
> > index 69b0327..8ed7baa 100644
> > --- a/cmds-check.c
> > +++ b/cmds-check.c
> 
> Hey! Quick work!...
> 
> Is that worth patching locally and trying against my example?
> 

Yes, I'm a little worried about your particular case so I'd like to see if it
works.  If you don't see a lot of output after say 5 minutes let's assume I
didn't fix your problem and let me know so I can make the other change I
considered.  Thanks,

Josef
