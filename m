From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: The value displayed by 'ls -s' command is strange.
Date: Tue, 7 Dec 2010 11:16:55 -0800
Message-ID: <AANLkTi=yQGxx7P=EoAP1sOg5rakmSmb-y+5OTeGbJnyx@mail.gmail.com>
References: <4CFDE978.9050407@jp.fujitsu.com>
	<1291743093-sup-2051@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1291743093-sup-2051@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 7, 2010 at 10:44 AM, Chris Mason <chris.mason@oracle.com> w=
rote:
> Excerpts from Tsutomu Itoh's message of 2010-12-07 02:59:52 -0500:
>> Hi,
>>
>> I think that the disk allocation size of each file becomes a monoton=
e increase
>> when the file is made.
>> But, it sometimes return to 0. =C2=A0Is it correct?
>
> Well, there's a window during the processing of delayed allocation wh=
ere
> we don't have the bytes recorded as delalloc and we don't have the by=
tes
> recorded in the inode yet. =C2=A0That's why they are showing up as ze=
ro.
>
> We don't call inode_add_bytes() until after we insert the extent, but=
 we
> drop the delalloc byte count on the file before the IO is done.
>
> Fixing it will be a little tricky because all the extent accounting
> assumes the inode_add_bytes happens at extent insertion time.
>

How does opening the inode with O_APPEND during this window know where
to write the bytes?  If it's a pointer/cursor to the EOF then that
size could be used during the window.  Is that right?

>>
>>
>> The result of the test at 2.6.37-rc4 is shown below.
>> (see inode no. 291)
>>
>> =C2=A0 =C2=A0 # df -T /test14
>> =C2=A0 =C2=A0 Filesystem =C2=A0 =C2=A0Type =C2=A0 1K-blocks =C2=A0 =C2=
=A0 =C2=A0Used Available Use% Mounted on
>> =C2=A0 =C2=A0 /dev/sdd14 =C2=A0 btrfs =C2=A0 =C2=A0 4162560 =C2=A0 =C2=
=A0 =C2=A08736 =C2=A0 3709440 =C2=A0 1% /test14
>> =C2=A0 =C2=A0 # dd if=3D/dev/zero of=3D/test14/dir/as001.26603 bs=3D=
1M count=3D100
>> =C2=A0 =C2=A0 # dd if=3D/dev/zero of=3D/test14/dir/as002.26603 bs=3D=
1M count=3D200
>> =C2=A0 =C2=A0 # dd if=3D/dev/zero of=3D/test14/dir/sy001.26603 bs=3D=
1M count=3D300 oflag=3Ddirect
>> =C2=A0 =C2=A0 # dd if=3D/dev/zero of=3D/test14/dir/as003.26603 bs=3D=
1M count=3D400
>> =C2=A0 =C2=A0 # ls -lis /test14/dir
>> =C2=A0 =C2=A0 total 406528
>> =C2=A0 =C2=A0 288 =C2=A0 =C2=A0 =C2=A00 -rw-r--r-- 1 root root 10485=
7600 Dec =C2=A07 15:07 as001.26603
>> =C2=A0 =C2=A0 289 =C2=A0 =C2=A0 =C2=A00 -rw-r--r-- 1 root root 20971=
5200 Dec =C2=A07 15:07 as002.26603
>> =C2=A0-> 291 =C2=A099328 -rw-r--r-- 1 root root 419430400 Dec =C2=A0=
7 15:08 as003.26603
>> =C2=A0 =C2=A0 290 307200 -rw-r--r-- 1 root root 314572800 Dec =C2=A0=
7 15:08 sy001.26603
>> =C2=A0 =C2=A0 # sleep 3
>> =C2=A0 =C2=A0 # ls -lis /test14/dir
>> =C2=A0 =C2=A0 total 406528
>> =C2=A0 =C2=A0 288 =C2=A0 =C2=A0 =C2=A00 -rw-r--r-- 1 root root 10485=
7600 Dec =C2=A07 15:07 as001.26603
>> =C2=A0 =C2=A0 289 =C2=A0 =C2=A0 =C2=A00 -rw-r--r-- 1 root root 20971=
5200 Dec =C2=A07 15:07 as002.26603
>> =C2=A0-> 291 =C2=A099328 -rw-r--r-- 1 root root 419430400 Dec =C2=A0=
7 15:08 as003.26603
>> =C2=A0 =C2=A0 290 307200 -rw-r--r-- 1 root root 314572800 Dec =C2=A0=
7 15:08 sy001.26603
>> =C2=A0 =C2=A0 # sleep 3
>> =C2=A0 =C2=A0 # ls -lis /test14/dir
>> =C2=A0 =C2=A0 total 307200
>> =C2=A0 =C2=A0 288 =C2=A0 =C2=A0 =C2=A00 -rw-r--r-- 1 root root 10485=
7600 Dec =C2=A07 15:07 as001.26603
>> =C2=A0 =C2=A0 289 =C2=A0 =C2=A0 =C2=A00 -rw-r--r-- 1 root root 20971=
5200 Dec =C2=A07 15:07 as002.26603
>> =C2=A0-> 291 =C2=A0 =C2=A0 =C2=A00 -rw-r--r-- 1 root root 419430400 =
Dec =C2=A07 15:08 as003.26603
>> =C2=A0 =C2=A0 290 307200 -rw-r--r-- 1 root root 314572800 Dec =C2=A0=
7 15:08 sy001.26603
>> =C2=A0 =C2=A0 # sleep 3
>> =C2=A0 =C2=A0 # ls -lis /test14/dir
>> =C2=A0 =C2=A0 total 409600
>> =C2=A0 =C2=A0 288 102400 -rw-r--r-- 1 root root 104857600 Dec =C2=A0=
7 15:07 as001.26603
>> =C2=A0 =C2=A0 289 =C2=A0 =C2=A0 =C2=A00 -rw-r--r-- 1 root root 20971=
5200 Dec =C2=A07 15:07 as002.26603
>> =C2=A0-> 291 =C2=A0 =C2=A0 =C2=A00 -rw-r--r-- 1 root root 419430400 =
Dec =C2=A07 15:08 as003.26603
>> =C2=A0 =C2=A0 290 307200 -rw-r--r-- 1 root root 314572800 Dec =C2=A0=
7 15:08 sy001.26603
>> =C2=A0 =C2=A0 # sync
>> =C2=A0 =C2=A0 # ls -lis /test14/dir
>> =C2=A0 =C2=A0 total 1024000
>> =C2=A0 =C2=A0 288 102400 -rw-r--r-- 1 root root 104857600 Dec =C2=A0=
7 15:07 as001.26603
>> =C2=A0 =C2=A0 289 204800 -rw-r--r-- 1 root root 209715200 Dec =C2=A0=
7 15:07 as002.26603
>> =C2=A0-> 291 409600 -rw-r--r-- 1 root root 419430400 Dec =C2=A07 15:=
08 as003.26603
>> =C2=A0 =C2=A0 290 307200 -rw-r--r-- 1 root root 314572800 Dec =C2=A0=
7 15:08 sy001.26603
>>
>> The trace result of btrfs_getattr() is shown below.
>>
>> =C2=A0Dec =C2=A07 15:08:03 luna kernel: ino:291 blocks:198656 i_bloc=
ks:0 i_bytes:0 delalloc_bytes:101711872
>> =C2=A0Dec =C2=A07 15:08:06 luna kernel: ino:291 blocks:198656 i_bloc=
ks:0 i_bytes:0 delalloc_bytes:101711872
>> =C2=A0Dec =C2=A07 15:08:09 luna kernel: ino:291 blocks:0 i_blocks:0 =
i_bytes:0 delalloc_bytes:0
>> =C2=A0Dec =C2=A07 15:08:12 luna kernel: ino:291 blocks:0 i_blocks:0 =
i_bytes:0 delalloc_bytes:0
>> =C2=A0Dec =C2=A07 15:08:18 luna kernel: ino:291 blocks:819200 i_bloc=
ks:819200 i_bytes:0 delalloc_bytes:0
>>
>>
>> Regards,
>> Itoh
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
