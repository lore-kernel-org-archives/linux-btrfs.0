Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413Ab2FSPBu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jun 2012 11:01:50 -0400
Date: Tue, 19 Jun 2012 11:01:48 -0400
From: Josef Bacik <josef@redhat.com>
To: Andrew Mahone <andrew.mahone@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: ignore unfragmented file checks in defrag when
 compression enabled
Message-ID: <20120619150148.GA1705@localhost.localdomain>
References: <1340040457-16249-1-git-send-email-andrew.mahone@gmail.com>
 <1340040457-16249-2-git-send-email-andrew.mahone@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1340040457-16249-2-git-send-email-andrew.mahone@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 18, 2012 at 01:27:37PM -0400, Andrew Mahone wrote:
> Inform should_defrag_range if BTRFS_DEFRAG_RANGE_COMPRESS is set. If so, skip
> checks for adjacent extents and extent size when deciding whether to defrag,
> as these can prevent an uncompressed and unfragmented file from being
> compressed as requested.
> 
> Signed-off-by: Andrew Mahone <andrew.mahone@gmail.com>

This patch does not apply cleanly at all, please rebase onto btrfs-next and
resend.  Thanks,

Josef
