Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47642 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab2GAKiD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Jul 2012 06:38:03 -0400
Received: by dady13 with SMTP id y13so6220822dad.19
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Jul 2012 03:38:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FF02397.3040002@oracle.com>
References: <CAEH94Lht_TcBFa1qvO1-pz12GsdfH05xnYMC-smKLOFPP2HydA@mail.gmail.com>
	<CAMU1PDgEokfvoCREVwB9O4Mm0Po=9UdFau3W2D0nZhhf2oWNsw@mail.gmail.com>
	<CAEH94LhNWsye0HsDjroeRQ76vLkmKSUwYwzGKjfbJCeO-wLEuw@mail.gmail.com>
	<4FF02397.3040002@oracle.com>
Date: Sun, 1 Jul 2012 18:38:03 +0800
Message-ID: <CAEH94LiiRF3UGrPf27forZFJFaSKZCJwt1orGZe2sXcxnkJ+kw@mail.gmail.com>
Subject: Re: btrfs_print_tree?
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: jeff.liu@oracle.com
Cc: Mike Fleetwood <mike.fleetwood@googlemail.com>,
        linux-btrfs@vger.kernel.org, philipp.andreas@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 1, 2012 at 6:16 PM, Jeff Liu <jeff.liu@oracle.com> wrote:
> On 07/01/2012 05:49 PM, Zhi Yong Wu wrote:
>
>> On Sun, Jul 1, 2012 at 5:41 PM, Mike Fleetwood
>> <mike.fleetwood@googlemail.com> wrote:
>>> On 1 July 2012 05:53, Zhi Yong Wu <zwu.kernel@gmail.com> wrote:
>>>> HI,
>>>>
>>>> Do anyone know where btrfs_print_tree is invoked? thanks.
>>>>
>>>> --
>>>> Regards,
>>>>
>>>> Zhi Yong Wu
>>>
>>> Is this the answer you are after?
>>>
>>> $ grep -r btrfs_print_tree fs/btrfs/
>>> fs/btrfs/print-tree.c:void btrfs_print_tree(struct btrfs_root *root,
>>> struct extent_buffer *c)
>>> fs/btrfs/print-tree.c:          btrfs_print_tree(root, next);
>>> fs/btrfs/print-tree.h:void btrfs_print_tree(struct btrfs_root *root,
>>> struct extent_buffer *t);
>> No, i also did as this, but didn't find out who will invoke this
>> function. From above output, we only saw that it invokes itself one
>> time.
>
> Looks this is a helper routine exported to btrfs-progs previously, it is
> used by debug-tree, quick-test, etc...
>
> But this function has been implemented at btrfs-progs now, maybe it
> could be safely removed from kernel, not sure. :)
Great, thanks both.
>
> Thanks,
> -Jeff
>
>>
>>>
>>> Mike
>>
>>
>>
>
>



-- 
Regards,

Zhi Yong Wu
