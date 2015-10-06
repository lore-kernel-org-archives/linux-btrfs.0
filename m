Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54286 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbbJFI06 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Oct 2015 04:26:58 -0400
Date: Tue, 6 Oct 2015 10:25:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-btrfs@vger.kernel.org, jbacik@fb.com, clm@fb.com,
        david@fromorbit.com
Subject: Re: [RFC][PATCH] btrfs: add ioctl to monitor subvolume dropping
Message-ID: <20151006082552.GA7734@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20151001213047.GB1044@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151001213047.GB1044@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 01, 2015 at 02:30:47PM -0700, Mark Fasheh wrote:
> At the moment, userspace has no way of knowing when a snapshot is finally
> removed. This has become a problem when writing tests for btrfs,
> 
> http://article.gmane.org/gmane.comp.file-systems.fstests/1239/

In the meantime the command 'btrfs subvolume sync /path id' has been
implemented which does what you need, without the new ioctl.

Also, you can query root_item::drop_progress directly through the
SEARCH_TREE ioctl as well.
