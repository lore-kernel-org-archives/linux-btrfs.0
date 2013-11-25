Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36304 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab3KYQMS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Nov 2013 11:12:18 -0500
Date: Mon, 25 Nov 2013 08:12:16 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Josef Bacik <jbacik@fusionio.com>
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfstests: add generic/321 to test fsync() on
 directories V2
Message-ID: <20131125161216.GA5085@infradead.org>
References: <1384538464-7384-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1384538464-7384-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 15, 2013 at 01:01:03PM -0500, Josef Bacik wrote:
> Btrfs had some issues with fsync()'ing directories and fsync()'ing after
> renames.  These three new tests cover the 3 different issues we were seeing.
> This breaks out the dmflakey stuff into a common helper to be shared between
> generic/311 and generic/321. Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

This doesn't seem to actually create the common/dmflakey file.

