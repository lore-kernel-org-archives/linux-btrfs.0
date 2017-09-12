Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53121 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751405AbdILRaq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 13:30:46 -0400
Date: Tue, 12 Sep 2017 19:29:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Yingyi Luo <yingyil@google.com>
Cc: linux-btrfs@vger.kernel.org, drosen@google.com
Subject: Re: [PATCH 3/4 v2] btrfs-progs: mkfs: refactor create_data_reloc_tree
Message-ID: <20170912172916.GG29043@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170825232101.10859-1-yingyil@google.com>
 <20170830172450.27460-1-yingyil@google.com>
 <20170830172450.27460-4-yingyil@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170830172450.27460-4-yingyil@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 30, 2017 at 10:24:49AM -0700, Yingyi Luo wrote:
> From: yingyil <yingyil@google.com>
> 
> Add an objectid parameter to make the function a general one for
> inserting root items and rename it to create_tree. The change cascades
> down to the callchain.
> 
> Signed-off-by: yingyil <yingyil@google.com>

The patch is independent of the others, applied. Thanks.
