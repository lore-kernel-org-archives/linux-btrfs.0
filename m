Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43844 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932095AbeEHRXF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 May 2018 13:23:05 -0400
Date: Tue, 8 May 2018 19:20:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: print-tree: Avoid segfault for heavily
 corrupted item pointers
Message-ID: <20180508172026.GL6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180507074628.1563-1-wqu@suse.com>
 <c799c7cd-d1bb-e650-4348-e325f13ea421@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <c799c7cd-d1bb-e650-4348-e325f13ea421@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 07, 2018 at 04:56:21PM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年05月07日 15:46, Qu Wenruo wrote:
> > Normally corrupted leaf should be caught by csum check, but sometimes
> > corrupted item pointers (out of leaf range) can still pass csum check.
> > In fact, our fsck/005 test case image has such corrupted item pointer
> > and btrfs check can surprisingly fix it.
> > 
> > Anyway, make print-tree to skip such item and remaining slots to avoid
> > segfault.
> > 
> > Please note that, in btrfs-progs we can't put such check into
> > check_tree_block() nor do kernel level comprehensive check as under
> > certain case, btrfs-progs can handle or even repair it.
> > A restrict check_tree_block() or backporting kernel btrfs_check_leaf()
> > could break such test cases and reduce the utility of btrfs-progs.
> > 
> > Issue: #128
> > Reported-by: Hubert Kario <kario@wit.edu.pl>
> 
> Mail changed to <hubert@kario.pl> (Github version already updated.)

Updated and applied, thanks.
