Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:33859 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754070AbdHURb6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 13:31:58 -0400
Received: by mail-qt0-f196.google.com with SMTP id p13so2836203qtp.1
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 10:31:58 -0700 (PDT)
Date: Mon, 21 Aug 2017 13:31:56 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, bo.li.liu@oracle.com
Subject: Re: [PATCH v2] btrfs: submit superblock io with REQ_META and REQ_PRIO
Message-ID: <20170821173155.GC23807@destiny>
References: <20170821154227.13644-1-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170821154227.13644-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 21, 2017 at 05:42:27PM +0200, David Sterba wrote:
> The superblock is also metadata of the filesystem so the relevant IO
> should be tagged as such. We also tag it as high priority, as it's the
> last block committed for metadata from a given transaction. Any delays
> would effectively block the whole transaction, also blocking any other
> operation holding the device_list_mutex.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
