Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23241 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750739AbdFGJG1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2017 05:06:27 -0400
Subject: Re: [PATCH 3/8] btrfs: btrfs_bio_clone never fails, skip error
 handling
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1496422340.git.dsterba@suse.com>
 <aa834758a79dc983410da678aac76d039b4cfdc2.1496422340.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <9f796419-244d-491f-4d24-69b32593854c@oracle.com>
Date: Wed, 7 Jun 2017 17:11:32 +0800
MIME-Version: 1.0
In-Reply-To: <aa834758a79dc983410da678aac76d039b4cfdc2.1496422340.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/03/17 00:58, David Sterba wrote:
> Update direct callers of btrfs_bio_clone that do error handling, that we
> can now remove.

Reviewed-by: Anand Jain <anand.jain@oracle.com>
