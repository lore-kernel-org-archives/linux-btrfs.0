From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Subject: Re: Compile error of latest hotfix release of btrfs
Date: Mon, 03 Nov 2008 16:36:55 +0200
Message-ID: <490F0C87.20300@turknet.net.tr>
References: <490EB395.2020803@turknet.net.tr> <977a2be20811030549l6b9a04edxafe7aec9729c3471@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Cc: linux-btrfs@vger.kernel.org
To: yanhai zhu <zhu.yanhai@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <977a2be20811030549l6b9a04edxafe7aec9729c3471@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Yanhai,

Thank you very much for the help and the patch. But; unfortunately, it=20
didn't work ;-(
I got the following errors :

tarkane@tarkane:~/btrfs/kernel-417d87e57364$ make
bash version.sh
make -C /lib/modules/`uname -r`/build M=3D`pwd` modules
make[1]: Entering directory `/usr/src/linux-2.6.28-rc3'
CC [M] /home/tarkane/btrfs/kernel-417d87e57364/super.o
CC [M] /home/tarkane/btrfs/kernel-417d87e57364/ctree.o
CC [M] /home/tarkane/btrfs/kernel-417d87e57364/extent-tree.o
CC [M] /home/tarkane/btrfs/kernel-417d87e57364/print-tree.o
CC [M] /home/tarkane/btrfs/kernel-417d87e57364/root-tree.o
CC [M] /home/tarkane/btrfs/kernel-417d87e57364/dir-item.o
CC [M] /home/tarkane/btrfs/kernel-417d87e57364/hash.o
CC [M] /home/tarkane/btrfs/kernel-417d87e57364/file-item.o
CC [M] /home/tarkane/btrfs/kernel-417d87e57364/inode-item.o
CC [M] /home/tarkane/btrfs/kernel-417d87e57364/inode-map.o
CC [M] /home/tarkane/btrfs/kernel-417d87e57364/disk-io.o
CC [M] /home/tarkane/btrfs/kernel-417d87e57364/transaction.o
CC [M] /home/tarkane/btrfs/kernel-417d87e57364/bit-radix.o
CC [M] /home/tarkane/btrfs/kernel-417d87e57364/inode.o
CC [M] /home/tarkane/btrfs/kernel-417d87e57364/file.o
CC [M] /home/tarkane/btrfs/kernel-417d87e57364/tree-defrag.o
CC [M] /home/tarkane/btrfs/kernel-417d87e57364/extent_map.o
CC [M] /home/tarkane/btrfs/kernel-417d87e57364/sysfs.o
CC [M] /home/tarkane/btrfs/kernel-417d87e57364/struct-funcs.o
CC [M] /home/tarkane/btrfs/kernel-417d87e57364/xattr.o
CC [M] /home/tarkane/btrfs/kernel-417d87e57364/ordered-data.o
CC [M] /home/tarkane/btrfs/kernel-417d87e57364/extent_io.o
/home/tarkane/btrfs/kernel-417d87e57364/extent_io.c: In function=20
=91extent_readpages=92:
/home/tarkane/btrfs/kernel-417d87e57364/extent_io.c:2271: error: too fe=
w=20
arguments to function =91____pagevec_lru_add=92
/home/tarkane/btrfs/kernel-417d87e57364/extent_io.c:2276: error:=20
=91bio_flags=92 undeclared (first use in this function)
/home/tarkane/btrfs/kernel-417d87e57364/extent_io.c:2276: error: (Each=20
undeclared identifier is reported only once
/home/tarkane/btrfs/kernel-417d87e57364/extent_io.c:2276: error: for=20
each function it appears in.)
/home/tarkane/btrfs/kernel-417d87e57364/extent_io.c:2276: error: too=20
many arguments to function =91__extent_read_full_page=92
/home/tarkane/btrfs/kernel-417d87e57364/extent_io.c:2281: error:=20
implicit declaration of function =91__pagevec_lru_add=92
make[2]: *** [/home/tarkane/btrfs/kernel-417d87e57364/extent_io.o] Erro=
r 1
make[1]: *** [_module_/home/tarkane/btrfs/kernel-417d87e57364] Error 2
make[1]: Leaving directory `/usr/src/linux-2.6.28-rc3'
make: *** [all] Error 2
tarkane@tarkane:~/btrfs/kernel-417d87e57364$



yanhai zhu wrote:
> hello,
>    try this.
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 9b37ce6..eb01341 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2539,7 +2539,11 @@ int extent_readpages(struct extent_io_tree *tr=
ee,
>                         /* open coding of lru_cache_add, also not exp=
orted */
>                         page_cache_get(page);
>                         if (!pagevec_add(&pvec, page))
> +                       #if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,=
6,28)
> +                               ____pagevec_lru_add(&pvec);
> +                       #else
>                                 __pagevec_lru_add(&pvec);
> +                       #endif
>                         __extent_read_full_page(tree, page, get_exten=
t,
>                                                 &bio, 0, &bio_flags);
>                 }
>
> 2008/11/3 Tarkan Erimer <tarkan.erimer@turknet.net.tr>:
>  =20
>> Hi,
>>
>> I use Kubuntu-8.10 with custom kernel 2.6.28-rc2 and my gcc version =
is "gcc
>> (Ubuntu 4.3.2-1ubuntu11) 4.3.2". When I tried to compile latest btrf=
s
>> source, I got these error messages :
>>
>> tarkane@tarkane:/media/disk/kernel-417d87e57364$ make
>> bash version.sh
>> make -C /lib/modules/`uname -r`/build M=3D`pwd` modules
>> make[1]: Entering directory `/usr/src/linux-2.6.28-rc2'
>> CC [M] /media/disk/kernel-417d87e57364/super.o
>> CC [M] /media/disk/kernel-417d87e57364/ctree.o
>> CC [M] /media/disk/kernel-417d87e57364/extent-tree.o
>> CC [M] /media/disk/kernel-417d87e57364/print-tree.o
>> CC [M] /media/disk/kernel-417d87e57364/root-tree.o
>> CC [M] /media/disk/kernel-417d87e57364/dir-item.o
>> CC [M] /media/disk/kernel-417d87e57364/hash.o
>> CC [M] /media/disk/kernel-417d87e57364/file-item.o
>> CC [M] /media/disk/kernel-417d87e57364/inode-item.o
>> CC [M] /media/disk/kernel-417d87e57364/inode-map.o
>> CC [M] /media/disk/kernel-417d87e57364/disk-io.o
>> CC [M] /media/disk/kernel-417d87e57364/transaction.o
>> CC [M] /media/disk/kernel-417d87e57364/bit-radix.o
>> CC [M] /media/disk/kernel-417d87e57364/inode.o
>> CC [M] /media/disk/kernel-417d87e57364/file.o
>> CC [M] /media/disk/kernel-417d87e57364/tree-defrag.o
>> CC [M] /media/disk/kernel-417d87e57364/extent_map.o
>> CC [M] /media/disk/kernel-417d87e57364/sysfs.o
>> CC [M] /media/disk/kernel-417d87e57364/struct-funcs.o
>> CC [M] /media/disk/kernel-417d87e57364/xattr.o
>> CC [M] /media/disk/kernel-417d87e57364/ordered-data.o
>> CC [M] /media/disk/kernel-417d87e57364/extent_io.o
>> /media/disk/kernel-417d87e57364/extent_io.c: In function 'extent_rea=
dpages':
>> /media/disk/kernel-417d87e57364/extent_io.c:2270: error: implicit
>> declaration of function '__pagevec_lru_add'
>> make[2]: *** [/media/disk/kernel-417d87e57364/extent_io.o] Error 1
>> make[1]: *** [_module_/media/disk/kernel-417d87e57364] Error 2
>> make[1]: Leaving directory `/usr/src/linux-2.6.28-rc2'
>> make: *** [all] Error 2
>> tarkane@tarkane:/media/disk/kernel-417d87e57364$
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrf=
s" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>    =20
>
>
>
>  =20

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
