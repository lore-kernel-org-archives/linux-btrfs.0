Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52838 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751405AbdILR1S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 13:27:18 -0400
Date: Tue, 12 Sep 2017 19:25:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Yingyi Luo <yingyil@google.com>
Cc: linux-btrfs@vger.kernel.org, drosen@google.com
Subject: Re: [PATCH 1/4 v2] btrfs-progs: convert: move link_subvol out of main
Message-ID: <20170912172548.GE29043@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170825232101.10859-1-yingyil@google.com>
 <20170830172450.27460-1-yingyil@google.com>
 <20170830172450.27460-2-yingyil@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170830172450.27460-2-yingyil@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 30, 2017 at 10:24:47AM -0700, Yingyi Luo wrote:
> From: yingyil <yingyil@google.com>
> 
> link_subvol() is moved to utils.c and renamed as btrfs_link_subvol().

The file utils.c is a catch-all file, but the subvolume function belongs
to inode features, similar as in the kernel sources (although there it's
in ioctl.c . Currently link_subvol is misleading name, as it's really
"create_subvol". Please rename it to btrfs_mksubvol and move it to
inode.c.
