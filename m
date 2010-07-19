From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [BUG] btrfs hangup when we run the "sync" command
Date: Mon, 19 Jul 2010 16:29:08 +0800
Message-ID: <4C440CD4.8000009@cn.fujitsu.com>
References: <4C3E7E1B.5000002@cn.fujitsu.com>	<AANLkTinkuiT9tBiALkCIDMs9d9J9FT9sl9GEyRogq09S@mail.gmail.com>	<4C3ECFBB.40006@cn.fujitsu.com>	<20100715161213.GG8623@think>	<4C43B0B2.1040507@cn.fujitsu.com>	<4C43B1F6.6070601@oracle.com>	<4C43EE02.8060306@cn.fujitsu.com> <AANLkTinh0mzvpIl5i35q43Py-I1X9zYOe9RkpN3OFU4A@mail.gmail.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: "Yan, Zheng" <zheng.yan@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinh0mzvpIl5i35q43Py-I1X9zYOe9RkpN3OFU4A@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 19 Jul 2010 14:46:17 +0800, Yan, Zheng wrote:
>>>>>> So we must do more check in the mkfs.btrfs to avoid misuse, and I'll
>>>>>> add some check of the sectorsize into the mkfs.btrfs.
>>>>>
>>>>> Yes, but this is fixed up with the raid code, we'll allow different page
>>>>> sizes.
>>>>
>>>> Is the raid code that you said the initialization code for the block devices?
>>>> just like this:
>>>>
>>>> fs/btrfs/volumes.c:1430
>>>> int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
>>>> {
>>>>       [snip]
>>>>       set_blocksize(device->bdev, 4096);
>>>>       [snip]
>>>> }
>>>>
>>>> If yes, it uses a hard-code value to initialize the blocksize of the block device,
>>>> not the blocksize of the btrfs, so the btrfs doesn't check the blocksize of the btrfs.
>>>>
>>> This is for btrfs super block, because size of btrfs super block is fixed.
>>
>> I don't know how this bug was fixed up. I think if the btrfs doesn't support
>> the>PAGE_SIZE sectorsize, it should forbid mounting a filesystem with>PAGE_SIZE
>> sectorsize. But in fact, we can mount.
>>
>> So I think this bug has not been fixed up or the fix is not so good.
>>
>
> This bug has been fixed up in Chris' raid56 tree.

I see, thanks!

BTW: could you tell us the URL of Chris' raid56 tree? I just find the raid56 tree
      that is managed by David Woodhouse.
      http://git.infradead.org/users/dwmw2/btrfs-raid56.git

Regards
Miao Xie
