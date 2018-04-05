Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:45484 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbeDEJjf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Apr 2018 05:39:35 -0400
Subject: Re: [PATCH 04/16] btrfs: move btrfs_init_dev_replace_tgtdev to
 dev-replace.c and make static
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1522780026.git.dsterba@suse.com>
 <fa1f12d13fa8ee4625c111ec0ccea87679dd0b92.1522780026.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <c9ac8333-5f86-3761-aca2-e4fdb80af58e@oracle.com>
Date: Thu, 5 Apr 2018 17:41:32 +0800
MIME-Version: 1.0
In-Reply-To: <fa1f12d13fa8ee4625c111ec0ccea87679dd0b92.1522780026.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/04/2018 02:34 AM, David Sterba wrote:
> The function logically belongs there and there's only a single caller,
> no need to export it. No code changes.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>


Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand

