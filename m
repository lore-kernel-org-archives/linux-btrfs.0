From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: btrfs build failure in latest git
Date: Wed, 12 Jan 2011 11:00:06 +0800
Message-ID: <4D2D1936.2070201@cn.fujitsu.com>
References: <4D2CE678.10607@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Cc: LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>
To: Jeff Garzik <jeff@garzik.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D2CE678.10607@garzik.org>
List-ID: <linux-btrfs.vger.kernel.org>

Jeff Garzik wrote:
>=20
> Tree as of commit 7bc4a4ce68f8c6d064ea949446852e996526f692 dies durin=
g btrfs build on x86-64:
>=20
>   CC [M]  fs/btrfs/ctree.o
> In file included from fs/btrfs/ctree.c:21:0:
> fs/btrfs/ctree.h:1003:17: error: field =91super_kobj=92 has incomplet=
e type
> fs/btrfs/ctree.h:1074:17: error: field =91root_kobj=92 has incomplete=
 type
> make[2]: *** [fs/btrfs/ctree.o] Error 1
> make[1]: *** [fs/btrfs] Error 2
> make: *** [fs] Error 2
>=20

Should be caused by this commit:

commit 57cc7215b70856dc6bae8e55b00ecd7b1d7429b1
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Mon Jan 10 08:18:25 2011 +0200

    headers: kobject.h redux
   =20
    Remove kobject.h from files which don't need it, notably,
    sched.h and fs.h.

So the fix is to include kobject.h explicitly in ctree.h.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
