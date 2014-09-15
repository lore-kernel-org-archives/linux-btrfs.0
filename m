Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35797 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606AbaIOLoi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 07:44:38 -0400
Date: Mon, 15 Sep 2014 13:44:37 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/4] btrfs-progs: Check superblock's checsum when read
 dev super
Message-ID: <20140915114436.GD9715@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1404380198-25948-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1404380198-25948-2-git-send-email-quwenruo@cn.fujitsu.com>
 <20140915113612.GC9715@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140915113612.GC9715@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 15, 2014 at 01:36:12PM +0200, David Sterba wrote:
> We've got a report of mismatched checksum and bisected to this patch.
...
> But then I don't see the point of the patch, the code would just use a
> bigger temprary buffer for no apparent reason, the outcom is the same.

Scatch that, the patch seems in line with what kernel does and there
must be another reason of the mentioned bug.
