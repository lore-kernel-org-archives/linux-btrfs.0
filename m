Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46C62C43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 13:31:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1382A206BB
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 13:31:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730832AbfAINbQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 9 Jan 2019 08:31:16 -0500
Received: from aquinas.techsquare.com ([75.125.237.226]:55994 "EHLO
        techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730656AbfAINbP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jan 2019 08:31:15 -0500
Received: from sb by techsquare.com with local (Exim 4.71)
        (envelope-from <sb@techsquare.com>)
        id 1ghDww-0002Lm-EH; Wed, 09 Jan 2019 08:31:14 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Message-ID: <23605.63394.330818.203495@techsquare.com>
Date:   Wed, 9 Jan 2019 08:31:14 -0500
To:     Jojo <jojo@automatix.de>
Cc:     "Scott E. Blomquist" <sb@techsquare.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs hang on nfs?
In-Reply-To: <6d8d3b43-dc73-42b8-7c70-2fb8a3b0d98c@automatix.de>
References: <23605.54017.819143.292441@techsquare.com>
        <6d8d3b43-dc73-42b8-7c70-2fb8a3b0d98c@automatix.de>
X-Mailer: VM 8.0.13 under 23.1.1 (x86_64-pc-linux-gnu)
From:   "Scott E. Blomquist" <sb@techsquare.com>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: sb@techsquare.com
X-SA-Exim-Scanned: No (on techsquare.com); SAEximRunCond expanded to false
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Jojo writes:
 > 
 > Within scheduler there were some changes according to device queueing.
 > Kernels after 4.16 and before 4.19.8 were problematic, as we recognized
 > here.
 > This seemed to be a regression on the "kyber" scheduler, as recognized here:
 > [root@pc7 sysctl.d]# cat /sys/block/sdc/queue/scheduler
 > mq-deadline [kyber] bfq none
 > 
 > As work around you may change the disc scheduler to an "old" one, like
 > 
 > Test it like this for all of your devices:
 > root@pc7:~/ # echo bfq > /sys/block/sdX/queue/scheduler
 > 
 > For permanent add a file config to your /etc/sysctl.d.
 > EXAMPLE, edit it to your requirements.
 > 
 > [root@pc7 sysctl.d]# cat /etc/sysctl.d/90-sysscheduler.conf
 > #disk scheduler
 > block.sda.queue.scheduler = md-deadline
 > block.sdb.queue.scheduler = md-deadline
 > block.sdg.queue.scheduler = bfq
 > block.sdh.queue.scheduler = bfq
 > block.sdi.queue.scheduler = bfq
 > 
 > 
 > Hope this may help you.
 > It did work for me here.
 > 
 > Better Idea is to upgrade the kernel to 4.19.13 (which is a LTS Kernel)
 > 
 > mit freundlichen Gr  en
 > J rgen Sauer

Thank you so much, I would have never guessed that.

In my case the scheduler was set to deadline

    cat /sys/block/sd[a-c]/queue/scheduler
    noop [deadline] cfq
    noop [deadline] cfq
    noop [deadline] cfq

I have set it to cfq, I did not see an option for bfq.

I am also building 4.19.13 and will swap that in ASAP.

Thanks again,

Cheers,

sb. Scott Blomquist
