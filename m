Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34011 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754157AbdERKZQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 06:25:16 -0400
Subject: Re: [PATCH] btrfs: add mount umount logs
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20170516084149.10147-1-anand.jain@oracle.com>
 <20170516112332.GC4065@suse.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <f4de2abb-d459-8415-9e8f-464832913b36@oracle.com>
Date: Thu, 18 May 2017 18:31:03 +0800
MIME-Version: 1.0
In-Reply-To: <20170516112332.GC4065@suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/16/2017 07:23 PM, David Sterba wrote:
> On Tue, May 16, 2017 at 04:41:49PM +0800, Anand Jain wrote:
>> By looking at the logs we should be able to know when the FS was
>> mounted and unmounted and the options used, so to help forensic
>> investigations.
>
> Could be a useful feature, but you're adding it to the wrong layer.

  Ok proposing to be added to the vfs layer.

Thanks, Anand


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
