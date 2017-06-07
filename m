Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22346 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750739AbdFGJFC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2017 05:05:02 -0400
Subject: Re: [PATCH 2/8] btrfs: btrfs_bio_alloc never fails, skip error
 handling
To: linux-btrfs@vger.kernel.org
References: <cover.1496422340.git.dsterba@suse.com>
 <a77256a3af2055537dc0eb7b15995fc673a4c0cc.1496422340.git.dsterba@suse.com>
Cc: David Sterba <dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <c3d2deae-45b3-f2e5-97e1-3d79a1aa8efb@oracle.com>
Date: Wed, 7 Jun 2017 17:11:08 +0800
MIME-Version: 1.0
In-Reply-To: <a77256a3af2055537dc0eb7b15995fc673a4c0cc.1496422340.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/03/17 00:58, David Sterba wrote:
> Update direct callers of btrfs_bio_alloc that do error handling, that we
> can now remove.

Reviewed-by: Anand Jain <anand.jain@oracle.com>
