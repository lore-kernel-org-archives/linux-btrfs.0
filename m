Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:6318 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756025AbaBFWpQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Feb 2014 17:45:16 -0500
Date: Fri, 7 Feb 2014 09:45:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: David Disseldorp <ddiss@suse.de>
Cc: xfs@oss.sgi.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 3/3] btrfs/035: add new clone overwrite regression test
Message-ID: <20140206224509.GC13647@dastard>
References: <1391695154-2039-1-git-send-email-ddiss@suse.de>
 <1391695154-2039-4-git-send-email-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1391695154-2039-4-git-send-email-ddiss@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 06, 2014 at 02:59:14PM +0100, David Disseldorp wrote:
> This test uses the newly added cloner binary to dispatch full file and
> range specific clone (reflink) requests.

....
> +
> +echo -n "$src_str" > $SCRATCH_MNT/src || echo "failed to create src"

Not exactly what I intended.

If echo fails, it will output some kind of error message, and that
will cause the golden image mismatch.

Otherwise the test looks good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
