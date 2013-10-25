Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33598 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975Ab3JYS1g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Oct 2013 14:27:36 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VZm6g-0002pn-1j
	for linux-btrfs@vger.kernel.org; Fri, 25 Oct 2013 20:27:34 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 20:27:34 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 20:27:34 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: [PATCH] Btrfs-progs: allow --init-extent-tree to work when extent
 tree is borked
Date: Fri, 25 Oct 2013 19:27:24 +0100
Message-ID: <l4ed62$8r3$1@ger.gmane.org>
References: <1382724100-5276-1-git-send-email-jbacik@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <1382724100-5276-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25/10/13 19:01, Josef Bacik wrote:
> Unfortunately you can't run --init-extent-tree if you can't actually read the
> extent root.  Fix this by allowing partial starts with no extent root and then
> have fsck only check to see if the extent root is uptodate _after_ the check to
> see if we are init'ing the extent tree.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  cmds-check.c |  9 ++++++---
>  disk-io.c    | 16 ++++++++++++++--
>  2 files changed, 20 insertions(+), 5 deletions(-)
> 
> diff --git a/cmds-check.c b/cmds-check.c
> index 69b0327..8ed7baa 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c

Hey! Quick work!...

Is that worth patching locally and trying against my example?

Thanks,
Martin


