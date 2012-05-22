Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:51839 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757701Ab2EVPGD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 May 2012 11:06:03 -0400
Date: Tue, 22 May 2012 17:05:38 +0200
From: David Sterba <dave@jikos.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Miao Xie <miaoxie1984@gmail.com>, Chris Mason <chris.mason@oracle.com>,
        Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 2/4] Btrfs: fix deadlock on sb->s_umount when doing umount
Message-ID: <20120522150537.GL24394@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <4F98B9BC.7010905@gmail.com>
 <20120426114456.GN20982@twin.jikos.cz>
 <4F9A7B11.1020400@gmail.com>
 <20120430164139.GB6740@twin.jikos.cz>
 <4FA8F789.80208@cn.fujitsu.com>
 <20120508153326.GI19331@twin.jikos.cz>
 <4FA9E36C.3060008@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FA9E36C.3060008@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 09, 2012 at 11:24:28AM +0800, Miao Xie wrote:
> Did you apply the trylock patchs I sent before?

20120429   [PATCH 1/2] vfs: re-implement writeback_inodes_sb(_nr)_if_idle() and rename them
20120429   [PATCH 2/2] Btrfs: flush all the dirty pages if try_to_writeback_inodes_sb_nr() fails

on top of 3.4, no deadlocks occured with looped 269, 264, 254, 276. Mounted with
space_cache,autodefrag .

david
