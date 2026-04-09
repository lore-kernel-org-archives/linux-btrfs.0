Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26BA348453
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 15:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775748832; cv=none; b=ANvzym+jkQH5O0ceXuadK0jMUwgjCGc04Nkd/QlpL79IkDpx7Ue1DkSvRSIZj2uiDQPRxKA7AhGAyihpSSkbMiFEASmF22eEImMv68ZqbabpZyKjWnauSvaVEl1Ea92FjKdC7zwv/YYlDFycAAlEfVoD5FGsb+fdEwck8Osp/Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775748832; c=relaxed/simple;
	bh=3xmI5tIukzllJ4Ipjn+JkqFRGVPtPy3DF7O0nN+CNUM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=esrXkDiIxfxlVmx48tqWNVN7etM9dUZ30yNhKb7JTNweOABqLoeKXTey141G6XhNxjTcG750jAshYuD1nMkoe/gpO2wmYyp9b1tK/ZPXwtL82cCCFil8ITtE8sUsmY8kWT18bu9k38+piq9Dy3sacAmDWm9nNNoxca84Owo66/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V7Rk6u/A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V7Rk6u/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5CEC4CEF7
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 15:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775748831;
	bh=3xmI5tIukzllJ4Ipjn+JkqFRGVPtPy3DF7O0nN+CNUM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=V7Rk6u/AEWyMLrMSC7zhyX7M5fN7fzws3OHgigt0GwjwgUy86Q7IZOOQKzD7t3mzt
	 AqNxxjwOK45m7c+VvhEyQoSSVNKQlxnm0iKzlfXJ5Db4dtdr/GV0cNGUYdG3I7cHoZ
	 oF1wD8E/ib55ma35YrjbnXvfBHRdYczJtachfyfqgIYEfNyBMQFn5k5L50ww+QKgpM
	 VIXToVY5hZJ//RANtsZRJJEfuniOnfV2/1mlzjMpKw+YhA8lUQsaPHxwB+MMaBhRQa
	 q0xki2WvMg/LoBkJQzRr1+uHDoi621oqaMTOaH7d1XhMfRvNW9hiZgPqnEl/RBjVu5
	 43ogs3DrNDTZg==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-66fb5f2183fso1745581a12.3
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2026 08:33:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX+irpqAwrke2Tz7jiqdTmllpN2b7ZaLq2y57nWA1qfwK97KKz7IjLio51wcG/o9lEHYk9KIXHF0S1F4Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YxOVvL318Pyo8peVvw/sM6mSugFgtAp3w2H8qU6iYi+z/NvhyOy
	6f4KBSZTXDTD5cGV3XywdPuMTjb5MMRHHbwWwCcFP/LzbKD2rkKwZJitqKv6JvUemiD8Q36hSWZ
	djefVstRIFtGip/rHx3G+gnyTsmoCE70=
X-Received: by 2002:a17:907:25c3:b0:b9c:4a6c:7dc5 with SMTP id
 a640c23a62f3a-b9c674454damr1337841866b.5.1775748830252; Thu, 09 Apr 2026
 08:33:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAJYhww5ov62Hm+n+tmhcL-e_4cBobg+OWogKjOJxVUXivC=MQ@mail.gmail.com>
In-Reply-To: <CAAJYhww5ov62Hm+n+tmhcL-e_4cBobg+OWogKjOJxVUXivC=MQ@mail.gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 9 Apr 2026 16:33:13 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7gUzu0-VJoZXrMPmNmz2UUd-8TszP5JU1_NriVxH_Gng@mail.gmail.com>
X-Gm-Features: AQROBzDNYCeprgIqF1wTfrN5t0ekVhCxJzcjBu5tJc4FP3c5VeeP6QbmLQ9OkAs
Message-ID: <CAL3q7H7gUzu0-VJoZXrMPmNmz2UUd-8TszP5JU1_NriVxH_Gng@mail.gmail.com>
Subject: Re: File system corruption after updating dir metadata, moving entry
 inside to another dir and removing the first dir if system crashes
To: Slava0135 <slava.kovalevskiy.2014@gmail.com>
Cc: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 9, 2026 at 10:22=E2=80=AFAM Slava0135
<slava.kovalevskiy.2014@gmail.com> wrote:
>
> Detailed description
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Hello, there seems to be an issue with btrfs crash behavior:
>
> 1. Create and sync directories `dir1`, `dir1/dir2` and `dir3`.
> 2. Open `dir1` and update directory metadata using the descriptor (e.g.
> futimens or fchmod).
> 3. Sync `dir1` with fsync.
> 4. Rename `dir1/dir2` to `dir3/dir2`.
> 5. Remove `dir1`.
> 6. Sync `dir1` with fsync.
>
> After system crash (e.g. power failure) mounting file system results in
> critical error, caused by corrupt leaf (`invalid nlink: has 2 expect no
> more than 1 for dir`).

Fixed here:

https://lore.kernel.org/linux-btrfs/3f193ac4b0faadc24d718c3633f8c1a9c61a687=
c.1775747553.git.fdmanana@suse.com/

Thanks.

>
>
> System info
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Linux version 7.0.0-rc7
>
>
> How to reproduce
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Test:
>
> ```
> #include <errno.h>
> #include <fcntl.h>
> #include <stdio.h>
> #include <string.h>
> #include <sys/stat.h>
> #include <sys/types.h>
> #include <unistd.h>
>
> int main() {
>    int status;
>    int dir_fd;
>
>    status =3D mkdir("dir1", S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
>    printf("MKDIR: %d\n", status);
>
>    status =3D mkdir("dir1/dir2", S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
>    printf("MKDIR: %d\n", status);
>
>    status =3D mkdir("dir3", S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
>    printf("MKDIR: %d\n", status);
>
>    sync();
>
>    status =3D open("dir1", O_RDONLY | O_DIRECTORY);
>    printf("OPEN: %d\n", status);
>    dir_fd =3D status;
>
>    status =3D futimens(dir_fd, NULL);
>    printf("FUTIMENS: %d\n", status);
>
>    status =3D fsync(dir_fd);
>    printf("FSYNC: %d\n", status);
>
>    status =3D rename("dir1/dir2", "dir3/dir2");
>    printf("RENAME: %d\n", status);
>
>    status =3D rmdir("dir1");
>    printf("RMDIR: %d\n", status);
>
>    status =3D fsync(dir_fd);
>    printf("FSYNC: %d\n", status);
> }
> ```
>
> mount:
>
> ```
> root@ubuntu:~# mount -t btrfs /dev/vdb /mnt/fstest
> mount: /mnt/fstest: can't read superblock on /dev/vdb.
>         dmesg(1) may have more information after failed mount system call=
.
> ```
>
> dmesg:
>
> ```
> [   23.230911] BTRFS: device fsid e045376a-9e24-44ff-b677-1a89d9288309
> devid 1 transid 9 /dev/vdb (253:16) scanned by mount (1091)
> [   23.231199] BTRFS info (device vdb): first mount of filesystem
> e045376a-9e24-44ff-b677-1a89d9288309
> [   23.231204] BTRFS info (device vdb): using crc32c checksum algorithm
> [   23.232581] BTRFS info (device vdb): start tree-log replay
> [   23.233057] page: refcount:2 mapcount:0 mapping:000000006e29dee3
> index:0x1d00 pfn:0x11bc9b
> [   23.233062] memcg:ffff88810039c380
> [   23.233065] aops:btree_aops ino:1
> [   23.233071] flags:
> 0x17ffffc800402a(uptodate|lru|private|writeback|node=3D0|zone=3D2|lastcpu=
pid=3D0x1fffff)
> [   23.233076] raw: 0017ffffc800402a ffffea00045dc6c8 ffffea00046c68c8
> ffff888100499a98
> [   23.233078] raw: 0000000000001d00 ffff888121483b40 00000002ffffffff
> ffff88810039c380
> [   23.233079] page dumped because: eb page dump
> [   23.233081] BTRFS critical (device vdb): corrupt leaf: root=3D5
> block=3D30408704 slot=3D10 ino=3D258, invalid nlink: has 2 expect no more=
 than
> 1 for dir
> [   23.234545] BTRFS info (device vdb): leaf 30408704 gen 10 total ptrs
> 17 free space 14878 owner 5
> [   23.234548]  item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
> [   23.234549]          inode generation 3 transid 9 size 16 nbytes 16384
> [   23.234550]          block group 0 mode 40755 links 1 uid 0 gid 0
> [   23.234552]          rdev 0 sequence 2 flags 0x0
> [   23.234552]          atime 1775723505.0
> [   23.234554]          ctime 1775723523.943656123
> [   23.234554]          mtime 1775723523.943656123
> [   23.234555]          otime 1775723505.0
> [   23.234556]  item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
> [   23.234557]          index 0 name_len 2
> [   23.234558]  item 2 key (256 DIR_ITEM 1843588421) itemoff 16077
> itemsize 34
> [   23.234559]          location key (259 1 0) type 2
> [   23.234560]          transid 9 data_len 0 name_len 4
> [   23.234561]  item 3 key (256 DIR_ITEM 2363071922) itemoff 16043
> itemsize 34
> [   23.234562]          location key (257 1 0) type 2
> [   23.234563]          transid 9 data_len 0 name_len 4
> [   23.234564]  item 4 key (256 DIR_INDEX 2) itemoff 16009 itemsize 34
> [   23.234565]          location key (257 1 0) type 2
> [   23.234565]          transid 9 data_len 0 name_len 4
> [   23.234566]  item 5 key (256 DIR_INDEX 3) itemoff 15975 itemsize 34
> [   23.234567]          location key (259 1 0) type 2
> [   23.234568]          transid 9 data_len 0 name_len 4
> [   23.234568]  item 6 key (257 INODE_ITEM 0) itemoff 15815 itemsize 160
> [   23.234569]          inode generation 9 transid 9 size 8 nbytes 0
> [   23.234570]          block group 0 mode 40755 links 1 uid 0 gid 0
> [   23.234571]          rdev 0 sequence 1 flags 0x0
> [   23.234572]          atime 1775723523.943656123
> [   23.234573]          ctime 1775723523.943656123
> [   23.234573]          mtime 1775723523.943656123
> [   23.234574]          otime 1775723523.943656123
> [   23.234575]  item 7 key (257 INODE_REF 256) itemoff 15801 itemsize 14
> [   23.234576]          index 2 name_len 4
> [   23.234577]  item 8 key (257 DIR_ITEM 2676584006) itemoff 15767
> itemsize 34
> [   23.234577]          location key (258 1 0) type 2
> [   23.234578]          transid 9 data_len 0 name_len 4
> [   23.234579]  item 9 key (257 DIR_INDEX 2) itemoff 15733 itemsize 34
> [   23.234580]          location key (258 1 0) type 2
> [   23.234581]          transid 9 data_len 0 name_len 4
> [   23.234581]  item 10 key (258 INODE_ITEM 0) itemoff 15573 itemsize 160
> [   23.234582]          inode generation 9 transid 10 size 0 nbytes 0
> [   23.234583]          block group 0 mode 40755 links 2 uid 0 gid 0
> [   23.234584]          rdev 0 sequence 0 flags 0x0
> [   23.234585]          atime 1775723523.943656123
> [   23.234586]          ctime 1775723523.943656123
> [   23.234586]          mtime 1775723523.943656123
> [   23.234587]          otime 1775723523.943656123
> [   23.234588]  item 11 key (258 INODE_REF 257) itemoff 15559 itemsize 14
> [   23.234589]          index 2 name_len 4
> [   23.234589]  item 12 key (258 INODE_REF 259) itemoff 15545 itemsize 14
> [   23.234590]          index 2 name_len 4
> [   23.234591]  item 13 key (259 INODE_ITEM 0) itemoff 15385 itemsize 160
> [   23.234592]          inode generation 9 transid 10 size 8 nbytes 0
> [   23.234593]          block group 0 mode 40755 links 1 uid 0 gid 0
> [   23.234593]          rdev 0 sequence 1 flags 0x0
> [   23.234594]          atime 1775723523.943656123
> [   23.234595]          ctime 1775723523.943656123
> [   23.234596]          mtime 1775723523.943656123
> [   23.234596]          otime 1775723523.943656123
> [   23.234597]  item 14 key (259 INODE_REF 256) itemoff 15371 itemsize 14
> [   23.234598]          index 3 name_len 4
> [   23.234599]  item 15 key (259 DIR_ITEM 2676584006) itemoff 15337
> itemsize 34
> [   23.234600]          location key (258 1 0) type 2
> [   23.234600]          transid 10 data_len 0 name_len 4
> [   23.234601]  item 16 key (259 DIR_INDEX 2) itemoff 15303 itemsize 34
> [   23.234602]          location key (258 1 0) type 2
> [   23.234603]          transid 10 data_len 0 name_len 4
> [   23.234604] BTRFS error (device vdb): block=3D30408704 write time tree
> block corruption detected
> [   23.235937] BTRFS error (device vdb): error while writing out
> transaction: -5
> [   23.236989] BTRFS warning (device vdb): Skipping commit of aborted
> transaction.
> [   23.236992] BTRFS error (device vdb state A): Transaction aborted
> (error -5)
> [   23.238020] BTRFS: error (device vdb state A) in
> cleanup_transaction:2061: errno=3D-5 IO failure
> [   23.238744] BTRFS error (device vdb state EA): failed to recover log
> trees with error: -5
> [   23.239614] BTRFS error (device vdb state EA): open_ctree failed: -5
> ```
>
> Steps:
>
> 1. Create and mount new btrfs file system in default configuration.
> 2. Change directory to root of the file system and run the compiled test.
> 3. Cause hard system crash (e.g. QEMU `system_reset` command).
> 4. Remount file system after crash.
> 5. Observe that mount fails.
>
