Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62949 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab2HGFDl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Aug 2012 01:03:41 -0400
Received: by obbuo13 with SMTP id uo13so6962694obb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Aug 2012 22:03:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1344284331-24328-1-git-send-email-sensille@gmx.net>
References: <1344284331-24328-1-git-send-email-sensille@gmx.net>
Date: Tue, 7 Aug 2012 00:03:40 -0500
Message-ID: <CAKcLGm-GOA-XpNwyYCNYb3cXeDkzmd1KyYRg=6MJuoe7EhAR+A@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix deadlock in wait_for_more_refs
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Arne Jansen <sensille@gmx.net>
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
        list.btrfs@jan-o-sch.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 6, 2012 at 3:18 PM, Arne Jansen <sensille@gmx.net> wrote:
> Commit a168650c introduced a waiting mechanism to prevent busy waiting in
> btrfs_run_delayed_refs. This can deadlock with btrfs_run_ordered_operations,
> where a tree_mod_seq is held while waiting for the io to complete, while
> the end_io calls btrfs_run_delayed_refs.
> This whole mechanism is unnecessary. If not enough runnable refs are
> available to satisfy count, just return as count is more like a guideline
> than a strict requirement.
> In case we have to run all refs, commit transaction makes sure that no
> other threads are working in the transaction anymore, so we just assert
> here that no refs are blocked.
>

I've been testing this patch after manually merging on top of Josef's
"Btrfs: barrier before waitqueue_active V2" patch.

With that arrangement, I've been unable to reproduce the deadlock on my system.

I'll continue banging away on it tomorrow, and let you know if I
attain a deadlock.

Also, let me know if you need me to test without including Josef's
added barriers.
