Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37197 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197AbcDDLTd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Apr 2016 07:19:33 -0400
Date: Mon, 4 Apr 2016 13:18:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fsck: Fix a false metadata extent warning
Message-ID: <20160404111852.GG9918@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1459390774-12424-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160331163006.GE6230@twin.jikos.cz>
 <56FDC0A2.1030909@cn.fujitsu.com>
 <20160401084418.GI6230@suse.cz>
 <56FE363E.5090202@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56FE363E.5090202@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 01, 2016 at 04:50:06PM +0800, Qu Wenruo wrote:
> > After another look, why don't we use nodesize directly? Or stripesize
> > where applies. With max_size == 0 the test does not make sense, we ought
> > to know the alignment.
> >
> >
> Yes, my first though is also to use nodesize directly, which should be 
> always correct.
> 
> But the problem is, the related function call stack doesn't have any 
> member to reach btrfs_root or btrfs_fs_info.

JFYI, there's global_info avalaible, so it's not necessary to pass
fs_info down the callstacks.
