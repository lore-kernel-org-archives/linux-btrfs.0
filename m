Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36451 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750968Ab3LKTnz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Dec 2013 14:43:55 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Martin <m_btrfs@ml1.co.uk>
From: Chris Mason <clm@fb.com>
In-Reply-To: <20131211190104.GM9738@carfax.org.uk>
CC: <linux-btrfs@vger.kernel.org>
References: <l8a8lv$mk7$1@ger.gmane.org> <20131211190104.GM9738@carfax.org.uk>
Message-ID: <20131211194327.12817.49789@ret>
Subject: Re: BTRFS extended attributes mounted on a non-extended-attributes compiled
 kernel
Date: Wed, 11 Dec 2013 14:43:36 -0500
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Hugo Mills (2013-12-11 14:01:04)
> On Wed, Dec 11, 2013 at 05:51:06PM +0000, Martin wrote:
> > What happens if...
> > 
> > I have a btrfs that has utilised posix ACLs / extended attributes and I
> > then subsequently mount that onto a system that does not have the kernel
> > modules compiled for those features?
> > 
> > 
> > Crash and burn?
> > 
> > Or are the extra filesystem features benignly ignored until remounted on
> > the original system with all the kernel modules?
> 
>    Thinking about it, it's probably going to be OK. btrfs itself
> doesn't have any way of turning off EA support, so you'll always have
> the EAs managed correctly. The ACL support (which is implemented
> through EAs, if I remember correctly) can be turned off, so the
> meaning of the ACL EAs will be ignored, but the EA content should
> still be there for when you move to an ACL-enabled system again. Note
> that this gives you a "convenient" way of bypassing POSIX ACLs, by
> switching to a kernel that doesn't enforce them.
> 
>    I've not actually tried this, so I'm willing to be proved wrong,
> but I'll be surprised if that's the case. :)

I do expect it to silently work.  If you have directories that inherit
acls etc, you might not get fully consistent results if you try to
change anything on the non-xattr/acl kernel.

-chris

