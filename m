Return-Path: <SRS0=+rOy=PS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38747C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 12:00:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11793214C6
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 12:00:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbfAJMAF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 10 Jan 2019 07:00:05 -0500
Received: from aquinas.techsquare.com ([75.125.237.226]:51861 "EHLO
        techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727386AbfAJMAF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Jan 2019 07:00:05 -0500
Received: from sb by techsquare.com with local (Exim 4.71)
        (envelope-from <sb@techsquare.com>)
        id 1ghZ0E-0004DG-Lp; Thu, 10 Jan 2019 07:00:02 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <23607.13250.659000.140295@techsquare.com>
Date:   Thu, 10 Jan 2019 07:00:02 -0500
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     "Scott E. Blomquist" <sb@techsquare.com>, Jojo <jojo@automatix.de>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs hang on nfs?
In-Reply-To: <f95b63e3-9da5-ea60-3b4c-fbdf223f439c@suse.com>
References: <23605.54017.819143.292441@techsquare.com>
        <6d8d3b43-dc73-42b8-7c70-2fb8a3b0d98c@automatix.de>
        <23605.63394.330818.203495@techsquare.com>
        <23607.12444.740949.683554@techsquare.com>
        <f95b63e3-9da5-ea60-3b4c-fbdf223f439c@suse.com>
X-Mailer: VM 8.0.13 under 23.1.1 (x86_64-pc-linux-gnu)
From:   "Scott E. Blomquist" <sb@techsquare.com>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: sb@techsquare.com
X-SA-Exim-Scanned: No (on techsquare.com); SAEximRunCond expanded to false
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Nikolay Borisov writes:
 > > 
 > > Unfortunately the cfq scheduler did not help.  The system wedged.
 > > 
 > > I did notice this for the first time...
 > > 
 > >     [Wed Jan  9 06:03:41 2019] BTRFS info (device sda1): the free space cache file (83320273633280) is invalid, skip it
 > 
 > What you could do is mount btrfs with -o clear_cache to make btrfs
 > rebuild the freespace cache.
 > 
 > > 
 > > anything I should do about that?
 > > 
 > > The messages were similar...
 > > 
 > >     [Wed Jan  9 23:52:04 2019] INFO: task nfsd:2997 blocked for more than 120 seconds.
 > >     [Wed Jan  9 23:52:04 2019]       Not tainted 4.17.14-custom #1
 > >     [Wed Jan  9 23:52:04 2019] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 > >     [stuff deleted]
 > >     [Wed Jan  9 23:54:07 2019] RBP: 00007f0c3f348c60 R08: 00000000000000ff R09: 0000000000001000
 > >     [Wed Jan  9 23:54:07 2019] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000a6672f
 > >     [Wed Jan  9 23:54:07 2019] R13: 00007f0c918affe0 R14: 0000000000000000 R15: 00007f0c918affb0
 > > 
 > 
 > These don't tell the full story, what seems to be happening is that
 > stuff is waiting for transaction to finish but it's not evident which
 > thread is holding the transaction. Please, paste the output of
 > "echo w > /proc/sysrq-trigger" so we have full picture of what's blocked
 > where.
 > 

Thanks.  I have not seen the free space cache message with the new
kernel.

Next time the hang pops up I'll echo w > /proc/sysrq-trigger and send
it along.

I am hoping that the new kernel will magically fix the problem.

Thanks again,

sb. Scott Blomquist
