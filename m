Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38862 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932612AbeBUR46 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Feb 2018 12:56:58 -0500
Subject: Re: BUG: unable to handle kernel paging request at ffff9fb75f827100
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1519186148.24817.1.camel@scientia.net>
 <478320b9-1972-2615-2e91-adc3d3f5112b@suse.com>
 <1519222829.4313.10.camel@scientia.net>
 <678817B2-D758-466B-A41D-FF8AFD0692AA@scientia.net>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <4ff967fe-a5b9-b3c0-a8b4-230aaf0bd225@suse.com>
Date: Wed, 21 Feb 2018 19:56:55 +0200
MIME-Version: 1.0
In-Reply-To: <678817B2-D758-466B-A41D-FF8AFD0692AA@scientia.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 21.02.2018 19:18, Christoph Anton Mitterer wrote:
>  e8f1bc1493855e32b7a2a019decc3c353d94daf6 
> 
> That bug... When was that introduced and how can I find out whether an fs was affected/corrupted by this?  Cause I've mounted and wrote to some extremely important (to me) fs recently.

The bug that this patch solves is unlikely to lead to fs-wide corruption
or indeed, any corruption at all. At mostit might make you deref a null
pointer and cause a crash - the first thing you reported. The follow up
reports don't really correspond to it.

The bug was introduced in 4.7 kernel (as evident from the stable tag on
the patch)

> 
> Thanks, Chris.
> 
