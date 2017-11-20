Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58755 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751863AbdKTSLJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 13:11:09 -0500
Date: Mon, 20 Nov 2017 19:09:13 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: ins: print c/o/s/r time of ROOT_ITEM
Message-ID: <20171120180913.GF3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <8bccc1fc-c8bb-9999-dbb7-94185ba5d7e8@jp.fujitsu.com>
 <d5c0fff9-4373-5405-dc09-be33df7f62f2@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <d5c0fff9-4373-5405-dc09-be33df7f62f2@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 31, 2017 at 01:58:04PM +0800, Qu Wenruo wrote:
> 
> 
> On 2017年10月31日 13:40, Misono, Tomohiro wrote:
> > Currently c/o/s/r time of ROOT_ITEM is not printed in print_root_item().
> > Fix this and print them if the values are not zero. print_timespec()
> > is moved forward to reuse.
> > 
> > Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.
