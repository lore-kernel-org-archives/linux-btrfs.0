Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52790 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752072AbcH3OGe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2016 10:06:34 -0400
Date: Tue, 30 Aug 2016 16:05:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Lukas Lueg <lukas.lueg@gmail.com>
Subject: Re: [PATCH] btrfs-progs: fuzz-test: Add image for wrong chunk item
 in root tree
Message-ID: <20160830140513.GE16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160830021550.11502-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160830021550.11502-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 30, 2016 at 10:15:50AM +0800, Qu Wenruo wrote:
> From: Lukas Lueg <lukas.lueg@gmail.com>
> 
> Reported by Lukas and the same image from him.
> 
> DATA_RELOC tree's key type is modifed to CHUNK_ITEM, causing btrfsck
> interpret it as CHUNK_ITEM and cause 0 num_stripes.
> 
> Add the image to fuzz-test.
> 
> Signed-off-by: Lukas Lueg <lukas.lueg@gmail.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
