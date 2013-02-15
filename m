Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:56266 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756295Ab3BOSSM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Feb 2013 13:18:12 -0500
Date: Fri, 15 Feb 2013 12:18:07 -0600
From: Ben Myers <bpm@sgi.com>
To: Hemanth Kumar <hemanthkumar51@gmail.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, chethan.casey@gmail.com,
        sandeen@redhat.com, sensille@gmx.net, ganeshkumar14@gmail.com,
        praneethu.u@gmail.com, hugo@carfax.org.uk, bo.li.liu@oracle.com,
        skjmca51@gmail.com, kirantpatil@gmail.com
Subject: Re: [btrfs-progs] Btrfs quotas testing
Message-ID: <20130215181807.GN22182@sgi.com>
References: <1360932324-2722-1-git-send-email-hemanthkumar51@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360932324-2722-1-git-send-email-hemanthkumar51@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey Hemanth,

On Fri, Feb 15, 2013 at 06:15:24PM +0530, Hemanth Kumar wrote:
> 
> Signed-off-by: Hemanth Kumar <hemanthkumar51@gmail.com>

Looks like this is btrfs specific.  You probably don't need to cross post to
xfs@oss.sgi.com, unless you're interested in adding a test to xfstests.  If so,
you might want to check out the existing quota group of tests to see if one
could be modified to your purpose.

~/xfstests$ grep quota group
...

Regards,
Ben
