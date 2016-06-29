Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbcF2Nsm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jun 2016 09:48:42 -0400
Date: Wed, 29 Jun 2016 21:48:17 +0800
From: Eryu Guan <eguan@redhat.com>
To: jeffm@suse.com
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/4] btrfs/048: extend _filter_btrfs_prop_error to
 handle additional errors
Message-ID: <20160629134817.GO23649@eguan.usersys.redhat.com>
References: <1467058454-25907-1-git-send-email-jeffm@suse.com>
 <1467058454-25907-2-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1467058454-25907-2-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 27, 2016 at 04:14:11PM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> btrfsprogs v4.5.3 changed the formatting of some error messages.  This
> patch extends the filter for btrfs prop to handle those.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: Eryu Guan <eguan@redhat.com>
