Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:44763 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753151AbeCSN0n (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 09:26:43 -0400
Message-ID: <1521465998.3786.2.camel@scientia.net>
Subject: Re: [PATCH] btrfs-progs: mkfs: add uuid and otime to ROOT_ITEM of
 FS_TREE
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: dsterba@suse.cz, Hugo Mills <hugo@carfax.org.uk>,
        "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Date: Mon, 19 Mar 2018 14:26:38 +0100
In-Reply-To: <20180319130222.GE6955@twin.jikos.cz>
References: <7ca269db-a724-5938-f4d8-b85e893fd558@jp.fujitsu.com>
         <20180319082010.GC17966@carfax.org.uk>
         <20180319130222.GE6955@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2018-03-19 at 14:02 +0100, David Sterba wrote:
> We can do that by a special purpose tool.

No average user will ever run (even know) about that...

Could you perhaps either do it automatically in fsck (which is IMO als
a bad idea as fsck should be read-only per default)... or at least add
a warning to fsck, like a "Info: Please run tool foo to get bar done."?

Cheers,
Chris.
