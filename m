Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:62852 "EHLO
        mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751395AbeCWIOW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Mar 2018 04:14:22 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 1BE04AC0142
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 17:14:16 +0900 (JST)
Subject: Re: [PATCH] btrfs-progs: mkfs: add uuid and otime to ROOT_ITEM of
 FS_TREE
To: <dsterba@suse.cz>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <7ca269db-a724-5938-f4d8-b85e893fd558@jp.fujitsu.com>
 <20180321174838.GW6955@twin.jikos.cz>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <dd301297-d716-3614-4e83-22f3da78ef06@jp.fujitsu.com>
Date: Fri, 23 Mar 2018 17:14:10 +0900
MIME-Version: 1.0
In-Reply-To: <20180321174838.GW6955@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/03/22 2:48, David Sterba wrote:
> On Mon, Mar 19, 2018 at 05:16:42PM +0900, Misono, Tomohiro wrote:
>> Currently, the top-level subvolume lacks the UUID. As a result, both
>> non-snapshot subvolume and snapshot of top-level subvolume do not have
>> Parent UUID and cannot be distinguisued. Therefore "fi show" of
>> top-level lists all the subvolumes which lacks the UUID in
>> "Snapshot(s)" filed.  Also, it lacks the otime information.
>>
>> Fix this by adding the UUID and otime at the mkfs time.  As a
>> consequence, snapshots of top-level subvolume now have a Parent UUID and
>> UUID tree will create an entry for top-level subvolume at mount time.
>> This should not cause the problem for current kernel, but user program
>> which relies on the empty Parent UUID may be affected by this change.
>>
>> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> 
> So this adds uuid, ctime and otime to FS_TEEE but also to UUID_TREE and
> DATA_RELOC_TREE. This is harmelss, but would be nice to mention in the
> changelog, I'll apply the patch add that. Thanks.

UUID is cleared at create_tree(), so I think you mean otime and ctime.
However, other tree's ROOT_ITEM does not hold o/ctime and I'd like to
clear o/ctime for UUID/DATA_RELOC_TREE too.

So, I will send v2 patch and could you please use that instead of this?

Regards,
Tomohiro Misono

