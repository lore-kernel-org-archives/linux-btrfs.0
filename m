From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: Errors in btrfsck after converting ext2 FS to btrfs.
Date: Mon, 19 Oct 2009 15:57:28 +0800
Message-ID: <3d0408630910190057w5020f9fscf86af0887be9d1f@mail.gmail.com>
References: <fe291c8c0910180735r6533b381uc482f625142e20a@mail.gmail.com>
	 <3d0408630910181926h69763e86w9041160cdc2c10bc@mail.gmail.com>
	 <fe291c8c0910190017g533f7db9o6d99623429d5905c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Prasad Joshi <prasadjoshi124@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <fe291c8c0910190017g533f7db9o6d99623429d5905c@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 19, 2009 at 3:17 PM, Prasad Joshi <prasadjoshi124@gmail.com=
> wrote:
> On Mon, Oct 19, 2009 at 7:56 AM, Yan, Zheng <yanzheng@21cn.com> wrote=
:
>> On Sun, Oct 18, 2009 at 10:35 PM, Prasad Joshi <prasadjoshi124@gmail=
=2Ecom> wrote:
>>> Hi,
>>>
>>> I tried using the btrfs-convert utility to convert the ext2 fs to
>>> btrfs. After the conversion was over, just to verify the correctnes=
s
>>> of operation, ran btrfsck on the device. It showed errors 800. I am
>>> not sure what does it mean, so thought of repoting it on mailing li=
st.
>>>
>>> # btrfsck /dev/sdb
>>> root 256 inode 257 errors 800
>>> found 1105965056 bytes used err is 1
>>> total csum bytes: 192576
>>> total tree bytes: 459956224
>>> total fs tree bytes: 449585152
>>> btree space waste bytes: 191448023
>>> file data blocks allocated: 843206656
>>> referenced 843206656
>>> Btrfs v0.19-3-g6f3cf25-dirty
>>
>> "root 256 inode 257" is the ext2 image file. Checksum for file exten=
ts in
>> the ext2 image file is very special, so btrfsck treat it as error. T=
his error
>> has no harm, =A0it will go away after deleting the ext2 image file.
> OKay thanks.
>>
>>>
>>> I also found that, after the conversion of FS from ext2 to btrfs
>>> %usage gone up drastically. I mean before the conversion ext2 FS wa=
s
>>> 22% full but then converted btrfs is 64% used.
>>>
>>> Steps Followed
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>> 1. Created an ext2 filesystem of size 2G
>>> 2. Created about 178 files of size 1M in a directory. FS was 11% fu=
ll
>>> after the operation.
>>> 3. In another directory create near about 1 Lac files of very small
>>> size (2K). I kept on creating files till the number of available
>>> inodes were exhausted.
>>>
>>> # fsck /dev/sdb
>>> fsck 1.41.3 (12-Oct-2008)
>>> e2fsck 1.41.3 (12-Oct-2008)
>>> /dev/sdb: clean, 131072/131072 files, 188721/524288 blocks
>>>
>>> At this point df -kh output showed that FS as 22% full
>>>
>>> 4. Tried to convert the ext2 FS to btrfs using btrfs-convert utilit=
y
>>>
>>> # btrfs-convert /dev/sdb
>>> creating btrfs metadata.
>>> creating ext2fs image file.
>>> cleaning up system chunk.
>>> conversion complete.
>>>
>>> 5. Ran btrfsck.
>>>
>>> 6. Mounted the file system
>>>
>>> # df -kh
>>> Filesystem=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Size=A0 Used Avail Use%=
 Mounted on
>>> ....
>>> ....
>>> tmpfs=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 251M=A0 104K=A0=
 251M=A0=A0 1% /dev/shm
>>> /dev/sdb=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 2.0G=A0 1.3G=A0 740=
M=A0 64% /mnt/fs
>>>
>>> As you can see df displays FS is 64% full, when infact before
>>> conversion it was onlly 22% full. Why is so much increase in
>>> percentage usage?
>>
>> This is a accounting bug, it's already fixed in btrfs-progs-unstable=
 tree..
> I am using the latest btrfs-progs-unstable tree. I had cloned the git
> repository, I used the same updated repository. Is there any other
> repository than the one declared on Wiki Page?
> I used cloned repo from
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unsta=
ble.git

It's not accounting bug. I guess it's due to small file packing.
Please try using
-n option.

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
