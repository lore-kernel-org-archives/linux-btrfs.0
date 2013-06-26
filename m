Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360Ab3FZUTs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 16:19:48 -0400
Date: Wed, 26 Jun 2013 13:19:44 -0700
From: Zach Brown <zab@redhat.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix crash regarding to ulist_add_merge
Message-ID: <20130626201944.GB10265@lenny.home.zabbo.net>
References: <1372219371-15668-1-git-send-email-bo.li.liu@oracle.com>
 <20130626201829.GA10265@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130626201829.GA10265@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> 		ptrdiff_t diff = new_nodes - old;
> 		ulist->root.rb_node += diff;
> 		for (i = 0; i < ulist->nnodes; i++) {
> 			ulist->nodes[i].rb_node.rb_left += diff;
> 			ulist->nodes[i].rb_node.rb_left += diff;
> 		}

(rb_right in the second case, obviously.  Programming in mutt leaves a
bit to be desired! - z)
