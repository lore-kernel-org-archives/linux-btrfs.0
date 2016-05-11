Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31802 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092AbcEKXEd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 May 2016 19:04:33 -0400
Date: Wed, 11 May 2016 16:06:16 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] Btrfs-progs: add three more valid checks for
 superblock
Message-ID: <20160511230616.GB32358@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1462213135-29678-1-git-send-email-bo.li.liu@oracle.com>
 <1462213135-29678-2-git-send-email-bo.li.liu@oracle.com>
 <20160511133629.GD29353@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160511133629.GD29353@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 11, 2016 at 03:36:29PM +0200, David Sterba wrote:
> On Mon, May 02, 2016 at 11:18:54AM -0700, Liu Bo wrote:
> > This adds valid checks for super_total_bytes, super_bytes_used and
> > super_stripesize.
> > 
> > Since these checks are made after superblock finishes checksum
> >  checking, this also adds a notice of "superblock checksum match but..".
> > 
> > This also replaces different kinds of printf with helper error() and
> > warning().
> 
> "This patch also does something completely different" is a good sign for
> patch splitting. I'll do that now but please keep that in mind next
> time.

Ah thanks a lot for that, I'd think more about maintenance.

Thanks,

-liubo
