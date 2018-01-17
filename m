Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47297 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752554AbeAQKzc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Jan 2018 05:55:32 -0500
Subject: Re: Timeline or roadmap to split lowmem mode and original mode check?
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
References: <521779a7-60bc-c7c9-b35d-77c5e36aaacc@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <5d120b10-8d25-9caa-5086-c417a7b8e715@suse.com>
Date: Wed, 17 Jan 2018 12:55:28 +0200
MIME-Version: 1.0
In-Reply-To: <521779a7-60bc-c7c9-b35d-77c5e36aaacc@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 17.01.2018 07:32, Qu Wenruo wrote:
> Hi David,
> 
> There is the long planned work to split the original mode and lowmem
> mode check into their own .[ch] files.
> 
> I found it harder and harder to locate repair functions for original and
> lowmem mode when writing fixes for them.
> 
> I wonder if it's a good time to start the split work, and if you're OK
> with it, my plan is to:
> 
> 1) Start the split work based on 4.14.1
> 
> 2) Split check code into:
>    check/common.[ch]	<<< Not sure how many functions will be there
>    check/lowmem.[ch]
>    check/origin.[ch]
>    check/main.c
> 
> Currently most fsck fixes and enhancement are from Fujitsu guys who I'm
> quite familiar with, so rebasing their code won't be a big problem for me.
> 
> If this works for you, I can start the work asap.

When you start working on that you might consider also documenting most
of the repair functions :)

> 
> Thanks,
> Qu
> 
