Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58692 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751955AbeFSWgU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 18:36:20 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E40A9AD2A
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jun 2018 22:36:18 +0000 (UTC)
Subject: Re: [PATCH 1/3] btrfs: Remove fs_info argument from
 __btrfs_inc_extent_ref
To: Jeff Mahoney <jeffm@suse.com>, linux-btrfs@vger.kernel.org
References: <1529323166-29931-1-git-send-email-nborisov@suse.com>
 <1529323166-29931-2-git-send-email-nborisov@suse.com>
 <cad42e02-c494-a10e-5e12-f21cd209579c@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <9d325596-3c03-c5f5-4e6c-75898e5ef9b4@suse.com>
Date: Wed, 20 Jun 2018 01:36:17 +0300
MIME-Version: 1.0
In-Reply-To: <cad42e02-c494-a10e-5e12-f21cd209579c@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.06.2018 22:31, Jeff Mahoney wrote:
> I like the idea here.  I wasn't sold at first, but I think if we can
> standardize on taking only a trans handle when one is required and both
> a trans and fs_info when it's optional, it'll make the code clearer.
> This cleanup can percolate up the stack to cover pretty much all of
> delayed refs.

I have a 25-something patches which do exactly this. Still WIP, will
likely send it tomorrow.
