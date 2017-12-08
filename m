Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55468 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752500AbdLHK0p (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Dec 2017 05:26:45 -0500
From: Anand Jain <anand.jain@oracle.com>
Subject: [Question] Two variants of SB reads can we move into bio read instead
 ?
To: David Sterba <dsterba@suse.cz>, linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <d9c5e650-5aaa-96e7-f6ff-653794c89f87@oracle.com>
Date: Fri, 8 Dec 2017 18:27:10 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


David,

  There are two variants of SB read, one using the device cache [1]
  and the other buffer head [2].

  [1] btrfs_read_disk_super()
  [2] btrfs_read_dev_super()

  Patch, 6f60cbd3ae442cb35861bb522f388db123d42ec1
   (btrfs: access superblock via pagecache in scan_one_device)
  Embraced device caches to avoid blocksize set and thus avoid device
  drop cache. But however its in the context of starting up with a new
  mount and in practice, would it really matter if the device cache is
  dropped in the context of mount, we any way drop it when the device
  is successfully mounted though. I don't understand the actual problem
  here.

  Further [2] is still using buffer head, which works very well for us
  in this context, any idea if there is any suggestion to move it to
  newer bio read instead ?

Thanks, Anand
