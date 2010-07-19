From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [BUG] btrfs hangup when we run the "sync" command
Date: Mon, 19 Jul 2010 09:56:02 +0800
Message-ID: <4C43B0B2.1040507@cn.fujitsu.com>
References: <4C3E7E1B.5000002@cn.fujitsu.com> <AANLkTinkuiT9tBiALkCIDMs9d9J9FT9sl9GEyRogq09S@mail.gmail.com> <4C3ECFBB.40006@cn.fujitsu.com> <20100715161213.GG8623@think>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	"Yan, Zheng" <zheng.yan@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100715161213.GG8623@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 15 Jul 2010 12:12:13 -0400, Chris Mason <chris.mason@oracle.com> wrote:
>>>> It seems that the btrfs doesn't support the sectorsize which is
>>>> greater than the page size just like ext2/3/4, though we can use
>>>> mkfs.btrfs to make a filesystem with a big sectorsize. Am I right?
>>>>
>>>> If yes, we must do more check in the mkfs.btrfs.
>>>>
>>>
>>> yes, btrfs doesn't support the sectorsize>  PAGE_size.
>>>
>>
>> So we must do more check in the mkfs.btrfs to avoid misuse, and I'll
>> add some check of the sectorsize into the mkfs.btrfs.
> 
> Yes, but this is fixed up with the raid code, we'll allow different page
> sizes.

Is the raid code that you said the initialization code for the block devices?
just like this:

fs/btrfs/volumes.c:1430
int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
{
	[snip]
	set_blocksize(device->bdev, 4096);
	[snip]
}

If yes, it uses a hard-code value to initialize the blocksize of the block device,
not the blocksize of the btrfs, so the btrfs doesn't check the blocksize of the btrfs.

Thanks
Miao Xie

