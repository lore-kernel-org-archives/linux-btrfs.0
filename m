Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E4B3AE1A9
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 09:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775726081; cv=pass; b=e5HtGWgx8u4/8U5yC7TayRexXD6yFLwK2rqigqL8junagK1+q31RHErS3CT1o4kHNE0H+csw7ZuCh7jNno7h7izP64Y9AJBp9wD06T9xTd4pnrgXxHlkQ2R6hU1+KYvC2bEg91nMVndMQI87eQa8RfV0WGRI7cPd8MdK9IlB5B0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775726081; c=relaxed/simple;
	bh=gauafJzPVk7OICtW2s22+XrpPM87L48ihBJB3QB984c=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=XwMbkdFown+ID8znNG5/pAblx7aVikqA3TQdPwiiOu7ohvIM46MDm8/HEM4912vrH/y/zGFMWa02p8SEK+M57sUUGiNTO0b2DYwvQxUU9+6K2uxNqQkvifotWKJ8Fpt8JS81vs8wd5HlISO/AINkRlN4cg6jKXNAug9cBMk2FCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HrWhzh/6; arc=pass smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HrWhzh/6"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-89cc71f4311so8535316d6.3
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2026 02:14:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775726074; cv=none;
        d=google.com; s=arc-20240605;
        b=aPI79oU6RUbKDcse6yIiuvMBWpLKp0LNCdqnSTXcDrvi47GSnynZoLGx9eHFGR6ZiE
         f4y2ADAwnh2/Q9L+mmaNH+y/2YMGp8nK5vBt6o1fE/bIM5co8DRPvvOxZ+So6UvgRNGZ
         KDXRsYvGeHENMiboO3dkF0AMw8FDDixR9940z9Hc0qj6iRkYh5BB8xrqQWHKLOlh5Jxp
         IXiiQzzu7UPDTghT38w8X9fcuTqDJUPFWkimkAtJsQQgbaCbLF6UC1KGUwN2xcFV+SGS
         5XO1Jp8E0O5z6awFmru7i7evWKDAzgFyOgaIL3/CxLd0Vcmr7CFRwNUAkj2tkI8uGA+I
         /0ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=LXMF7pE6GY3zNg9c+nqLCLXtkl0mDohtaCW9LL08lTE=;
        fh=iqObp/oR0uyU7GJwCcYOws79TH0B2xIdBScvksQBBbE=;
        b=i2lsSywaSQOFBQHkGVLQ7NTPUWP73bBA9tBc+SRX6sleIoijxFVkhZUxkNy6xOg6gw
         wIvO5BZKOokmPZWiVo6wEYosl/DKx4m2kYVsPE/uLIYWzDye5lSTSqdM/AVFszbdeYMp
         7l+7BrJYALlSsqUc+aBrDEtkbkMhwE5g/d/k8nBom+ZL+bpeOxNmEZVWVl9ZNLoR2lsy
         SIpEuzPWotvEZPeOlqdlAIDog24Z7lzc3KX3bIY6ByXy3PWV8qlfV28Wbn597G09JRyp
         nDkFc1lASnM3HjpFM3K0uAh16ZhqhULIXmSAqFu1lxXpV8Mk86LrBrmzqcHSWlbpZ6Zk
         knqA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775726074; x=1776330874; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LXMF7pE6GY3zNg9c+nqLCLXtkl0mDohtaCW9LL08lTE=;
        b=HrWhzh/69FQLkxGEsjHyDT6CKLb76jcyMqgoyobdIrCtl4tQQkOrWEJrRhW4mem//1
         f+awKkdRnuRjxbrSaI0t9S4b6O1JZAkNCcZ7r6lmq11J3C4nJolurahTxc6MHQKdIl5b
         mwVK8Z3uwwziTYsdmE2iLBUMwi3VBFX1+HCvwJvqYRGCQyYl1IN8CtpHcM7WNpBYOspa
         hDdgyQ8+QywbZQXCCR+vuQPefUq9JS8XnbDFrJEW6isGHhN1vAigaQ+6J3E0qJSlSrVz
         Ehln2MitePJe52FRwq6a94N7qZNqTMNOE4Iu9Vs0926fGUX6AWxQUzEgHSTarDAJVCLS
         ihAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775726074; x=1776330874;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LXMF7pE6GY3zNg9c+nqLCLXtkl0mDohtaCW9LL08lTE=;
        b=aWQbp2SglOjt/MGNt721Rk7DoJASEpHTOAi9FfNSDvNAZWTRdxS2O90MVAdn4QUOIf
         xnLXOLIn3sbv5YAsmC7Rc3OvcgC8iaZJI4LbBXWoderHV6RFIdxS/mmXu5QXpumohbha
         bIn6GvxtB9o/y55ZZjqHZVcSODmrkrd/dDVr48qrjSV0F9CF8wW2+6wXHYjV8f6W0kuK
         XzxzonyUmB2gSFEMwMJeHusBUc1mRWHGzoD6nFVEBWRzDARZV3CHO83+cJ5F7Fa3EWG0
         we+zXv2pOiUlXsQeGGQVY05VaDqftlsaaO3R89tw7lixZ+B3K3m9xvTSOqM29d5RzDtf
         7ipQ==
X-Gm-Message-State: AOJu0Yw6mmjZ6ACFktKIc0t861m2Ey7zdRQUeIcyldtVCh+d2KEmjVK9
	akIT/plPnY6H2aP+hDofNVpZMEMaaaLvH39+UAo81HW5fQuNp/P28/InKgQUYEbTVb7rFyG7aNU
	WGxsZ7tAHkvPFsYuF9X1Q7xEiSaj+hG7vXg==
X-Gm-Gg: AeBDievg4I4mIvegjcZZiyjCNy+jb6KfiI/Eh5exemDLn8hAorStbkHBi4pu3wn68zV
	hwLABUx/9iJaRFn1nNN5mXnbkCsidR/0w/itMcCDiJjmPIBlFIwoXdfo8ba9X7zoiIHNDa7Rnxm
	DVJnBnLaA4Qe8O4zczeLE2RnWCAytipLWHdTwzdHK7NAR3lOqZXu7xh9k8ut99N7Fmi1+w/LOmL
	JpdAEotv6DjCuMYADWM58ncJf+Lwx/npOagAOmGysFDhD1Vn2dEiNTrYsRNzusx8YBM/TiNNVSB
	QZaD/Go=
X-Received: by 2002:a05:6214:194b:b0:8aa:a025:78e3 with SMTP id
 6a1803df08f44-8aaa0257deamr257065736d6.6.1775726074218; Thu, 09 Apr 2026
 02:14:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Slava0135 <slava.kovalevskiy.2014@gmail.com>
Date: Thu, 9 Apr 2026 12:14:22 +0300
X-Gm-Features: AQROBzAOjm7GhxcuPnIOdf-UFUbqFtHhIIDlfyR7qR0DrCkUR5fkXxFulW4o4IU
Message-ID: <CAAJYhww5ov62Hm+n+tmhcL-e_4cBobg+OWogKjOJxVUXivC=MQ@mail.gmail.com>
Subject: File system corruption after updating dir metadata, moving entry
 inside to another dir and removing the first dir if system crashes
To: clm@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Detailed description
====================

Hello, there seems to be an issue with btrfs crash behavior:

1. Create and sync directories `dir1`, `dir1/dir2` and `dir3`.
2. Open `dir1` and update directory metadata using the descriptor (e.g.
futimens or fchmod).
3. Sync `dir1` with fsync.
4. Rename `dir1/dir2` to `dir3/dir2`.
5. Remove `dir1`.
6. Sync `dir1` with fsync.

After system crash (e.g. power failure) mounting file system results in
critical error, caused by corrupt leaf (`invalid nlink: has 2 expect no
more than 1 for dir`).


System info
===========

Linux version 7.0.0-rc7


How to reproduce
================

Test:

```
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

int main() {
   int status;
   int dir_fd;

   status = mkdir("dir1", S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
   printf("MKDIR: %d\n", status);

   status = mkdir("dir1/dir2", S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
   printf("MKDIR: %d\n", status);

   status = mkdir("dir3", S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
   printf("MKDIR: %d\n", status);

   sync();

   status = open("dir1", O_RDONLY | O_DIRECTORY);
   printf("OPEN: %d\n", status);
   dir_fd = status;

   status = futimens(dir_fd, NULL);
   printf("FUTIMENS: %d\n", status);

   status = fsync(dir_fd);
   printf("FSYNC: %d\n", status);

   status = rename("dir1/dir2", "dir3/dir2");
   printf("RENAME: %d\n", status);

   status = rmdir("dir1");
   printf("RMDIR: %d\n", status);

   status = fsync(dir_fd);
   printf("FSYNC: %d\n", status);
}
```

mount:

```
root@ubuntu:~# mount -t btrfs /dev/vdb /mnt/fstest
mount: /mnt/fstest: can't read superblock on /dev/vdb.
        dmesg(1) may have more information after failed mount system call.
```

dmesg:

```
[   23.230911] BTRFS: device fsid e045376a-9e24-44ff-b677-1a89d9288309
devid 1 transid 9 /dev/vdb (253:16) scanned by mount (1091)
[   23.231199] BTRFS info (device vdb): first mount of filesystem
e045376a-9e24-44ff-b677-1a89d9288309
[   23.231204] BTRFS info (device vdb): using crc32c checksum algorithm
[   23.232581] BTRFS info (device vdb): start tree-log replay
[   23.233057] page: refcount:2 mapcount:0 mapping:000000006e29dee3
index:0x1d00 pfn:0x11bc9b
[   23.233062] memcg:ffff88810039c380
[   23.233065] aops:btree_aops ino:1
[   23.233071] flags:
0x17ffffc800402a(uptodate|lru|private|writeback|node=0|zone=2|lastcpupid=0x1fffff)
[   23.233076] raw: 0017ffffc800402a ffffea00045dc6c8 ffffea00046c68c8
ffff888100499a98
[   23.233078] raw: 0000000000001d00 ffff888121483b40 00000002ffffffff
ffff88810039c380
[   23.233079] page dumped because: eb page dump
[   23.233081] BTRFS critical (device vdb): corrupt leaf: root=5
block=30408704 slot=10 ino=258, invalid nlink: has 2 expect no more than
1 for dir
[   23.234545] BTRFS info (device vdb): leaf 30408704 gen 10 total ptrs
17 free space 14878 owner 5
[   23.234548]  item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
[   23.234549]          inode generation 3 transid 9 size 16 nbytes 16384
[   23.234550]          block group 0 mode 40755 links 1 uid 0 gid 0
[   23.234552]          rdev 0 sequence 2 flags 0x0
[   23.234552]          atime 1775723505.0
[   23.234554]          ctime 1775723523.943656123
[   23.234554]          mtime 1775723523.943656123
[   23.234555]          otime 1775723505.0
[   23.234556]  item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
[   23.234557]          index 0 name_len 2
[   23.234558]  item 2 key (256 DIR_ITEM 1843588421) itemoff 16077
itemsize 34
[   23.234559]          location key (259 1 0) type 2
[   23.234560]          transid 9 data_len 0 name_len 4
[   23.234561]  item 3 key (256 DIR_ITEM 2363071922) itemoff 16043
itemsize 34
[   23.234562]          location key (257 1 0) type 2
[   23.234563]          transid 9 data_len 0 name_len 4
[   23.234564]  item 4 key (256 DIR_INDEX 2) itemoff 16009 itemsize 34
[   23.234565]          location key (257 1 0) type 2
[   23.234565]          transid 9 data_len 0 name_len 4
[   23.234566]  item 5 key (256 DIR_INDEX 3) itemoff 15975 itemsize 34
[   23.234567]          location key (259 1 0) type 2
[   23.234568]          transid 9 data_len 0 name_len 4
[   23.234568]  item 6 key (257 INODE_ITEM 0) itemoff 15815 itemsize 160
[   23.234569]          inode generation 9 transid 9 size 8 nbytes 0
[   23.234570]          block group 0 mode 40755 links 1 uid 0 gid 0
[   23.234571]          rdev 0 sequence 1 flags 0x0
[   23.234572]          atime 1775723523.943656123
[   23.234573]          ctime 1775723523.943656123
[   23.234573]          mtime 1775723523.943656123
[   23.234574]          otime 1775723523.943656123
[   23.234575]  item 7 key (257 INODE_REF 256) itemoff 15801 itemsize 14
[   23.234576]          index 2 name_len 4
[   23.234577]  item 8 key (257 DIR_ITEM 2676584006) itemoff 15767
itemsize 34
[   23.234577]          location key (258 1 0) type 2
[   23.234578]          transid 9 data_len 0 name_len 4
[   23.234579]  item 9 key (257 DIR_INDEX 2) itemoff 15733 itemsize 34
[   23.234580]          location key (258 1 0) type 2
[   23.234581]          transid 9 data_len 0 name_len 4
[   23.234581]  item 10 key (258 INODE_ITEM 0) itemoff 15573 itemsize 160
[   23.234582]          inode generation 9 transid 10 size 0 nbytes 0
[   23.234583]          block group 0 mode 40755 links 2 uid 0 gid 0
[   23.234584]          rdev 0 sequence 0 flags 0x0
[   23.234585]          atime 1775723523.943656123
[   23.234586]          ctime 1775723523.943656123
[   23.234586]          mtime 1775723523.943656123
[   23.234587]          otime 1775723523.943656123
[   23.234588]  item 11 key (258 INODE_REF 257) itemoff 15559 itemsize 14
[   23.234589]          index 2 name_len 4
[   23.234589]  item 12 key (258 INODE_REF 259) itemoff 15545 itemsize 14
[   23.234590]          index 2 name_len 4
[   23.234591]  item 13 key (259 INODE_ITEM 0) itemoff 15385 itemsize 160
[   23.234592]          inode generation 9 transid 10 size 8 nbytes 0
[   23.234593]          block group 0 mode 40755 links 1 uid 0 gid 0
[   23.234593]          rdev 0 sequence 1 flags 0x0
[   23.234594]          atime 1775723523.943656123
[   23.234595]          ctime 1775723523.943656123
[   23.234596]          mtime 1775723523.943656123
[   23.234596]          otime 1775723523.943656123
[   23.234597]  item 14 key (259 INODE_REF 256) itemoff 15371 itemsize 14
[   23.234598]          index 3 name_len 4
[   23.234599]  item 15 key (259 DIR_ITEM 2676584006) itemoff 15337
itemsize 34
[   23.234600]          location key (258 1 0) type 2
[   23.234600]          transid 10 data_len 0 name_len 4
[   23.234601]  item 16 key (259 DIR_INDEX 2) itemoff 15303 itemsize 34
[   23.234602]          location key (258 1 0) type 2
[   23.234603]          transid 10 data_len 0 name_len 4
[   23.234604] BTRFS error (device vdb): block=30408704 write time tree
block corruption detected
[   23.235937] BTRFS error (device vdb): error while writing out
transaction: -5
[   23.236989] BTRFS warning (device vdb): Skipping commit of aborted
transaction.
[   23.236992] BTRFS error (device vdb state A): Transaction aborted
(error -5)
[   23.238020] BTRFS: error (device vdb state A) in
cleanup_transaction:2061: errno=-5 IO failure
[   23.238744] BTRFS error (device vdb state EA): failed to recover log
trees with error: -5
[   23.239614] BTRFS error (device vdb state EA): open_ctree failed: -5
```

Steps:

1. Create and mount new btrfs file system in default configuration.
2. Change directory to root of the file system and run the compiled test.
3. Cause hard system crash (e.g. QEMU `system_reset` command).
4. Remount file system after crash.
5. Observe that mount fails.
