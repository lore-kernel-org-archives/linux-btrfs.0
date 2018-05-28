Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50118 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933488AbeE1QPP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 12:15:15 -0400
Date: Mon, 28 May 2018 18:12:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Qu Wenruo <wqu@suse.de>, Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: Refactor running of delayed inode items
 during transaction commit
Message-ID: <20180528161228.GE6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1518531409-31625-1-git-send-email-nborisov@suse.com>
 <1518531409-31625-2-git-send-email-nborisov@suse.com>
 <ffd02095-4489-6d90-a47f-93f4020ab097@jp.fujitsu.com>
 <995d8c20-c619-c4e6-cb3e-2a9196289775@suse.com>
 <94a829c6-378b-6d10-d8e9-b79d856fe381@suse.com>
 <87881c8f-e3f1-30ce-bd76-e99c0fd30c1b@suse.de>
 <72f979be-5ced-bc8e-7cc1-582ca1c23fc3@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <72f979be-5ced-bc8e-7cc1-582ca1c23fc3@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 28, 2018 at 03:26:58PM +0300, Nikolay Borisov wrote:
> >>>> dmesg looks like:
> >>>> [    6.649213] WARNING: CPU: 0 PID: 2838 at fs/btrfs/transaction.c:303 record_root_in_trans+0x38/0xd0

Found in the logs. I reported it to the patch that added the assertion
but I did not suspect your patches.

> >>>> [    6.662909]  create_pending_snapshot+0x1ab/0xd00

> So the answer to your question is "yes", in which case indeed this patch
> will have to be reverted.

Both patches removed from misc-next.
