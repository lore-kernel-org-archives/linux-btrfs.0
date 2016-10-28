Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41593 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761178AbcJ1Ohk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Oct 2016 10:37:40 -0400
Date: Fri, 28 Oct 2016 16:37:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: Ignore clang complete file
Message-ID: <20161028143738.GF12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161027023248.19561-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161027023248.19561-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 27, 2016 at 10:32:48AM +0800, Qu Wenruo wrote:
> While most guys are using ctags and cscope with vim, new completion tool
> like vim-clang_completion is gaining its popularity, due to its compiler
> level accuracy simpleness to use.
> 
> Since ctags and cscope are already in .gitignore, I see no reason to
> reject .clang_complete.

Me neither, applied. Thanks.
