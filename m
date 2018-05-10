Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f47.google.com ([209.85.160.47]:46692 "EHLO
        mail-pl0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752578AbeEJVom (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 17:44:42 -0400
Received: by mail-pl0-f47.google.com with SMTP id 59-v6so2035857plc.13
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 14:44:41 -0700 (PDT)
Date: Thu, 10 May 2018 14:44:39 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 06/10] Btrfs: don't return ino if inode item removal fails
Message-ID: <20180510214439.GC820@vader>
References: <cover.1525932796.git.osandov@fb.com>
 <62232de691b62b5eaf6f6b4912848e1e7bf65ebd.1525932796.git.osandov@fb.com>
 <995eb7ab-aa58-63ea-61d8-2fbcbbe767ac@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <995eb7ab-aa58-63ea-61d8-2fbcbbe767ac@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 10, 2018 at 11:29:18AM +0300, Nikolay Borisov wrote:
> 
> 
> On 10.05.2018 09:21, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > In btrfs_evict_inode(), if btrfs_truncate_inode_items() fails, the inode
> > item will still be in the tree but we still return the ino to the ino
> > cache. That will blow up later when someone tries to allocate that ino,
> > so don't return it to the cache.
> 
> Make the subject a bit more expicit:
> 
> "Don't return ino to ino cache if inode item removal fails"

Good point, updated. Thanks!
