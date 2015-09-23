Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:37023
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbbIWJgU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 05:36:20 -0400
Subject: Re: problem with long running btrfs mount operation
References: <20150923054216.GD14395@sfserver>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        "S. Fricke" <silvio.fricke@gmail.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <56027292.4010800@googlemail.com>
Date: Wed, 23 Sep 2015 11:36:18 +0200
MIME-Version: 1.0
In-Reply-To: <20150923054216.GD14395@sfserver>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/23/15 07:42, S. Fricke wrote:
> 
> the 'btrfs check' has took some time. Here is the printout. Some advises for me?
> 
> 
> Best Regards,
> Silvio
> 
> % sudo btrfs check /dev/sda1
> Checking filesystem on /dev/sda1
> UUID: 4db27f9b-d8fe-4341-985a-4ce55ea9fd25
> checking extents
> bad metadata [1634295414784, 1634295418880) crossing stripe boundary
> bad metadata [1634394767360, 1634394771456) crossing stripe boundary
> bad metadata [1634691842048, 1634691846144) crossing stripe boundary
> bad metadata [1634770485248, 1634770489344) crossing stripe boundary
> bad metadata [1634798141440, 1634798145536) crossing stripe boundary
> [... many lines cutted ...]

Btw these messages are the reasons I wanted you to run progs-4.2.1,
since 4.2(.0) would print them even if the problem wasn't there.
But it looks like you really do have the problem. This is a converted fs,
right?

Unfortunately this problem is currently only detected, but not yet
really fixable (see [1] for details), so I don't think running check
with --repair is going to help. However it might bring the rest of the
fs back into a workable state (remember to use -o skip_balance!) so that
you can backup whatever needs rescuing.

Last resort would be to mount -ro, which will prevent the fs from COWing
itself deeper into that particular hole.

FWIW this particular bug with convert creating borked filesystems should
be fixed now, so just try again. :)

Maybe someone else has a better suggestion for recovery.

-h

[1] https://github.com/kdave/btrfs-progs/commit/595c57d2f4dd3199aacb23b4c68d6aff49f97d29

> bad metadata [1908346978304, 1908346982400) crossing stripe boundary
> bad metadata [1908597653504, 1908597657600) crossing stripe boundary
> bad metadata [1908663386112, 1908663390208) crossing stripe boundary
> bad metadata [1908664041472, 1908664045568) crossing stripe boundary
> bad metadata [1908832010240, 1908832014336) crossing stripe boundary
> bad metadata [1908848984064, 1908848988160) crossing stripe boundary
> ref mismatch on [1908883419136 4096] extent item 1, found 0
> Backref 1908883419136 parent 1890809671680 not referenced back 0x4fadc740
> Incorrect global backref count on 1908883419136 found 1 wanted 0
> backpointer mismatch on [1908883419136 4096]
> owner ref check failed [1908883419136 4096]
> bad metadata [1908961640448, 1908961644544) crossing stripe boundary
> bad metadata [1909004566528, 1909004570624) crossing stripe boundary
> bad metadata [1909015052288, 1909015056384) crossing stripe boundary
> bad metadata [1909015183360, 1909015187456) crossing stripe boundary
> Backref 1909016203264 parent 1890809671680 not referenced back 0x4fc37690
> Backref 1909016203264 parent 5105 root 5105 not found in extent tree
> Incorrect global backref count on 1909016203264 found 3 wanted 2
> backpointer mismatch on [1909016203264 4096]
> bad metadata [1909017804800, 1909017808896) crossing stripe boundary
> bad metadata [1909144289280, 1909144293376) crossing stripe boundary
> bad metadata [1909164539904, 1909164544000) crossing stripe boundary
> bad metadata [1909445033984, 1909445038080) crossing stripe boundary
> Errors found in extent allocation tree or chunk allocation
> checking free space cache
> cache and super generation don't match, space cache will be invalidated
> checking fs roots
> checking csums
> checking root refs
> found 716978874897 bytes used err is 0
> total csum bytes: 662660776
> total tree bytes: 39097315328
> total fs tree bytes: 36827172864
> total extent tree bytes: 1529536512
> btree space waste bytes: 11582963983
> file data blocks allocated: 1258206822400
>  referenced 1158920425472
> btrfs-progs v4.2.1


