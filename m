Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59157 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752343AbdBNLpT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Feb 2017 06:45:19 -0500
Date: Tue, 14 Feb 2017 12:44:48 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/7] btrfs: ulist: make the finalization function public
Message-ID: <20170214114448.GL16928@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1486995885.git.dsterba@suse.com>
 <0e94449a7f999c37d1a69809d49857f0855bfdec.1486995885.git.dsterba@suse.com>
 <50638123-8b6a-c102-47f4-57a176cca873@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50638123-8b6a-c102-47f4-57a176cca873@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 14, 2017 at 05:29:14PM +0800, Qu Wenruo wrote:
> 
> 
> At 02/13/2017 10:30 PM, David Sterba wrote:
> > Make ulist_fini externally visible so the ulist API is complete.
> 
> Looks good to me.
> 
> While I'm not pretty sure if the name "ulist_fini" is good enough.

> 
> Maybe "ulist_finish" or "ulist_release" (just like release_path and 
> free_path)?

Yeah, I don't like the name either, ulist_release sounds ok to me.
