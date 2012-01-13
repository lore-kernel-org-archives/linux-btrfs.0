From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: Bug(?): btrfs carries on working if part of a device disappears
Date: Fri, 13 Jan 2012 20:07:18 +0800
Message-ID: <4F101E76.5070200@cn.fujitsu.com>
References: <CAO=zWD+2D-qH-uLqdta6Yy_L2cE0ggCn7rMDUFz+w-9VMM=pQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Maik Zumstrull <maik@zumstrull.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAO=zWD+2D-qH-uLqdta6Yy_L2cE0ggCn7rMDUFz+w-9VMM=pQw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/06/2012 02:02 AM, Maik Zumstrull wrote:
> Hello list,
> 
> I hit a funny BIOS bug the other day where the BIOS suddenly sets a
> HPA on a random hard disk, leaving only the first 33 MB accessible.
> That disk had one device of a multi-device btrfs on it in my case.
> (With dm-crypt/LUKS in between, no partitioning or LVM.)
> 
> The reason I'm writing to you is that btrfs apparently didn't care at
> all. It didn't complain, and it certainly didn't consider "Uhm, maybe
> I should stop writing to a file system that mostly doesn't exist
> anymore." The only errors I saw in dmesg were from the lower block
> device level: someone trying to read or write beyond the end of a
> device. An error btrfs apparently didn't mind. It took me a while to
> figure out what had happened, during which time btrfsck and the btrfs
> kernel part worked together to pretty much totally trash the fs. (I'm
> still trying a few things, but I'm not hopeful. Hold the default
> backup rant, I can in fact recover anything that was on this from
> elsewhere, I think.)
> 
> So, I think during mount, btrfs should check the reported size of the
> block device, and if it's significantly smaller than fs metadata
> implies it must be, mount degraded or read-only or not at all. And
> mostly, complain. Loudly.
> 

I also notice this, when we "mkfs.btrfs" with a "-b fssize", if "fssize" is
larger than dev size, it will not complain and get "beyond the end" errors.

so maybe we limit the mkfs size:

diff --git a/mkfs.c b/mkfs.c
index e3ced19..3ac8525 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1282,6 +1282,8 @@ int main(int ac, char **av)
 		ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count, &mixed);
 		if (block_count == 0)
 			block_count = dev_block_count;
+		if (block_count > dev_block_count);
+			block_count = dev_block_count;
 	} else {
 		ac = 0;
 		file = av[optind++];

thanks,
liubo

> This was on Debian's linux-image-3.1.0-1-amd6 at version 3.1.6-1.
> Other ways this could happen than HPA are LVM or partitioning.
> 
> 
> Maik
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

