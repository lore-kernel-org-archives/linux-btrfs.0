Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:36029 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751288AbdFVPIw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Jun 2017 11:08:52 -0400
Received: by mail-qk0-f182.google.com with SMTP id p21so14478830qke.3
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Jun 2017 08:08:51 -0700 (PDT)
Date: Thu, 22 Jun 2017 11:08:49 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: tj@kernel.org, jbacik@fb.com, jack@suse.cz, jeffm@suse.com,
        chandan@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org, axboe@kernel.dk
Subject: Re: [RFC PATCH 0/4] Support for metadata specific accounting
Message-ID: <20170622150848.GA932@destiny>
References: <1498141404-18807-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1498141404-18807-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 22, 2017 at 05:23:20PM +0300, Nikolay Borisov wrote:
> Hello, 
> 
> This series is a report of Josef's original posting [1]. I've included 
> fine-grained changelog in each patch with my changes. Basically, I've forward
> ported it to 4.12-rc6 and tried incorporating the feedback which was given to 
> every individual patch (I've included link with that information in each 
> individual patch). 
> 
> The main rationale of pushing this is to enable btrfs' subpage-blocksizes
> patches to eventually be merged.
> 
> This patchset depends on patches (in listed order) which have already
> been submitted [2] [3] [4]. But overall they don't hamper review. 
> 

Hello,

I haven't reposted these patches because they depend on the other work I'm
doing wrt slab shrinking.  We can't do the sub page blocksize stuff until those
patches are in, and then I have to re-evaluate this stuff to make sure it still
makes sense.  Thanks,

Josef
