Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36500 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992AbcGZQ0H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jul 2016 12:26:07 -0400
Date: Tue, 26 Jul 2016 18:25:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: should block unused block groups deletion work
 when allocating data space
Message-ID: <20160726162550.GJ30795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <df0eb696-efea-0902-8e18-131a0898857c@fb.com>
 <20160726120420.29692-1-wangxg.fnst@cn.fujitsu.com>
 <82bb9660-3245-a40c-4ac4-650a235c0d90@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <82bb9660-3245-a40c-4ac4-650a235c0d90@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 26, 2016 at 11:51:39AM -0400, Josef Bacik wrote:
> Also I 
> noticed we already have a delete_unused_bgs_mutex, can we drop that and replace 
> it with bg_delete_sem as well?  Thanks,

Oh, yes please, making sense of all the mutexes and semaphores gets
harder with every new one.
