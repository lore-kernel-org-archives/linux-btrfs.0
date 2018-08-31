Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:43431 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727582AbeHaSKm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 14:10:42 -0400
Received: by mail-qt0-f195.google.com with SMTP id g53-v6so14585356qtg.10
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 07:03:04 -0700 (PDT)
Date: Fri, 31 Aug 2018 10:03:00 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 22/35] btrfs: make sure we create all new bgs
Message-ID: <20180831140259.dwvyvskb3xg2ubku@destiny>
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-23-josef@toxicpanda.com>
 <a433a3b0-dbe1-da97-2d30-1e3ab85e9ec0@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a433a3b0-dbe1-da97-2d30-1e3ab85e9ec0@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 31, 2018 at 10:31:49AM +0300, Nikolay Borisov wrote:
> 
> 
> On 30.08.2018 20:42, Josef Bacik wrote:
> > We can actually allocate new chunks while we're creating our bg's, so
> > instead of doing list_for_each_safe, just do while (!list_empty()) so we
> > make sure to catch any new bg's that get added to the list.
> 
> HOw can this occur, please elaborate and put an example callstack in the
> commit log.
> 

Eh?  We're modifying the extent tree and chunk tree, which can cause bg's to be
allocated, it's just common sense.

Josef
