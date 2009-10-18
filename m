From: Prasad Joshi <prasadjoshi124@gmail.com>
Subject: Errors in btrfsck after converting ext2 FS to btrfs.
Date: Sun, 18 Oct 2009 20:05:59 +0530
Message-ID: <fe291c8c0910180735r6533b381uc482f625142e20a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I tried using the btrfs-convert utility to convert the ext2 fs to
btrfs. After the conversion was over, just to verify the correctness
of operation, ran btrfsck on the device. It showed errors 800. I am
not sure what does it mean, so thought of repoting it on mailing list.

# btrfsck /dev/sdb
root 256 inode 257 errors 800
found 1105965056 bytes used err is 1
total csum bytes: 192576
total tree bytes: 459956224
total fs tree bytes: 449585152
btree space waste bytes: 191448023
file data blocks allocated: 843206656
referenced 843206656
Btrfs v0.19-3-g6f3cf25-dirty

I also found that, after the conversion of FS from ext2 to btrfs
%usage gone up drastically. I mean before the conversion ext2 FS was
22% full but then converted btrfs is 64% used.

Steps Followed
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
1. Created an ext2 filesystem of size 2G
2. Created about 178 files of size 1M in a directory. FS was 11% full
after the operation.
3. In another directory create near about 1 Lac files of very small
size (2K). I kept on creating files till the number of available
inodes were exhausted.

# fsck /dev/sdb
fsck 1.41.3 (12-Oct-2008)
e2fsck 1.41.3 (12-Oct-2008)
/dev/sdb: clean, 131072/131072 files, 188721/524288 blocks

At this point df -kh output showed that FS as 22% full

4. Tried to convert the ext2 FS to btrfs using btrfs-convert utility

# btrfs-convert /dev/sdb
creating btrfs metadata.
creating ext2fs image file.
cleaning up system chunk.
conversion complete.

5. Ran btrfsck.

6. Mounted the file system

# df -kh
=46ilesystem=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Size=A0 Used Avail Use% M=
ounted on
=2E...
=2E...
tmpfs=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 251M=A0 104K=A0 2=
51M=A0=A0 1% /dev/shm
/dev/sdb=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 2.0G=A0 1.3G=A0 740M=A0=
 64% /mnt/fs

As you can see df displays FS is 64% full, when infact before
conversion it was onlly 22% full. Why is so much increase in
percentage usage?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
