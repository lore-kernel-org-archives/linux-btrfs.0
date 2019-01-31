Return-Path: <SRS0=M3t6=QH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB9E1C169C4
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 13:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9229620821
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 13:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732647AbfAaNIn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 31 Jan 2019 08:08:43 -0500
Received: from bang.steev.me.uk ([81.2.120.65]:51971 "EHLO smtp.steev.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727202AbfAaNIn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Jan 2019 08:08:43 -0500
Received: from localhost ([::1] helo=webmail.steev.me.uk)
        by smtp.steev.me.uk with esmtp (Exim 4.91)
        id 1gpC5B-0005bN-FO; Thu, 31 Jan 2019 13:08:41 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 31 Jan 2019 13:08:41 +0000
From:   Steven Davies <btrfs-list@steev.me.uk>
To:     Ronald Schaten <ronald@schatenseite.de>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: File alteration events?
In-Reply-To: <20190131123832.yqhp4fqavv6xjdif@shell.intra.scheunentor.de>
References: <20190131123832.yqhp4fqavv6xjdif@shell.intra.scheunentor.de>
Message-ID: <b4edb2f4c2fda608833ea4600c6ea258@steev.me.uk>
X-Sender: btrfs-list@steev.me.uk
User-Agent: Roundcube Webmail/1.3.8
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-01-31 12:38, Ronald Schaten wrote:
> Hello everybody...

> I'm looking for a solution to track file changes on a fairly large
> filesystem. Many thousands of directories, millions of files.
> 
> The volume is shared to other computers, changes can come from 
> different
> sources (NFS, Samba, local access...). So I think the kernel or the
> filesystem itself are the definitive source of information.
> 
> Does BTRFS have any mechanism that could be used to track every event?
> Or do you happen to know if the kernel does?
> 
> 
> What I tried till now:
> 
> - inotify: Doesn't work for a full volume, just for single inodes.
> 
> - fanotify: That's almost the solution, but I need to see rename and
>   delete events, too.
> 
> - btrfs subvolume find-new: As far as I know that only finds changes
>   between snapshots. I need something a little more real-timey, and I
>   have to know if the file has been changed once or several times.
> 
> 
> As I said: I'm thankful for any hint... thanks in advance!

As far as I know btrfs doesn't have any hooks you could use for that, 
but perhaps have a look at a utility called inotifywait instead.

-- 
Steve
