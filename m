From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: Code bug or data bug?
Date: Tue, 10 Aug 2010 19:12:45 +0800
Message-ID: <AANLkTikWzo1r5FEsdsTfYCA7c+9Xfhfb9NdbhHuM9_2y@mail.gmail.com>
References: <4C607F45.3020901@noir.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: "K. Richard Pixley" <rich@noir.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C607F45.3020901@noir.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 10, 2010 at 6:20 AM, K. Richard Pixley <rich@noir.com> wrot=
e:
> =A0I've just gotten:
>
> rich@diamonds:~$ time sudo /sbin/btrfsck /dev/sda7
> btrfsck: btrfsck.c:585: splice_shared_node: Assertion `!(src =3D=3D
> &src_node->root_cache)' failed.
> Aborted
>
> Does this indicate a coding error in btrfsck or a data error in my fi=
le
> system?
>
> --rich
>
> rich@diamonds:~$ dpkg -l | grep btrfs
> ii =A0btrfs-tools =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A00.19+20100601-3
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Checksumming Copy on Write Filesy=
stem utilit
> rich@diamonds:~$ uname -a
> Linux diamonds 2.6.32-24-generic-pae #38-Ubuntu SMP Mon Jul 5 10:54:2=
1 UTC
> 2010 i686 GNU/Linux
> rich@diamonds:~$ lsb_release -a
> No LSB modules are available.
> Distributor ID: Ubuntu
> Description: =A0 =A0Ubuntu 10.04.1 LTS
> Release: =A0 =A0 =A0 =A010.04
> Codename: =A0 =A0 =A0 lucid
>

This is a bug in btrfsck.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
