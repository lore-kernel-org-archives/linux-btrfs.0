Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54374 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752021AbeDFNBq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Apr 2018 09:01:46 -0400
Date: Fri, 6 Apr 2018 14:59:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: [PATCH] btrfs-progs: mkfs rootdir: use lgetxattr() not to follow
 a symbolic link
Message-ID: <20180406125916.GB8557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <f53cc5d0-24ff-81b7-68db-0c615edf4936@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f53cc5d0-24ff-81b7-68db-0c615edf4936@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 02, 2018 at 10:59:31AM +0900, Misono Tomohiro wrote:
> mkfs-test 016 "rootdir-bad-symbolic-link" fails when selinux is enabled.
> This is because add_xattr_item() uses getxattr() and tries to follow a
> bad symbolic link for selinux item, which causes ENOENT error.
> 
> The line above already uses llistxattr() for getting list of xattr in
> order not to follow a symbolic link, so just use lgetxattr() too.
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Applied and added to 4.16, thanks.
