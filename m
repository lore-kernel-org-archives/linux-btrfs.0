Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:50130 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751742AbeCVMMZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 08:12:25 -0400
Subject: Re: [PATCH] btrfs-progs: wipe all copies of the stale superblock
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180321101920.9004-1-anand.jain@oracle.com>
 <e16124c3-7f57-6a2f-f760-5164f7c10ad1@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <d2fbba43-dff3-3909-a794-69c4a8ed4ace@oracle.com>
Date: Thu, 22 Mar 2018 20:14:12 +0800
MIME-Version: 1.0
In-Reply-To: <e16124c3-7f57-6a2f-f760-5164f7c10ad1@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  Ok. Will update the change log.

> A better place for this code is really inside btrfs_wipe_existing_sb.
> Furthermore looking at libblkid it supports a way to wipe multiple
> superblocks by way of: blkid_do_wipe. I.e
> https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.21/libblkid-docs/libblkid-Low-level-tags.html#blkid-do-wipe
> 
> Apparently this functionality has been in libblkid for quite some time
> according to this blog post -
> http://karelzak.blogspot.bg/2011/11/wipefs8-improvements.html (Karel Zak
> is the person mainting various system libraries).
> 
> So can't we at the very least:
> 
> 1) Remove some of our (open coded) implementation of
> btrfs_wipe_existing_sb and use the generic blkid implementation.
> 
> 2) Incorporate your code into btrfs_wipe_existing_sb OR extend the usage
> of the generic blkid_do_wipe to wipe multiple copies of the sb ?

  In btrfs_prepare_device() we have already zeroed the SBs which were
  within the block count. The btrfs_wipe_existing_sb() is to handle the
  other type of FS SBs. Definitely, we can consolidate all this into a
  single function using libblkid. However, it can be done in a separate
  patch.

Thanks, Anand
