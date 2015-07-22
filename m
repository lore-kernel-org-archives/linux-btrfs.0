Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38096 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754195AbbGVCBr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jul 2015 22:01:47 -0400
Subject: Re: Can't mount btrfs volume on rbd
To: Steve Dainard <sdainard@spd1.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
References: <CAEMJtDs=U5+YO9sbVvjxLthdxp6JvZO=07EMhcU5Smif_1m5QQ@mail.gmail.com>
 <557A890D.8080306@cn.fujitsu.com>
 <CAEMJtDu2zZJc-dg9opj0xHaKyeL78H0ppivb8mJFhChJ4J63uA@mail.gmail.com>
 <557E877E.2060704@cn.fujitsu.com>
 <CAEMJtDusywPEnDcNcMvvFKQsuZyTmSMXXgJT=eBZX1F+R8RM8w@mail.gmail.com>
 <557F7B82.2060203@cn.fujitsu.com>
 <CAEMJtDv1Tm7-O2mU03kZhPDkaSj7nVi+VAZVhPfh7BN8AuF2Bg@mail.gmail.com>
 <55A46473.8070106@cn.fujitsu.com> <55AE04EF.6040807@cn.fujitsu.com>
 <55AE29DA.4050201@gmail.com>
 <CAEMJtDuaOYPomha_VbTah521BZTYzmrg2D5tk6N4rd1Y8UPaog@mail.gmail.com>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55AEF984.9080706@cn.fujitsu.com>
Date: Wed, 22 Jul 2015 10:01:40 +0800
MIME-Version: 1.0
In-Reply-To: <CAEMJtDuaOYPomha_VbTah521BZTYzmrg2D5tk6N4rd1Y8UPaog@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Steve Dainard wrote on 2015/07/21 14:07 -0700:
> On Tue, Jul 21, 2015 at 4:15 AM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2015-07-21 04:38, Qu Wenruo wrote:
>>>
>>> Hi Steve,
>>>
>>> I checked your binary dump.
>>>
>>> Previously I was too focused on the assert error, but ignored some even
>>> larger bug...
>>>
>>> As for the btrfs-debug-tree output, subvol 257 and 5 are completely
>>> corrupted.
>>> Subvol 257 seems to contains a new tree root, and 5 seems to contains a
>>> new device tree.
>>>
>>> ------
>>> fs tree key (FS_TREE ROOT_ITEM 0)
>>> leaf 29409280 items 8 free space 15707 generation 9 owner 4
>>> fs uuid 1bb22a03-bc25-466f-b078-c66c6f6a6d28
>>> chunk uuid 11cca6df-e850-45d7-a928-cdff82c5f295
>>>           item 0 key (0 DEV_STATS 1) itemoff 16243 itemsize 40
>>>                   device stats
>>>           item 1 key (1 DEV_EXTENT 0) itemoff 16195 itemsize 48
>>>                   dev extent chunk_tree 3
>>>                   chunk objectid 256 chunk offset 0 length 4194304
>>>           item 2 key (1 DEV_EXTENT 4194304) itemoff 16147 itemsize 48
>>>                   dev extent chunk_tree 3
>>>                   chunk objectid 256 chunk offset 4194304 length 8388608
>>>           item 3 key (1 DEV_EXTENT 12582912) itemoff 16099 itemsize 48
>>>                   dev extent chunk_tree 3
>>> ......
>>> # DEV_EXTENT should never occur in fs tree. It should only occurs in
>>> # dev tree
>>>
>>> file tree key (257 ROOT_ITEM 0)
>>> leaf 29376512 items 13 free space 12844 generation 9 owner 1
>>> fs uuid 1bb22a03-bc25-466f-b078-c66c6f6a6d28
>>> chunk uuid 11cca6df-e850-45d7-a928-cdff82c5f295
>>>           item 0 key (EXTENT_TREE ROOT_ITEM 0) itemoff 15844 itemsize 439
>>>                   root data bytenr 29392896 level 0 dirid 0 refs 1 gen 9
>>>                   uuid 00000000-0000-0000-0000-000000000000
>>>           item 1 key (DEV_TREE ROOT_ITEM 0) itemoff 15405 itemsize 439
>>>                   root data bytenr 29409280 level 0 dirid 0 refs 1 gen 9
>>>                   uuid 00000000-0000-0000-0000-000000000000
>>>           item 2 key (FS_TREE INODE_REF 6) itemoff 15388 itemsize 17
>>>                   inode ref index 0 namelen 7 name: default
>>>           item 3 key (FS_TREE ROOT_ITEM 0) itemoff 14949 itemsize 439
>>>                   root data bytenr 29360128 level 0 dirid 256 refs 1 gen 4
>>>                   uuid 00000000-0000-0000-0000-000000000000
>>>           item 4 key (ROOT_TREE_DIR INODE_ITEM 0) itemoff 14789 itemsize
>>> 160
>>>                   inode generation 3 transid 0 size 0 nbytes 16384
>>>                   block group 0 mode 40755 links 1 uid 0 gid 0
>>>                   rdev 0 flags 0x0
>>> # These things are only in tree root.
>>> ------
>>>
>>> So the problem is, the kernel you use has some bug (btrfs or rbd
>>> related), causing the btrfs write wrong tree blocks into existing tree
>>> blocks.
>>>
>>> For such case, btrfsck won't be able to fix the critical error.
>>> And I didn't even have an idea to fix the assert to change it into a
>>> normal error. As it's corrupting the whole structure of btrfs...
>>>
>>> I can't even recall such critical btrfs bug...
>>>
>>>
>>> Not familiar with rbd, but will it allow a block device to be mounted on
>>> different systems?
>>>
>>> Like exporting a device A to system B and system C, and both system B
>>> and system C mounting device A at the same time as btrfs?
>>>
>> Yes, it's a distributed SAN type system built on top of Ceph.  It does allow
>> having multiple systems mount the device.
>
> This is accurate, but its a configured setting with the default being
> not shareable. The host which has mapped the block device should have
> a lock on it, so if another host attempts to map the same block device
> it should error out.
>
> The first time I had this occur was when it appeared pacemaker (HA
> daemon) couldn't fence one of two nodes, and somehow bypassed the ceph
> locking mechanism, mapping/mounting the block device on both nodes at
> the same time which would account for corruption.
>
> The last time this occurred (which is where the image you've analysed
> came from) pacemaker was not involved, and only one node was
> mapping/mounting the block device.
>
>>
>> Ideally, we really should put in some kind of protection against multiple
>> mounts (this would be a significant selling point of BTRFS in my opinion, as
>> the only other Linux native FS that has this is ext4), and make it _very_
>> obvious that mounting a BTRFS filesystem on multiple nodes concurrently
>> _WILL_ result in pretty much irreparable corruption.
>>
>
>
> I don't know if this has any bearing on the failure case, but the
> filesystem that I sent an image of was only ever created, subvol
> created, and mounted/unmounted several times. There was never any data
> written to that mount point.
>
Subvol creation and rw mount is enough to trigger 2~3 transaction with 
DATA written into btrfs.
As the first rw mount will create free space cache, which is counted as 
data.

But without multiple mount instants, I really can't consider another 
method to destroy btrfs so badly but with all csum OK...

Thanks,
Qu
