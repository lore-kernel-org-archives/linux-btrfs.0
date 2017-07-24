Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:37612 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753462AbdGXN7Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 09:59:24 -0400
Received: by mail-qk0-f195.google.com with SMTP id q130so9965089qka.4
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jul 2017 06:59:24 -0700 (PDT)
Date: Mon, 24 Jul 2017 09:59:22 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: josef@toxicpanda.com, linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 2/3] btrfs: fix readdir deadlock with pagefault
Message-ID: <20170724135921.GA9406@destiny>
References: <1500658149-20410-1-git-send-email-jbacik@fb.com>
 <1500658149-20410-2-git-send-email-jbacik@fb.com>
 <c5af1dee-4899-80ff-066f-6450eca375b9@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c5af1dee-4899-80ff-066f-6450eca375b9@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 24, 2017 at 11:26:49AM +0300, Nikolay Borisov wrote:
> 
> 
> On 21.07.2017 20:29, josef@toxicpanda.com wrote:
> > From: Josef Bacik <jbacik@fb.com>
> > 
> > Readdir does dir_emit while under the btree lock.  dir_emit can trigger
> > the page fault which means we can deadlock.  Fix this by allocating a
> > buffer on opening a directory and copying the readdir into this buffer
> > and doing dir_emit from outside of the tree lock.
> 
> So dir_emit essentially calls filldir which can fault on the user
> provided addresses. How could a fault there recurse back to the filesystem?
> 

Thread A
readdir  <holding tree lock>
  dir_emit
    <page fault>
      down_read(mmap_sem)

Thread B
mmap write
  down_write(mmap_sem)
    page_mkwrite
      wait_ordered_extents

Process C
finish_ordered_extent
  insert_reserved_file_extent
   try to lock leaf <hang>

Thanks,

Josef
