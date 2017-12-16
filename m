Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59146 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755970AbdLPCPz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Dec 2017 21:15:55 -0500
Subject: Re: [PATCH 1/6] btrfs: cleanup btrfs_free_stale_device() usage
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20171215034739.26090-1-anand.jain@oracle.com>
 <20171215034739.26090-2-anand.jain@oracle.com>
 <fb2e920c-ea90-6ebd-e4a5-c1332cd88688@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <91e02fbe-cd16-cea6-2195-69c230dfb927@oracle.com>
Date: Sat, 16 Dec 2017 10:15:58 +0800
MIME-Version: 1.0
In-Reply-To: <fb2e920c-ea90-6ebd-e4a5-c1332cd88688@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>> @@ -788,6 +788,7 @@ static noinline int device_list_add(const char *path,
> 
> nit: not directly related to the series in question, but I think you can
> add one more patch which sinks the devid argument passed to
> device_list_add. We already pass the disk_super and we can get the devid
> in device_list_add this reduced the cognitive load when reading the code

  I notice that too, yes it should be in a new patch. More cleanups
  around this is coming up.

Thanks, Anand
