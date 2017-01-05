Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59369 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758174AbdAERn4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jan 2017 12:43:56 -0500
Date: Thu, 5 Jan 2017 18:43:38 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix false enospc error when truncating heavily
 reflinked file
Message-ID: <20170105174338.GA12081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160907121738.23713-1-wangxg.fnst@cn.fujitsu.com>
 <4e3e1e7e-aeaf-9b81-0b0e-d1311f2b7ef1@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4e3e1e7e-aeaf-9b81-0b0e-d1311f2b7ef1@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 04, 2017 at 03:52:47PM +0800, Qu Wenruo wrote:
> Any comment on this patch?
> 
> Without it, btrfs will always fail for generic/387.

The fix looks good to me, adding it to next. There's a very similar
pattern in btrfs_punch_hole, but this function uses the trans reserve
and not truncate reserve. The modified reproducer does not trigger the
enospc, but it also could try harder.
