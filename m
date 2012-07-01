Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45753 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab2GAKQM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Jul 2012 06:16:12 -0400
Received: by wgbdr13 with SMTP id dr13so4349116wgb.1
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Jul 2012 03:16:11 -0700 (PDT)
Message-ID: <4FF02346.6000106@gmail.com>
Date: Sun, 01 Jul 2012 12:15:34 +0200
From: Andreas Philipp <philipp.andreas@gmail.com>
MIME-Version: 1.0
To: Zhi Yong Wu <zwu.kernel@gmail.com>
CC: Mike Fleetwood <mike.fleetwood@googlemail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs_print_tree?
References: <CAEH94Lht_TcBFa1qvO1-pz12GsdfH05xnYMC-smKLOFPP2HydA@mail.gmail.com> <CAMU1PDgEokfvoCREVwB9O4Mm0Po=9UdFau3W2D0nZhhf2oWNsw@mail.gmail.com> <CAEH94LhNWsye0HsDjroeRQ76vLkmKSUwYwzGKjfbJCeO-wLEuw@mail.gmail.com>
In-Reply-To: <CAEH94LhNWsye0HsDjroeRQ76vLkmKSUwYwzGKjfbJCeO-wLEuw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
On 01.07.2012 11:49, Zhi Yong Wu wrote:
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
>> fs/btrfs/print-tree.c: btrfs_print_tree(root, next);
>> fs/btrfs/print-tree.h:void btrfs_print_tree(struct btrfs_root *root,
>> struct extent_buffer *t);
> No, i also did as this, but didn't find out who will invoke this
> function. From above output, we only saw that it invokes itself one
> time.
Is this function unused then?

Andreas
>
>
>>
>> Mike
>
>
>


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQEcBAEBAgAGBQJP8CNFAAoJEIW3W1BiBxU7C40H/0ecIgo1AagGyh/q4tLjXxAZ
PILqpKZzGiX6Qc+qWnaHrNyCJU1ntppO73k/SmhMpx+xycw/qHbqKtCpw/W8aQfn
ihKOP9amgCUR/X+1W7hn190r0c1teWnXV/bYoD81fksWYuZmG9XzBOF4u9iLrtIb
0hpeBtFPr7jizKv3puOVKBpEV3ZMUdiqwc+G5GxUSlOssqKdF38gHGvj1k3j1qTX
0JRndsaeZq0smA0RJnYa9nX7gvg8CnmUXIJ/yLgg8Rnn5LhJQoq2eK4fgE+I0OCy
SjlzSQG78W9CnWmE6SitfVeb/QUyLdCZ/mtwPxqeKd9p06hcLCU4R89rWRnNWTQ=
=bq50
-----END PGP SIGNATURE-----

