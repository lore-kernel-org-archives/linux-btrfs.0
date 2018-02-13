Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37860 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933278AbeBMDAP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 22:00:15 -0500
Subject: Re: [PATCH] btrfs: use set functions to update latest refs to the SB
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180212153749.19705-1-anand.jain@oracle.com>
 <20180212163443.GI3003@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <de4979e1-f282-2017-3559-ce55adfc49e8@oracle.com>
Date: Tue, 13 Feb 2018 10:56:39 +0800
MIME-Version: 1.0
In-Reply-To: <20180212163443.GI3003@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/13/2018 12:34 AM, David Sterba wrote:
> On Mon, Feb 12, 2018 at 11:37:49PM +0800, Anand Jain wrote:
>> We have btrfs_set_super...() to set the various values, so just use it.
> 
> Sorry but this is not "just use it", as it fixes an endianness bug and
> should be documented in the changelog. And there are probably more
> instances of the bug while accessing fs_info::super or
> fs_info::super_copy directly.

Will fix. Also checked rest of the code for similar misses in
reading/writing of fs_info::super_copy and fs_info::super_for_commit
values, but didn't find any further or did I miss something ?

Sent V2. With new title:
btrfs: fix endianness compatibility during the SB RW

Thanks, Anand
