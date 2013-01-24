Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:54311 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab3AXPeX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 10:34:23 -0500
Date: Thu, 24 Jan 2013 10:34:20 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Cong Ding <dinggnu@gmail.com>
CC: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] btrfs: fix potential null pointer dereference bug
Message-ID: <20130124153420.GC2349@localhost.localdomain>
References: <1358609265-347-1-git-send-email-dinggnu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1358609265-347-1-git-send-email-dinggnu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 19, 2013 at 08:27:45AM -0700, Cong Ding wrote:
> The bug happens when rb_node == NULL. It causes variable node to be NULL and
> then the NULL pointer is dereferenced this line:
> 	BUG_ON((struct btrfs_root *)node->data != root);
> 
> Based on my analysis, function tree_search should not return NULL to variable
> rb_node in this case (otherwise here has to be something unknown thing wrong),
> so I replace "if (rb_node)" with UG_ON(!rb_node).
> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>

I don't want to add more BUG_ON()'s, just return an error.

Josef
