Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56568 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727740AbeIFWGW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Sep 2018 18:06:22 -0400
Date: Thu, 6 Sep 2018 19:29:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix alignment in declaration and prototype of
 btrfs_get_extent
Message-ID: <20180906172935.GF24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1535176079-78283-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1535176079-78283-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 25, 2018 at 01:47:59PM +0800, Liu Bo wrote:
> This fixes btrfs_get_extent to be consistent with our existing
> declaration style.

For the record, indentation styles that are accepted are both, aligning
under the opening ( and tab or double tab indentation on the next line.
Preferrably not spliting the type or long expressions in the argument
lists.

I personally don't like the alignment under opening ( and in some
excessive cases I reformat the code to be more compact. We'll never
agree on one style, so as long as the code does not look ugly as in the
2nd hunk of this patch, there's no "enforcement".

Patch added to misc-next, thanks.
