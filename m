Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:43876 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752418Ab3GXXHR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Jul 2013 19:07:17 -0400
Date: Wed, 24 Jul 2013 18:07:12 -0500
From: Ben Myers <bpm@sgi.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] xfstests: make the scratch device for generic/256
 slightly larger
Message-ID: <20130724230712.GV3111@sgi.com>
References: <1372792638-23957-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372792638-23957-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 02, 2013 at 03:17:18PM -0400, Josef Bacik wrote:
> This is similar to a previous fix I sent.  1 gig makes us do mixed file block
> groups for btrfs, so these enospc tests will usually fail because we don't have
> space for metadata, which is the case for this test.  So jack the size up to
> 1.5gig so that btrfs can do its normal thing and pass the test.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

Looks fine to me.  

Reviewed-by: Ben Myers <bpm@sgi.com>
