From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: The value displayed by 'ls -s' command is strange.
Date: Tue, 07 Dec 2010 17:25:38 +0800
Message-ID: <4CFDFD92.9090208@cn.fujitsu.com>
References: <4CFDE978.9050407@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CFDE978.9050407@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Tsutomu Itoh wrote:
> Hi,
> 
> I think that the disk allocation size of each file becomes a monotone increase
> when the file is made.
> But, it sometimes return to 0.  Is it correct?
> 

The # of blocks is:

        stat->blocks = (inode_get_bytes(inode) +
                        BTRFS_I(inode)->delalloc_bytes) >> 9;

So I think after sub(delalloc_bytes) and before inode_add_bytes(), you may
see 0 value.

> 
> The result of the test at 2.6.37-rc4 is shown below. 
> (see inode no. 291)
> 
>     # df -T /test14
>     Filesystem    Type   1K-blocks      Used Available Use% Mounted on
>     /dev/sdd14   btrfs     4162560      8736   3709440   1% /test14
>     # dd if=/dev/zero of=/test14/dir/as001.26603 bs=1M count=100
>     # dd if=/dev/zero of=/test14/dir/as002.26603 bs=1M count=200
>     # dd if=/dev/zero of=/test14/dir/sy001.26603 bs=1M count=300 oflag=direct
>     # dd if=/dev/zero of=/test14/dir/as003.26603 bs=1M count=400
>     # ls -lis /test14/dir
>     total 406528
>     288      0 -rw-r--r-- 1 root root 104857600 Dec  7 15:07 as001.26603
>     289      0 -rw-r--r-- 1 root root 209715200 Dec  7 15:07 as002.26603
>  -> 291  99328 -rw-r--r-- 1 root root 419430400 Dec  7 15:08 as003.26603
>     290 307200 -rw-r--r-- 1 root root 314572800 Dec  7 15:08 sy001.26603
>     # sleep 3
>     # ls -lis /test14/dir
>     total 406528
>     288      0 -rw-r--r-- 1 root root 104857600 Dec  7 15:07 as001.26603
>     289      0 -rw-r--r-- 1 root root 209715200 Dec  7 15:07 as002.26603
>  -> 291  99328 -rw-r--r-- 1 root root 419430400 Dec  7 15:08 as003.26603
>     290 307200 -rw-r--r-- 1 root root 314572800 Dec  7 15:08 sy001.26603
>     # sleep 3
>     # ls -lis /test14/dir
>     total 307200
>     288      0 -rw-r--r-- 1 root root 104857600 Dec  7 15:07 as001.26603
>     289      0 -rw-r--r-- 1 root root 209715200 Dec  7 15:07 as002.26603
>  -> 291      0 -rw-r--r-- 1 root root 419430400 Dec  7 15:08 as003.26603
>     290 307200 -rw-r--r-- 1 root root 314572800 Dec  7 15:08 sy001.26603
>     # sleep 3
>     # ls -lis /test14/dir
>     total 409600
>     288 102400 -rw-r--r-- 1 root root 104857600 Dec  7 15:07 as001.26603
>     289      0 -rw-r--r-- 1 root root 209715200 Dec  7 15:07 as002.26603
>  -> 291      0 -rw-r--r-- 1 root root 419430400 Dec  7 15:08 as003.26603
>     290 307200 -rw-r--r-- 1 root root 314572800 Dec  7 15:08 sy001.26603
>     # sync
>     # ls -lis /test14/dir
>     total 1024000
>     288 102400 -rw-r--r-- 1 root root 104857600 Dec  7 15:07 as001.26603
>     289 204800 -rw-r--r-- 1 root root 209715200 Dec  7 15:07 as002.26603
>  -> 291 409600 -rw-r--r-- 1 root root 419430400 Dec  7 15:08 as003.26603
>     290 307200 -rw-r--r-- 1 root root 314572800 Dec  7 15:08 sy001.26603
> 
> The trace result of btrfs_getattr() is shown below. 
> 
>  Dec  7 15:08:03 luna kernel: ino:291 blocks:198656 i_blocks:0 i_bytes:0 delalloc_bytes:101711872
>  Dec  7 15:08:06 luna kernel: ino:291 blocks:198656 i_blocks:0 i_bytes:0 delalloc_bytes:101711872
>  Dec  7 15:08:09 luna kernel: ino:291 blocks:0 i_blocks:0 i_bytes:0 delalloc_bytes:0
>  Dec  7 15:08:12 luna kernel: ino:291 blocks:0 i_blocks:0 i_bytes:0 delalloc_bytes:0
>  Dec  7 15:08:18 luna kernel: ino:291 blocks:819200 i_blocks:819200 i_bytes:0 delalloc_bytes:0
> 
> 
> Regards,
> Itoh
> 
