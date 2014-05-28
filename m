Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:32174 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753884AbaE1Bi3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 May 2014 21:38:29 -0400
Message-ID: <53853D3D.8020105@cn.fujitsu.com>
Date: Wed, 28 May 2014 09:34:53 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-progs: fsck: add an option to check data csums
References: <1399512409-661-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <20140516154045.GZ6917@twin.jikos.cz>
In-Reply-To: <20140516154045.GZ6917@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/16/2014 11:40 PM, David Sterba wrote:
> On Thu, May 08, 2014 at 09:26:49AM +0800, Wang Shilong wrote:
>> This patch adds an option '--check-data-csum' to verify data csums.
>> fsck won't check data csums unless users specify this option explictly.
> Nice.
>
>> +static int read_extent_data(struct btrfs_root *root, char *data,
>> +			u64 logical, u64 len, int mirror)
>> +{
>> +		if (read_len > root->sectorsize)
>> +			read_len = root->sectorsize;
>> +		if (read_len > bytes_left)
>> +			read_len = bytes_left;
>> +
>> +		ret = pread64(device->fd, data + offset, read_len,
>> +			      multi->stripes[0].physical);
> You can od kfree(multi) here and make the error/exit block simpler.
>
> 		kfree(multi);
> 		multi = NULL;
>
>> +		if (ret != read_len)
> 			ret = -EIO;
>
>> +			goto error;
>> +		offset += read_len;
>> +		bytes_left -= read_len;
>> +		kfree(multi);
>> +		multi = NULL;
>> +	}
>> +	return 0;
> 	return ret;
>
> Remove the rest.
>
>> +error:
>> +	kfree(multi);
>> +	return -EIO;
>> +}
>> +
>> +static int check_extent_csums(struct btrfs_root *root, u64 bytenr,
>> +			u64 num_bytes, unsigned long leaf_offset,
>> +			struct extent_buffer *eb) {
>> +
>> +	u64 offset = 0;
>> +	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
>> +	char *data;
>> +	u32 crc;
>> +	unsigned long tmp;
>> +	char result[csum_size];
>> +	char out[csum_size];
> A local variable of dynamic size, though we know it will not be larger
> than BTRFS_CSUM_SIZE. Please use that.
>
> csum_size should be validated during superblock read, so we can assume
> it's correct at this point.
>
>> +	int ret = 0;
>> +	__s64 cmp;
> This is used as a return value of memcmp, but both kernel and userspace
> libraries use simple int which is IMO enough.
>
>> +	int mirror;
>> +	int num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
>> +				bytenr, num_bytes);
>> +
>> +	BUG_ON(num_bytes % root->sectorsize);
> 	Can you do this check in the caller and avoid a BUG_ON here?
>
>> +	data = malloc(root->sectorsize);
>> +	if (!data)
>> +		return -ENOMEM;
>> +
>> +	while (offset < num_bytes) {
>> +		mirror = 0;
>> +again:
>> +		ret = read_extent_data(root, data, bytenr + offset,
>> +				root->sectorsize, mirror);
>> +		if (ret)
>> +			goto out;
>> +
>> +		crc = ~(u32)0;
>> +		crc = btrfs_csum_data(NULL, (char *)data, crc,
>> +				      root->sectorsize);
>> +		btrfs_csum_final(crc, result);
>> +
>> +		tmp = leaf_offset + offset / root->sectorsize * csum_size;
>> +		read_extent_buffer(eb, out, tmp, csum_size);
>> +		cmp = memcmp(out, result, csum_size);
>> +		if (cmp) {
>> +			fprintf(stderr, "mirror: %d range bytenr: %llu, len: %d checksum mismatch\n",
>> +				mirror, bytenr + offset, root->sectorsize);
> It has proved useful to print the checksums here, please enhance the
> output.
>
>> +			if (mirror < num_copies - 1) {
>> +				mirror += 1;
> 				mirror++;
>
>> +				goto again;
>> +			}
>> +		}
>> +		offset += root->sectorsize;
>> +	}
>> +out:
>> +	free(data);
>> +	return ret;
>> +}
>> +
>>   static int check_extent_exists(struct btrfs_root *root, u64 bytenr,
>>   			       u64 num_bytes)
>>   {
>> @@ -6678,6 +6790,7 @@ const char * const cmd_check_usage[] = {
>>   	"--repair                    try to repair the filesystem",
>>   	"--init-csum-tree            create a new CRC tree",
>>   	"--init-extent-tree          create a new extent tree",
>> +	"--check-data-csum           check data csums",
> The help text is not very useful, just repeats the option name without
> the dashes. Something like "verify checkums of data blocks" looks more
> readable to me.
Sorry for late reply, i will address your comments, and send a v2 later.
> .
>

