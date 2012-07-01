Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35401 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab2GAKY4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Jul 2012 06:24:56 -0400
Received: by wibhr14 with SMTP id hr14so2286905wib.1
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Jul 2012 03:24:55 -0700 (PDT)
Message-ID: <4FF02554.4010403@gmail.com>
Date: Sun, 01 Jul 2012 12:24:20 +0200
From: Andreas Philipp <philipp.andreas@gmail.com>
MIME-Version: 1.0
To: jeff.liu@oracle.com
CC: Zhi Yong Wu <zwu.kernel@gmail.com>,
        Mike Fleetwood <mike.fleetwood@googlemail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs_print_tree?
References: <CAEH94Lht_TcBFa1qvO1-pz12GsdfH05xnYMC-smKLOFPP2HydA@mail.gmail.com>	<CAMU1PDgEokfvoCREVwB9O4Mm0Po=9UdFau3W2D0nZhhf2oWNsw@mail.gmail.com> <CAEH94LhNWsye0HsDjroeRQ76vLkmKSUwYwzGKjfbJCeO-wLEuw@mail.gmail.com> <4FF02397.3040002@oracle.com>
In-Reply-To: <4FF02397.3040002@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 

On 01.07.2012 12:16, Jeff Liu wrote:
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
>>> fs/btrfs/print-tree.c: btrfs_print_tree(root, next);
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
>
> Thanks,
> -Jeff
Looks exactly the same to me.

Thanks,
Andreas

>
>
>>
>>>
>>> Mike
>>
>>
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQEcBAEBAgAGBQJP8CVUAAoJEIW3W1BiBxU7RMMH/A90pUdpILSWJndkJiddmbqW
17SyQMldS/xSFVHvT8ot92jyKqYhk6MFGwdkGgCX8RXCO5G5PzbxOGHxtF3j872V
J3fPp9qxTpNSEhy7uDsnyMvDFgNgXWNxz61G6ISZrubd0M0rTRdd77DrYLOqgwiQ
uTOwQ8WGPB+jOPb6+8URcPzyD82uUejIQKS4svmffPSQMY8gJEz5408HFB6SIyf/
+5/UUXwRYOlbNAVjiOVVhHWvrm1MDI1hD0S8duy2/TsS/cEt/d6xrWIJ9Ky2468y
Q62PRf6hu3GI3yxfNrEDn5i6vRVI/0EMzJHna56r1NApqa1jIIJFVbo53UyjnGw=
=3Dqd
-----END PGP SIGNATURE-----

