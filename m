Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31913 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751831AbdFMIGZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 04:06:25 -0400
Subject: Re: [PATCH] btrfs: use ino_t for inode in tracer
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <1497262228-729-1-git-send-email-anand.jain@oracle.com>
 <20170613064151.GA17424@infradead.org>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <8c7e2250-aa58-2da6-a09c-38f470cdc31c@oracle.com>
Date: Tue, 13 Jun 2017 16:12:10 +0800
MIME-Version: 1.0
In-Reply-To: <20170613064151.GA17424@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/13/2017 02:41 PM, Christoph Hellwig wrote:
> I thought btrfs supports 64-bit inodes, in which case this will
> truncate the inode number on 32-bit architectures.

  Good catch. Thanks !

  Will send the updated patch.

Thanks, Anand
