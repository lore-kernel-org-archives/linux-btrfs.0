Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43764 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751893AbdHPU0h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 16:26:37 -0400
Subject: Re: [PATCH 2/4] btrfs: convert enum btrfs_compression_type to define
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20170813040244.18841-1-anand.jain@oracle.com>
 <20170813040244.18841-3-anand.jain@oracle.com>
 <20170816135941.GE2866@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <6117a0fa-b540-c31f-af10-805fce5b7cfc@oracle.com>
Date: Thu, 17 Aug 2017 04:33:41 +0800
MIME-Version: 1.0
In-Reply-To: <20170816135941.GE2866@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/16/2017 09:59 PM, David Sterba wrote:
> On Sun, Aug 13, 2017 at 12:02:42PM +0800, Anand Jain wrote:
>> There isn't a huge list to manage the types, which can be managed
>> with defines. It helps to easily print the types in tracing as well.
> 
> We use enums in a lot of places, I'd rather keep it as it is.

  This patch converts all of them, and it was at only one place.
  I hope I didn't miss any. Further the next patch 3/4 needs it
  to be define instead of enums, handling enums in the tracing
  isn't as easy as define.

Thanks, Anand

