Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18830 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932652AbdKFX74 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Nov 2017 18:59:56 -0500
Subject: Re: [PATCH 5/7] btrfs: btrfs_rm_device() does not need uuid_mutex
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20171106083618.7617-1-anand.jain@oracle.com>
 <20171106083618.7617-6-anand.jain@oracle.com>
 <20171106170214.GS28789@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <e4893d46-4f25-495e-e1d1-ac9920442957@oracle.com>
Date: Tue, 7 Nov 2017 07:59:54 +0800
MIME-Version: 1.0
In-Reply-To: <20171106170214.GS28789@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/07/2017 01:02 AM, David Sterba wrote:
> On Mon, Nov 06, 2017 at 04:36:16PM +0800, Anand Jain wrote:
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> No changelog at all?

  Oh. This patch is wrong. I thought I deleted this from my workspace.
  Now I notice this ended up in the ML.

  We need to uuid_mutex for the case of removing a seed device where
  the fsids are different.

Thanks, Anand
