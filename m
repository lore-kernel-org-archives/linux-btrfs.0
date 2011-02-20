From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: bug#8001: cp (8.10) sparse handling fails on compressed btrfs (cp/fiemap-2)
Date: Sat, 19 Feb 2011 19:53:18 -0500
Message-ID: <AANLkTi=4x+RzqZRKVCreWy67eOUSocjA4c_N+9aEHeG9@mail.gmail.com>
References: <201102072253.34476.vapier@gentoo.org> <4D52730A.2080008@draigBrady.com>
 <201102191328.42067.vapier@gentoo.org> <4D6050A7.5090407@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: 8001@debbugs.gnu.org,
	BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
To: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigbrady.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D6050A7.5090407@draigBrady.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011/2/19 P=E1draig Brady:
> On 19/02/11 18:28, Mike Frysinger wrote:
>> based on other threads (which i havent been following too closely), =
did we
>> settle on this being a btrfs bug ?
>
> Nope, cp 8.10 is not absolved yet.
> It may be btrfs not honoring FIEMAP_FLAG_SYNC,
> and/or it may be cp needing to handle FIEMAP_EXTENT_ENCODED
> specially.
>
> It would help if you ran `sync` before the copy,
> to exclude that as a possible issue.

makes no difference after applying this patch:

--- coreutils-8.10/tests/cp/fiemap-2
+++ coreutils-8.10/tests/cp/fiemap-2
@@ -43,12 +43,19 @@
 printf x > k || framework_failure_
 dd bs=3D1k seek=3D1 of=3Dk count=3D255 < /dev/zero || framework_failur=
e_

+filefrag -v k
+sync
+filefrag -v k
+
 # cp should detect the all-zero blocks and convert some of them to hol=
es.
 # How many it detects/converts currently depends on io_blksize.
 # Currently, on my F14/ext4 desktop, this K starts off with size 256Ki=
B,
 # (note that the K in the preceding test starts off with size 4KiB).
 # cp from coreutils-8.9 with --sparse=3Dalways reduces the size to 32K=
iB.
 cp --sparse=3Dalways k k2 || fail=3D1
+
+sync
+
 test $(stat -c %b k2) -lt $(stat -c %b k) || fail=3D1

 Exit $fail

> Also `filefrag -v` output for the file on
> the compressed BTRFS file system would be helpful.

the output from the aforementioned patch:
=2E..
+ dd bs=3D1k seek=3D1 of=3Dk count=3D255
255+0 records in
255+0 records out
261120 bytes (261 kB) copied, 0.00313737 s, 83.2 MB/s
+ filefrag -v k
=46ilesystem type is: 9123683e
=46ile size of k is 262144 (64 blocks, blocksize 4096)
 ext logical physical expected length flags
k: 1 extent found
+ sync
+ filefrag -v k
=46ilesystem type is: 9123683e
=46ile size of k is 262144 (64 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0    47917              32
   1      32    47918    47948     32 eof
k: 2 extents found
=2E..
-mike
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
