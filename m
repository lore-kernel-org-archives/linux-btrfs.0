Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56788 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbeHBL46 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Aug 2018 07:56:58 -0400
Subject: Re: [PATCH v2 4/4] btrfs: add helper btrfs_num_devices() to deduce
 num_devices
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180726065334.30594-1-anand.jain@oracle.com>
 <20180726065334.30594-5-anand.jain@oracle.com>
 <20180801144107.GI3218@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <e821b772-56b3-2a58-d499-77e4f4d610da@oracle.com>
Date: Thu, 2 Aug 2018 18:09:55 +0800
MIME-Version: 1.0
In-Reply-To: <20180801144107.GI3218@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/01/2018 10:41 PM, David Sterba wrote:
> On Thu, Jul 26, 2018 at 02:53:34PM +0800, Anand Jain wrote:
>> When the replace is running the fs_devices::num_devices also includes
>> the replace device, however in some operations like device delete and
>> balance it needs the actual num_devices without the repalce devices, so
>> now the function btrfs_num_devices() just provides that.
> 
> The part how concurrent balance and dev-replace can be active at the
> same time is missing. As this is not obvious, it's desired to have that
> in the changelog.

  Will do.

> If there are questions and comments in past patchset revisions, that's a
> good material for changelogs and when you send an update you can enhance
> the changelogs. I do simple fixups or additions but when you send a new
> revision it the right time to save time on both sides.

  Thanks for mentioning it.

-Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
