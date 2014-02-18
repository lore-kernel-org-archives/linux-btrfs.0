Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:50570 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751005AbaBRBFZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Feb 2014 20:05:25 -0500
Date: Tue, 18 Feb 2014 12:05:03 +1100
From: Dave Chinner <david@fromorbit.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Koen De Wit <koen.de.wit@oracle.com>, xfs@oss.sgi.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] xfstests: test for atime-related mount options
Message-ID: <20140218010503.GF13997@dastard>
References: <1392668720-6135-1-git-send-email-koen.de.wit@oracle.com>
 <530273CD.3090303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <530273CD.3090303@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 17, 2014 at 02:40:45PM -0600, Eric Sandeen wrote:
> On 2/17/14, 2:25 PM, Koen De Wit wrote:
> > Tests the noatime, relatime, strictatime and nodiratime mount options.
> > 
> > There is an extra check for Btrfs to ensure that the access time is
> > never updated on read-only subvolumes. (Regression test for bug fixed
> > with commit 93fd63c2f001ca6797c6b15b696a484b165b4800)
> 
> I think this looks ok.  Only little nit is that _require_relatime
> now implicitly requires scratch, but *shrug* it was Dave's idea.  ;)

There's a _require_scratch call in there, so it's all good. ;)
Thanks Koen!

> Thanks!
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

And thanks for the reivew, Eric ;)

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
