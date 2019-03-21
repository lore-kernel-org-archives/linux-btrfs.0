Return-Path: <SRS0=tkEE=RY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42F68C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 16:53:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10B6D2183E
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 16:53:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbfCUQxF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Mar 2019 12:53:05 -0400
Received: from bang.steev.me.uk ([81.2.120.65]:46933 "EHLO smtp.steev.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727138AbfCUQxE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Mar 2019 12:53:04 -0400
X-Greylist: delayed 1597 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Mar 2019 12:53:03 EDT
Received: from localhost ([::1] helo=webmail.steev.me.uk)
        by smtp.steev.me.uk with esmtp (Exim 4.91)
        id 1h70WO-0001Zq-CG; Thu, 21 Mar 2019 16:26:24 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 21 Mar 2019 16:26:24 +0000
From:   Steven Davies <btrfs-list@steev.me.uk>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC 0/5] readmirror feature
In-Reply-To: <1552989624-29577-1-git-send-email-anand.jain@oracle.com>
References: <1552989624-29577-1-git-send-email-anand.jain@oracle.com>
Message-ID: <d7b84e2bcb9920d011e585391b70020e@steev.me.uk>
X-Sender: btrfs-list@steev.me.uk
User-Agent: Roundcube Webmail/1.3.8
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-03-19 10:00, Anand Jain wrote:
> RFC patch as of now, appreciate your comments. This patch set has
> been tested.
> 
> Function call chain  __btrfs_map_block()->find_live_mirror() uses
> thread pid to determine the %mirror_num when the mirror_num=0.
> 
> The pid based mirror_num extrapolation has following disadvantages
>  . A large single-process read IO will read only from one disk.
>  . In a worst scenario all processes read accessing the FS could have
>        either odd or even pid, the read IO gets skewed.
>  . There is no deterministic way of knowing/controlling which copy will
>        be used for reading.
>  . May see performance variations for a given set of multi process
>        workload ran at different times.
> 
> So we need other types of readmirror policies.
> 
> This patch introduces a framework so that we can add more policies, and
> converts the existing %pid into as a configurable parameter using the
> property. And also provides a transient readmirror mount option, so 
> that
> this property can be applied for the read io during mount and for
> readonly FS.

Is it possible to set this property at mkfs time?

>  For example:
>    btrfs property set <mnt> readmirror pid
>    btrfs property set <mnt> readmirror ""
>    btrfs property set <mnt> readmirror devid<n>
> 
>    mount -o readmirror=pid <mnt>
>    mount -o readmirror=devid<n> <mnt>

This is an edge case but should we be allowed to set more than one 
device as a read mirror in a 3+ device array? In theory there could be 
two fast disks and one slow disk where all stripes are guaranteed to be 
on at least one fast disk.

I'll test these patches out when I have some spare time over the next 
few weeks. Do you have a tree I can pull / what are the patches based 
on?

Way beyond this patch series, considering a 3+ device raid1 array with 
mixed fast and slow disks perhaps there could also be a write preference 
for disks to fill up the fast disks first.

Steven Davies
