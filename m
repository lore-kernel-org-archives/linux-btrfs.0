Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28055 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751786AbdFGJQI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2017 05:16:08 -0400
Subject: Re: [PATCH 8/8] btrfs: pass bytes to btrfs_bio_alloc
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1496422340.git.dsterba@suse.com>
 <30426258414b98794cb7de68df1440a75b868e56.1496422340.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <7e16d8da-0362-2b9f-1090-c28d2e940248@oracle.com>
Date: Wed, 7 Jun 2017 17:22:06 +0800
MIME-Version: 1.0
In-Reply-To: <30426258414b98794cb7de68df1440a75b868e56.1496422340.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/03/17 00:58, David Sterba wrote:
> Most callers of btrfs_bio_alloc convert from bytes to sectors. Hide that
> in the helper and simplify the logic in the callsers.

Reviewed-by: Anand Jain <anand.jain@oracle.com>

