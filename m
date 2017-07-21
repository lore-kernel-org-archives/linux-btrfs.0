Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:35139 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751504AbdGUTKc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 15:10:32 -0400
Received: by mail-qk0-f193.google.com with SMTP id f67so1028029qkc.2
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Jul 2017 12:10:31 -0700 (PDT)
Date: Fri, 21 Jul 2017 15:10:29 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: josef@toxicpanda.com
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 2/3] btrfs: fix readdir deadlock with pagefault
Message-ID: <20170721191028.GA17477@destiny>
References: <1500658149-20410-1-git-send-email-jbacik@fb.com>
 <1500658149-20410-2-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1500658149-20410-2-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 21, 2017 at 01:29:08PM -0400, josef@toxicpanda.com wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> Readdir does dir_emit while under the btree lock.  dir_emit can trigger
> the page fault which means we can deadlock.  Fix this by allocating a
> buffer on opening a directory and copying the readdir into this buffer
> and doing dir_emit from outside of the tree lock.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

This is broken, don't anybody actually run this, I'm more interested in comments
on the overall solution.  I'll get it working and post a V2 after a few days if
nobody has objections to the approach as a whole.  Thanks,

Josef
