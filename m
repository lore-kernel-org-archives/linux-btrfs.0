Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:58443 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754261Ab2LMDdQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Dec 2012 22:33:16 -0500
Date: Thu, 13 Dec 2012 14:33:11 +1100
From: Dave Chinner <david@fromorbit.com>
To: Abhijit Pawar <abhi.c.pawar@gmail.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>, Ron Minnich <rminnich@sandia.gov>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Chris Mason <chris.mason@fusionio.com>,
        Steve French <sfrench@samba.org>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, xfs@oss.sgi.com,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, cluster-devel@redhat.com
Subject: Re: [PATCH 4/4] fs: remove obsolete simple_strto<foo>
Message-ID: <20121213033311.GG16353@dastard>
References: <1354881319-23585-1-git-send-email-abhi.c.pawar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1354881319-23585-1-git-send-email-abhi.c.pawar@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 07, 2012 at 05:25:19PM +0530, Abhijit Pawar wrote:
> This patch replace the obsolete simple_strto<foo> with kstrto<foo>

The XFS changes look fine. Consider those:

Acked-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
