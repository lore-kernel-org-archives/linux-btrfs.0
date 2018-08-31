Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:40798 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727432AbeHaSUG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 14:20:06 -0400
Received: by mail-qt0-f195.google.com with SMTP id h4-v6so14657864qtj.7
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 07:12:25 -0700 (PDT)
Date: Fri, 31 Aug 2018 10:12:23 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 15/35] btrfs: run delayed iputs before committing
Message-ID: <20180831141222.bobdq4qlxth7eow2@destiny>
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-16-josef@toxicpanda.com>
 <31a5f6cf-f69f-e624-04d5-124e90fe02a4@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <31a5f6cf-f69f-e624-04d5-124e90fe02a4@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 31, 2018 at 10:55:22AM +0300, Nikolay Borisov wrote:
> 
> 
> On 30.08.2018 20:42, Josef Bacik wrote:
> > We want to have a complete picture of any delayed inode updates before
> > we make the decision to commit or not, so make sure we run delayed iputs
> > before making the decision to commit or not.
> 
> Again, there was request for more detail which is not addressed:
> 
> https://www.spinics.net/lists/linux-btrfs/msg81237.html

I'll make the changelog more explicit, thanks,

Josef
