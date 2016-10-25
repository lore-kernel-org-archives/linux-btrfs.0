Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53206 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965854AbcJYNLZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Oct 2016 09:11:25 -0400
Date: Tue, 25 Oct 2016 15:11:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: minor codes cleanup
Message-ID: <20161025131122.GO22935@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161025105607.17476-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161025105607.17476-1-wangxg.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 25, 2016 at 06:56:07PM +0800, Wang Xiaoguang wrote:
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> ---
> V1: Just one small codes cleanup, if you think it's not appropriate to
>     make a individual patch for it, please ignore it :)

No, that's fine, cleanups are welcome. The subject line could be
improved though, describe what's been cleaned up, eg. "cleanup, use
already calculated value". We could have tons of patches called  minor
cleanups", but this makes searching and processing patches less pleasant
for me.
