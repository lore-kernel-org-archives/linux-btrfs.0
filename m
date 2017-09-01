Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:34182 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751777AbdIAMi2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Sep 2017 08:38:28 -0400
Received: by mail-qk0-f182.google.com with SMTP id a77so437113qkb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Sep 2017 05:38:27 -0700 (PDT)
Date: Fri, 1 Sep 2017 08:38:26 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Naohiro Aota <naohiro.aota@wdc.com>
Cc: linux-btrfs@vger.kernel.org, fdmanana@suse.com, clm@fb.com,
        dsterba@suse.com, jbacik@fb.com, quwenruo.btrfs@gmx.com
Subject: Re: [PATCH 2/2] btrfs: finish ordered extent cleaning if no progress
 is found
Message-ID: <20170901123824.fcnopokccdxuvb3r@destiny>
References: <150425632766.4737.133868215044509089.stgit@naota.dhcp.fujisawa.hgst.com>
 <150425634736.4737.8343712690392096633.stgit@naota.dhcp.fujisawa.hgst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <150425634736.4737.8343712690392096633.stgit@naota.dhcp.fujisawa.hgst.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 01, 2017 at 05:59:07PM +0900, Naohiro Aota wrote:
> __endio_write_update_ordered() repeats the search until it reaches the end
> of the specified range. This works well with direct IO path, because before
> the function is called, it's ensured that there are ordered extents filling
> whole the range. It's not the case, however, when it's called from
> run_delalloc_range(): it is possible to have error in the midle of the loop
> in e.g. run_delalloc_nocow(), so that there exisits the range not covered
> by any ordered extents. By cleaning such "uncomplete" range,
> __endio_write_update_ordered() stucks at offset where there're no ordered
> extents.
> 
> Since the ordered extents are created from head to tail, we can stop the
> search if there are no offset progress.
> 

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
