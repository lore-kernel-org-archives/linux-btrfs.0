Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:50640 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab3ARWBl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jan 2013 17:01:41 -0500
Received: by mail-ob0-f182.google.com with SMTP id 16so4186934obc.27
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Jan 2013 14:01:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130118121916.GI22785@twin.jikos.cz>
References: <1358339768-2314-1-git-send-email-bo.li.liu@oracle.com>
	<CAKcLGm8QDNEs3nF=VDGtRWVV9MNg9SZr0ZBH1fiqTRgJyJgOvg@mail.gmail.com>
	<20130118121916.GI22785@twin.jikos.cz>
Date: Fri, 18 Jan 2013 16:01:40 -0600
Message-ID: <CAKcLGm_Sh+xpOQdancJJ4MQO4g_b7JZJxXz1+POXEQsrQ7fyEg@mail.gmail.com>
Subject: Re: [PATCH V5] Btrfs: snapshot-aware defrag
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: dsterba@suse.cz
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org,
        chris.mason@fusionio.com, JBacik@fusionio.com, kitayama@cl.bb4u.ne.jp,
        miaox@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 18, 2013 at 6:19 AM, David Sterba <dsterba@suse.cz> wrote:
> On Thu, Jan 17, 2013 at 08:42:46AM -0600, Mitch Harder wrote:
>> [16028.160002] RAX: dead000000200200 RBX: ffff880000000000 RCX: 0000000000018e20
>> [16028.160002] RDX: dead000000100100 RSI: 000000000000001b RDI: 000000000000001b
>
> RAX: dead000000200200
> RDX: dead000000100100
>
> list_head poisons to mark deleted entries
>
>> I've tried to trap the error with a BUG_ON prior to deleting the list,
>> but my attempt isn't catching the error:
>>
>> @@ -1769,6 +1769,7 @@ int btrfs_clean_old_snapshots(struct btrfs_root *root)
>>                 int ret;
>>
>>                 root = list_entry(list.next, struct btrfs_root, root_list);
>> +               BUG_ON(&root->root_list == NULL);
>
> You're taking an address and comparing it to NULL? This works, but in
> under very limited conditions :)
>
> If root is not null, then the structure is valid, but the root_list hook
> is not valid anymore, ie. an inconsistency.

Thanks, your feedback is kind.

I wasn't thinking when I wrote that.
