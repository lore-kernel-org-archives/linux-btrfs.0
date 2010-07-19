From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: Re: [BUG] btrfs hangup when we run the "sync" command
Date: Mon, 19 Jul 2010 14:46:17 +0800
Message-ID: <AANLkTinh0mzvpIl5i35q43Py-I1X9zYOe9RkpN3OFU4A@mail.gmail.com>
References: <4C3E7E1B.5000002@cn.fujitsu.com>
	<AANLkTinkuiT9tBiALkCIDMs9d9J9FT9sl9GEyRogq09S@mail.gmail.com>
	<4C3ECFBB.40006@cn.fujitsu.com>
	<20100715161213.GG8623@think>
	<4C43B0B2.1040507@cn.fujitsu.com>
	<4C43B1F6.6070601@oracle.com>
	<4C43EE02.8060306@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C43EE02.8060306@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 19, 2010 at 2:17 PM, Miao Xie <miaox@cn.fujitsu.com> wrote:
> On Mon, 19 Jul 2010 10:01:26 +0800, Yan, Zheng <zheng.yan@oracle.com>=
 wrote:
>> On 07/19/2010 09:56 AM, Miao Xie wrote:
>>> On Thu, 15 Jul 2010 12:12:13 -0400, Chris Mason <chris.mason@oracle=
=2Ecom> wrote:
>>>>>>> It seems that the btrfs doesn't support the sectorsize which is
>>>>>>> greater than the page size just like ext2/3/4, though we can us=
e
>>>>>>> mkfs.btrfs to make a filesystem with a big sectorsize. Am I rig=
ht?
>>>>>>>
>>>>>>> If yes, we must do more check in the mkfs.btrfs.
>>>>>>>
>>>>>>
>>>>>> yes, btrfs doesn't support the sectorsize> =A0PAGE_size.
>>>>>>
>>>>>
>>>>> So we must do more check in the mkfs.btrfs to avoid misuse, and I=
'll
>>>>> add some check of the sectorsize into the mkfs.btrfs.
>>>>
>>>> Yes, but this is fixed up with the raid code, we'll allow differen=
t page
>>>> sizes.
>>>
>>> Is the raid code that you said the initialization code for the bloc=
k devices?
>>> just like this:
>>>
>>> fs/btrfs/volumes.c:1430
>>> int btrfs_init_new_device(struct btrfs_root *root, char *device_pat=
h)
>>> {
>>> =A0 =A0 =A0[snip]
>>> =A0 =A0 =A0set_blocksize(device->bdev, 4096);
>>> =A0 =A0 =A0[snip]
>>> }
>>>
>>> If yes, it uses a hard-code value to initialize the blocksize of th=
e block device,
>>> not the blocksize of the btrfs, so the btrfs doesn't check the bloc=
ksize of the btrfs.
>>>
>> This is for btrfs super block, because size of btrfs super block is =
fixed.
>
> I don't know how this bug was fixed up. I think if the btrfs doesn't =
support
> the >PAGE_SIZE sectorsize, it should forbid mounting a filesystem wit=
h >PAGE_SIZE
> sectorsize. But in fact, we can mount.
>
> So I think this bug has not been fixed up or the fix is not so good.
>

This bug has been fixed up in Chris' raid56 tree.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
