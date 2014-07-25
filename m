Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:38530 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaGYJ6W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jul 2014 05:58:22 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: bo.li.liu@oracle.com
Cc: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix compressed write corruption on enospc
Date: Fri, 25 Jul 2014 11:58:20 +0200
Message-ID: <3847663.gxr43pRkb2@merkaba>
In-Reply-To: <20140725010018.GA25859@localhost.localdomain>
References: <1406213285-19607-1-git-send-email-bo.li.liu@oracle.com> <53D11E73.60101@fb.com> <20140725010018.GA25859@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 25. Juli 2014, 09:00:19 schrieb Liu Bo:
> On Thu, Jul 24, 2014 at 10:55:47AM -0400, Chris Mason wrote:
> > On 07/24/2014 10:48 AM, Liu Bo wrote:
> > > When failing to allocate space for the whole compressed extent, we'll
> > > fallback to uncompressed IO, but we've forgotten to redirty the pages
> > > which belong to this compressed extent, and these 'clean' pages will
> > > simply skip 'submit' part and go to endio directly, at last we got data
> > > corruption as we write nothing.
> > 
> > This fallback code was my #1 suspect for the hangs people have been
> > seeing since 3.15.  I changed things around to trigger the fallback
> > randomly and wasn't able to trigger problems, but I was looking for
> > hangs and not corruptions.
> 
> So now you're able to trigger the hang without changing the fallback code?
> 
> I tried raid1 and raid0 with fsmark and rsync in different ways but still
> fails to reproduce the hang :-(
> 
> The most weird thing is who the hell holds the free space inode's page, is
> it possible to share pages with other inode? (My answer is NO, but I'm not
> sure now...)

Can you try doing this on a BTRFS filesystem that has all of block device free 
space filled with its trees already? My suspicion is that this highly 
contributes to the likelyhood of this hang to happen (see my other mail).

This really seems had to hit in a test scenario, while it happens regularily 
on some production filesystems.

Making a kernel package with make-kpkg (from kernel-package package in Debian) 
triggers lockup quite reliably here.

That said, with 3.16.0-rc6-tp520-fixcompwrite+ no lockup so far, but after 
balancing trees do not yet fill whole device again.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
