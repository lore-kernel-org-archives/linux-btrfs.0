Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23381 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751613AbdFGJGr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2017 05:06:47 -0400
Subject: Re: [PATCH 5/8] btrfs: sink gfp parameter to btrfs_bio_clone
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1496422340.git.dsterba@suse.com>
 <383a5b09762c5ff16c9a68521184009fa95a87fc.1496422340.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <c8ce2ef9-519b-7926-ceb5-2c7a6b24d753@oracle.com>
Date: Wed, 7 Jun 2017 17:12:05 +0800
MIME-Version: 1.0
In-Reply-To: <383a5b09762c5ff16c9a68521184009fa95a87fc.1496422340.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/03/17 00:58, David Sterba wrote:
> All callers pass GFP_NOFS.

Reviewed-by: Anand Jain <anand.jain@oracle.com>
