Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33988 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932222AbeE3VcG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 17:32:06 -0400
Subject: Re: [PATCH 2/2] btrfs: Refactor running of delayed inode items during
 transaction commit
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <1518531409-31625-1-git-send-email-nborisov@suse.com>
 <1518531409-31625-2-git-send-email-nborisov@suse.com>
 <ffd02095-4489-6d90-a47f-93f4020ab097@jp.fujitsu.com>
 <995d8c20-c619-c4e6-cb3e-2a9196289775@suse.com>
 <94a829c6-378b-6d10-d8e9-b79d856fe381@suse.com>
 <87881c8f-e3f1-30ce-bd76-e99c0fd30c1b@suse.de>
 <72f979be-5ced-bc8e-7cc1-582ca1c23fc3@suse.com>
 <20180528161228.GE6649@twin.jikos.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <eccbc8ad-5377-0d68-c2bb-f1d8f1c6194b@suse.com>
Date: Thu, 31 May 2018 00:32:03 +0300
MIME-Version: 1.0
In-Reply-To: <20180528161228.GE6649@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 28.05.2018 19:12, David Sterba wrote:
> On Mon, May 28, 2018 at 03:26:58PM +0300, Nikolay Borisov wrote:
>>>>>> dmesg looks like:
>>>>>> [    6.649213] WARNING: CPU: 0 PID: 2838 at fs/btrfs/transaction.c:303 record_root_in_trans+0x38/0xd0
> 
> Found in the logs. I reported it to the patch that added the assertion
> but I did not suspect your patches.
> 
>>>>>> [    6.662909]  create_pending_snapshot+0x1ab/0xd00
> 
>> So the answer to your question is "yes", in which case indeed this patch
>> will have to be reverted.
> 
> Both patches removed from misc-next.

I think 1/2 is actually safe, it's removing something from the
transaction path without affecting the overall logic which should be a
small win.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
