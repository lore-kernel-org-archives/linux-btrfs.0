Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:51087 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab2GAKRX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Jul 2012 06:17:23 -0400
Message-ID: <4FF02397.3040002@oracle.com>
Date: Sun, 01 Jul 2012 18:16:55 +0800
From: Jeff Liu <jeff.liu@oracle.com>
Reply-To: jeff.liu@oracle.com
MIME-Version: 1.0
To: Zhi Yong Wu <zwu.kernel@gmail.com>
CC: Mike Fleetwood <mike.fleetwood@googlemail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs_print_tree?
References: <CAEH94Lht_TcBFa1qvO1-pz12GsdfH05xnYMC-smKLOFPP2HydA@mail.gmail.com>	<CAMU1PDgEokfvoCREVwB9O4Mm0Po=9UdFau3W2D0nZhhf2oWNsw@mail.gmail.com> <CAEH94LhNWsye0HsDjroeRQ76vLkmKSUwYwzGKjfbJCeO-wLEuw@mail.gmail.com>
In-Reply-To: <CAEH94LhNWsye0HsDjroeRQ76vLkmKSUwYwzGKjfbJCeO-wLEuw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/01/2012 05:49 PM, Zhi Yong Wu wrote:

> On Sun, Jul 1, 2012 at 5:41 PM, Mike Fleetwood
> <mike.fleetwood@googlemail.com> wrote:
>> On 1 July 2012 05:53, Zhi Yong Wu <zwu.kernel@gmail.com> wrote:
>>> HI,
>>>
>>> Do anyone know where btrfs_print_tree is invoked? thanks.
>>>
>>> --
>>> Regards,
>>>
>>> Zhi Yong Wu
>>
>> Is this the answer you are after?
>>
>> $ grep -r btrfs_print_tree fs/btrfs/
>> fs/btrfs/print-tree.c:void btrfs_print_tree(struct btrfs_root *root,
>> struct extent_buffer *c)
>> fs/btrfs/print-tree.c:          btrfs_print_tree(root, next);
>> fs/btrfs/print-tree.h:void btrfs_print_tree(struct btrfs_root *root,
>> struct extent_buffer *t);
> No, i also did as this, but didn't find out who will invoke this
> function. From above output, we only saw that it invokes itself one
> time.

Looks this is a helper routine exported to btrfs-progs previously, it is
used by debug-tree, quick-test, etc...

But this function has been implemented at btrfs-progs now, maybe it
could be safely removed from kernel, not sure. :)

Thanks,
-Jeff

> 
>>
>> Mike
> 
> 
> 


