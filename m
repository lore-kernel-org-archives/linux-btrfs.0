Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49021 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337AbbI3Qog (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Sep 2015 12:44:36 -0400
Date: Wed, 30 Sep 2015 18:43:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH v3 0/2] btrfs-progs: Introduce warning and error for
 common use
Message-ID: <20150930164335.GN11442@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1443448527.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1443448527.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 28, 2015 at 09:58:12PM +0800, Zhao Lei wrote:
> This patch introduce warning() and error() as common function,
...
> Converting all source is a big work, this patch convert cmds-scrub.c
> We'll convert others these days, and new code can use these function
> directly.
>
> Zhao Lei (2):
>   btrfs-progs: Introduce warning and error for common use
>   btrfs-progs: use common warning/error for cmds-scrub.c

Both applied, thanks. With some changes like joining lines where
possible and shifting the messages left so they fit to ~80 chars.
