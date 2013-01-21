Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43082 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135Ab3AULA2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jan 2013 06:00:28 -0500
Date: Mon, 21 Jan 2013 12:00:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Skender <skender@gmail.com>
Cc: linux-btrfs@vger.kernel.org, jbacik@fusionio.com
Subject: Re: BTRFS dmesg error
Message-ID: <20130121110026.GE19967@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130121060136.GA11275@blackspider>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130121060136.GA11275@blackspider>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 21, 2013 at 05:01:36PM +1100, Skender wrote:
> I noticed in the dmesg logs that there seems to be a bug/issue with btrfs. Here is the trace/message from dmesg. Im going by the instructions from 
> the https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#How_do_I_report_bugs_and_issues.3F . Let me know if you need anything else.

Please paste a few lines around the messages, the error code is missing,
though I'm suspecting it to be ENOSPC:

submit_compressed_extents:
 659                 if (IS_ERR(trans)) {
 660                         ret = PTR_ERR(trans);
 661                 } else {
 662                         trans->block_rsv = &root->fs_info->delalloc_block_rsv;
 663                         ret = btrfs_reserve_extent(trans, root,
 664                                            async_extent->compressed_size,
 665                                            async_extent->compressed_size,
 666                                            0, alloc_hint, &ins, 1);
 667                         if (ret)
 668                                 btrfs_abort_transaction(trans, root, ret);

(here it aborts)

 669                         btrfs_end_transaction(trans, root);
 670                 }

I've never seen this error before.

david
