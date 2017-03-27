Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35518 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751278AbdC0Rdx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 13:33:53 -0400
Date: Mon, 27 Mar 2017 19:20:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: convert: Add missing return for HOLE mode
 when checking convert image
Message-ID: <20170327172017.GO4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170321010055.28530-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170321010055.28530-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 21, 2017 at 09:00:55AM +0800, Qu Wenruo wrote:
> In check_convert_image(), for normal HOLE case, if the file extents are
> smaller than image size, we set ret to -EINVAL and print error message.
> 
> But forget to return.
> 
> This patch adds the missing return to fix it.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
