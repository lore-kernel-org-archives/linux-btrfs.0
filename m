Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:25605 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab2JVRFc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Oct 2012 13:05:32 -0400
Message-ID: <50857CD9.3040504@jan-o-sch.net>
Date: Mon, 22 Oct 2012 19:05:29 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix a tree mod bug while inserting a new root
References: <1350914572-4205-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1350914572-4205-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi liubo,

On Mon, October 22, 2012 at 16:02 (+0200), Liu Bo wrote:
> According to btree's balance algorithm, when we split a root into two parts,
> we insert a new one to be their parent:
> 
>                                                  new root
>             node A                            /              \
>       | x1 x2 x3 x4 x5 x6 |   =>          node A             node A'
>                                     | x1 x2 x3 - - - |  | x4 x5 x6 - - - |
>                              split
> 
> The original root won't be freed because it becomes a child of the new root,
> and a move to keep balance is needed then.
> 
> So we should not add REMOVE_WHILE_FREEING keys for the old root, otherwise,
> we will hit use-after-free since we first add REMOVE_WHILE_FREEING keys and
> then add REMOVE keys, which is invalid.

I don't like adding another parameter there, the function is already confusing
without it. I've got a different fix for that problem here as well. I haven't
been sending it since Friday because there's at least one additional problem in
the tree mod log, and I'd like to see all of the issues fixed.

There's also a fix for double frees from push_node_left here. That one may be
fixing the other issue you're seeing (which I still cannot reproduce). I'm still
not convinced it's a good idea to change the semantics in del_ptr as done in
your previous patch set.

Probably we can try working together on irc in a more interactive fashion? Or
tell me if you want my patches anywhere before I send them out.

-Jan
