Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58677 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961AbaBUBnP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 20:43:15 -0500
Date: Thu, 20 Feb 2014 17:43:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "J. Bruce Fields" <bfields@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 2/9] dcache: close d_move race in d_splice_alias
Message-ID: <20140221014315.GB24522@infradead.org>
References: <20140218202652.GA12374@fieldses.org>
 <1392755345-12830-1-git-send-email-bfields@redhat.com>
 <1392755345-12830-2-git-send-email-bfields@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1392755345-12830-2-git-send-email-bfields@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 18, 2014 at 03:28:58PM -0500, J. Bruce Fields wrote:
> From: "J. Bruce Fields" <bfields@redhat.com>
> 
> d_splice_alias will d_move an IS_ROOT() directory dentry into place if
> one exists.  This should be safe as long as the dentry remains IS_ROOT,
> but I can't see what guarantees that: once we drop the i_lock all we
> hold here is the i_mutex on an unrelated parent directory.
> 
> Instead copy the logic of d_materialise_unique.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
