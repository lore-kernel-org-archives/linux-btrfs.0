Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34045 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754222AbeEaJci (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 May 2018 05:32:38 -0400
Date: Thu, 31 May 2018 11:29:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: Refactor running of delayed inode items
 during transaction commit
Message-ID: <20180531092952.GK3539@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1518531409-31625-1-git-send-email-nborisov@suse.com>
 <1518531409-31625-2-git-send-email-nborisov@suse.com>
 <ffd02095-4489-6d90-a47f-93f4020ab097@jp.fujitsu.com>
 <995d8c20-c619-c4e6-cb3e-2a9196289775@suse.com>
 <94a829c6-378b-6d10-d8e9-b79d856fe381@suse.com>
 <87881c8f-e3f1-30ce-bd76-e99c0fd30c1b@suse.de>
 <72f979be-5ced-bc8e-7cc1-582ca1c23fc3@suse.com>
 <20180528161228.GE6649@twin.jikos.cz>
 <eccbc8ad-5377-0d68-c2bb-f1d8f1c6194b@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <eccbc8ad-5377-0d68-c2bb-f1d8f1c6194b@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 31, 2018 at 12:32:03AM +0300, Nikolay Borisov wrote:
> On 28.05.2018 19:12, David Sterba wrote:
> > On Mon, May 28, 2018 at 03:26:58PM +0300, Nikolay Borisov wrote:
> >>>>>> dmesg looks like:
> >>>>>> [    6.649213] WARNING: CPU: 0 PID: 2838 at fs/btrfs/transaction.c:303 record_root_in_trans+0x38/0xd0
> > 
> > Found in the logs. I reported it to the patch that added the assertion
> > but I did not suspect your patches.
> > 
> >>>>>> [    6.662909]  create_pending_snapshot+0x1ab/0xd00
> > 
> >> So the answer to your question is "yes", in which case indeed this patch
> >> will have to be reverted.
> > 
> > Both patches removed from misc-next.
> 
> I think 1/2 is actually safe, it's removing something from the
> transaction path without affecting the overall logic which should be a
> small win.

Yeah, but right now we're too close to merge window, please resend them
for the next cycle.
