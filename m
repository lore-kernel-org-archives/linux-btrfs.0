Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from datenkhaos.de ([81.89.99.198]:54329 "EHLO mail.datenkhaos.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382Ab3JDVTg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Oct 2013 17:19:36 -0400
Date: Fri, 4 Oct 2013 23:19:48 +0200
From: Johannes Hirte <johannes.hirte@datenkhaos.de>
To: Josef Bacik <jbacik@fusionio.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: relocate csums properly with prealloc extents
Message-ID: <20131004231948.0ee4e03c@datenkhaos.de>
In-Reply-To: <1380289020-2515-1-git-send-email-jbacik@fusionio.com>
References: <1380289020-2515-1-git-send-email-jbacik@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 27 Sep 2013 09:37:00 -0400
Josef Bacik <jbacik@fusionio.com> wrote:

> A user reported a problem where they were getting csum errors when
> running a balance and running systemd's journal.  This is because
> systemd is awesome and fallocate()'s its log space and writes into
> it.  Unfortunately we assume that when we read in all the csums for
> an extent that they are sequential starting at the bytenr we care
> about.  This obviously isn't the case for prealloc extents, where we
> could have written to the middle of the prealloc extent only, which
> means the csum would be for the bytenr in the middle of our range and
> not the front of our range.  Fix this by offsetting the new bytenr we
> are logging to based on the original bytenr the csum was for.  With
> this patch I no longer see the csum errors I was seeing.  Thanks,

Any assessment when this goes upstream? Until it hit Linus tree it
won't won't appear in stable. And this seems rather important.
