Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:37269 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759898Ab3EWXj2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 May 2013 19:39:28 -0400
Date: Fri, 24 May 2013 09:39:25 +1000
From: Dave Chinner <david@fromorbit.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Koen De Wit <koen.de.wit@oracle.com>
Subject: Re: [PATCH] xfstests: btrfs/308: simple sparse copy testcase for
 btrfs
Message-ID: <20130523233925.GF24543@dastard>
References: <519E4590.4080309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <519E4590.4080309@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 23, 2013 at 11:36:32AM -0500, Eric Sandeen wrote:
> From: Koen De Wit <koen.de.wit@oracle.com>
> 
> # Tests file clone functionality of btrfs ("reflinks"):
> #   - Reflink a file
> #   - Reflink the reflinked file
> #   - Modify the original file
> #   - Modify the reflinked file
> 
> [sandeen: add helpers, make several mostly-cosmetic
>  changes to the original testcase]
> 
> Signed-off-by: Koen De Wit <koen.de.wit@oracle.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Originally submitted as test 297

FWIW, this will conflict with Josef's new btrfs/308 patch. You don't
have to use monatomically increasing numbers for the tests anymore
in the fileystem specifc test directories - you could make these
tests btrfs/00[1-4].... :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
