Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30886 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753752AbdATBIx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jan 2017 20:08:53 -0500
Subject: Re: btrfs recovery
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        <linux-btrfs@vger.kernel.org>
References: <7473ea27-9716-33fb-ecec-2ec52fac3820@dd-wrt.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <70489b24-1f36-d4b6-7bbe-63a39a7425d0@cn.fujitsu.com>
Date: Fri, 20 Jan 2017 09:08:43 +0800
MIME-Version: 1.0
In-Reply-To: <7473ea27-9716-33fb-ecec-2ec52fac3820@dd-wrt.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 01/19/2017 06:06 PM, Sebastian Gottschall wrote:
> Hello
>
> I have a question. after a power outage my system was turning into a
> unrecoverable state using btrfs (kernel 4.9)
> since im running --init-extent-tree now for 3 days i'm asking how long
> this process normally takes and why it outputs millions of lines like

--init-extent-tree will trash *ALL* current extent tree, and *REBUILD* 
them from fs-tree.

This can takes a long time depending on the size of the fs, and how many 
shared extents there are (snapshots and reflinks all counts).

Such a huge operation should only be used if you're sure only extent 
tree is corrupted, and other tree are all OK.

Or you'll just totally screw your fs further, especially when interrupted.

>
> Backref 1562890240 root 262 owner 483059214 offset 0 num_refs 0 not
> found in extent tree
> Incorrect local backref count on 1562890240 root 262 owner 483059214
> offset 0 found 1 wanted 0 back 0x23b0211d0
> backpointer mismatch on [1562890240 4096]

This is common, since --init-extent-tree trash all extent tree, so every 
tree-block/data extent will trigger such output

> adding new data backref on 1562890240 root 262 owner 483059214 offset 0
> found 1
> Repaired extent references for 1562890240

But as you see, it repaired the extent tree by adding back 
EXTENT_ITEM/METADATA_ITEM into extent tree, so far it works.

If you see such output with all the same bytenr, then things goes really 
wrong and maybe a dead loop.


Personally speaking, normal problem like failed to mount should not need 
--init-extent-tree.

Especially, extent-tree corruption normally is not really related to 
mount failure, but sudden remount to RO and kernel wanring.

Thanks,
Qu

>
> please avoid typical answers like "potential dangerous operation" since
> all repair options are declared as potenial dangerous.
>
>
> Sebastian
>


