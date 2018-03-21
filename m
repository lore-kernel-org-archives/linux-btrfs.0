Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37042 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751798AbeCURLZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 13:11:25 -0400
Date: Wed, 21 Mar 2018 18:08:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Beautify owner when printing leaf/nodes
Message-ID: <20180321170859.GV6955@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1521535551-23388-1-git-send-email-nborisov@suse.com>
 <c8b272b1-b987-c30a-6fad-ac058fe9d9cd@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <c8b272b1-b987-c30a-6fad-ac058fe9d9cd@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 20, 2018 at 08:52:22PM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年03月20日 16:45, Nikolay Borisov wrote:
> > Currently we print the raw values of the owner field of leaf/nodes.
> > This can result in output like the following:
> > 
> > leaf 30490624 items 2 free space 16061 generation 4 owner 18446744073709551607
> > 
> > With the patch applied the same leaf looks like:
> > 
> > leaf 30490624 items 2 free space 16061 generation 4 owner DATA_RELOC_TREE
> > 
> > Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> 
> Looks good.
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.
