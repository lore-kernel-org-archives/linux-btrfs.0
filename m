Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6325A3DCDB0
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 14:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774449814; cv=none; b=eDaMJrTWMDB5scUM/2M00w10mZ5ThSudfDxjB8k68oXiBULrtbcCEzSTWG/dOBh48Cf3y2jsKwOviavglHQoq24pmHhrtN3IT4IIdueMm3caLAx+4b+T7VNn7YySvS0M6ttFafNd48jFDCu1GCDIJqx6a1pRLNwrjOP/wdIdfxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774449814; c=relaxed/simple;
	bh=FoohvXOkj8F7iGkYiRX8CJYBL3tOD3qZiC3ckxrWKME=;
	h=Message-ID:Date:Mime-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=MD1/VqS2QV9F3s0f9SZnzcD8LO7rIUac8b+OB51v7sm/JxjD/q4SFEi8AvLvqKplKr3B+uoUTkhjeM3QCbJDltMfeTsW8y/6VU5xs87VIMU64sNUFWjp2MfA/aE95/A7fkTyf9CbZbe7K+t0MDUhtM/ku3Ewna04Ey+LaVP6E8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=SULJQPPo; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="SULJQPPo"
Received: from [IPV6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2] (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
	 client-signature RSA-PSS (2048 bits) client-digest SHA256)
	(Client CN "hellas", Issuer "burntcomma.com" (verified OK))
	by mail.burntcomma.com (Postfix) with ESMTPS id 03E88314EBC;
	Wed, 25 Mar 2026 14:43:23 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1774449804;
	bh=t5hvnwPpVAPwUIYWQAEEJp6pSdBhnhPKA5dUv/09Kfo=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=SULJQPPoiRSRsl1DUYWoRholbxT2JgUg7QxZ9mI5AlWHl+ebdaxY9EQt4c2HzVHjS
	 ek+8L2WBG0YMjWcgnRvC4knG3S+1N/jbv966+c+EhFOpZaALWaVC02nbaPVQDJ/NDw
	 1Lmo0CvZNYLFuX96Sp5EAPvo3PwbHGyWI+Pw4faw=
Message-ID: <39496ce5-74c2-4300-ba39-032edace4cfe@harmstone.com>
Date: Wed, 25 Mar 2026 14:43:23 +0000
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [PATCH] btrfs: add BTRFS_IOC_GET_CSUMS ioctl
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <20260320125058.90053-1-mark@harmstone.com>
 <07cf5ebc-ac52-4fd9-82c5-404c0f4d6056@gmx.com>
 <3ad267b6-cc59-495f-b385-9b4b4686a473@gmx.com>
Content-Language: en-US
From: Mark Harmstone <mark@harmstone.com>
Autocrypt: addr=mark@harmstone.com; keydata=
 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
In-Reply-To: <3ad267b6-cc59-495f-b385-9b4b4686a473@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 25/03/2026 7.34 am, Qu Wenruo wrote:
> 
> 
> 在 2026/3/21 08:48, Qu Wenruo 写道:
>>
>>
>> 在 2026/3/20 23:20, Mark Harmstone 写道:
>>> Add a new unprivileged BTRFS_IOC_GET_CSUMS ioctl, which can be used to
>>> query the on-disk csums for a file.
>>>
>>> This is done by userspace passing a struct btrfs_ioctl_get_csums_args to
>>> the kernel, which details the offset and length we're interested in, and
>>> a buffer for the kernel to write its results into. The kernel writes a
>>> struct btrfs_ioctl_get_csums_entry into the buffer, followed by the
>>> csums if available.
>>>
>>> If the extent is an uncompressed, non-nodatasum extent, the kernel sets
>>> the entry type to BTRFS_GET_CSUMS_HAS_CSUMS and follows it with the
>>> csums. If it is sparse, preallocated, or beyond the EOF, it sets the
>>> type to BTRFS_GET_CSUMS_SPARSE - this is so userspace knows it can use
>>> the precomputed hash of the zero sector. Otherwise, it sets the type to
>>> BTRFS_GET_CSUMS_NO_CSUMS.
>>
>> I'm not sure if it's a good idea to put hole and preallocated range 
>> into the same BTRFS_GET_CSUMS_SPARSE.
>>
>> Although both means there is no csum, hole case means there is really 
>> no data extent, thus we should not create any extent instead of 
>> writing zero.

Thanks Qu.

"SPARSE" is probably a bad name for it. It probably should be "ZERO" or 
somesuch. The point is to tell userspace not to waste time calculating 
csums, but use the precomputed values because the data would be zero 
(for whatever reason).

>> For preallocated, indicating it has no CSUM can allow mkfs to 
>> distinguish hole and preallocated, thus change to zero writes to 
>> prealloc, which is faster and make the resulted fs more aligned to the 
>> source dir.
>>
>>
>> And for EOF checks, I think we don't need to bother that much, aka, 
>> just let it return the regular results.
>>
>> My assumption is, the mkfs shouldn't pass a range completely beyond 
>> the round_up(i_size), as non-reflink rootdir population would always 
>> read out the content of the inode from the host fs.
>> Thus we won't really read beyond the inode size.
> 
> After more investigation, I think we can put the hole/preallocation/ 
> compression detection into the user space.
> 
> The hole detection is already pending for merge, mostly through 
> SEEK_DATA/SEEK_HOLE flags of lseek():
> 
>   https://github.com/kdave/btrfs-progs/pull/1097
> 
> I'm planning to implement preallocation detection through fiemap, which 
> also allows us to detect compressed range and skip them for your case.
> 
> With all those features implemented in progs, we can further simplify 
> the get csum ioctl, to something more aligned to 
> btrfs_lookup_csums_bitmap().
> 
> We do not need to bother why there is no checksum for some ranges, that 
> will be handled by progs first, we only need to return all the checksums 
> found for the specified range.
> 
> And as an extra safenet, use some bitmap inthe ioctl structure to 
> indicate which ranges have checksum and which doesn't.
> 
> This will definitely simplify the ioctl as we only need to do csum tree 
> lookup, no need to bother anything in the subvolume tree.

Unfortunately this won't work. You have to explicitly filter out 
compressed extents, and identifying these requires checking the FS tree. 
The reason is that they may be "bookended", and you would leak 
information about other files if you returned the whole of the csums for 
the compressed extent. This is the reason why encoded read needs root.

> Thanks,
> Qu
> 
>>
>>>
>>> We do store the csums of compressed extents, but we deliberately don't
>>> return them here: they're hashed over the compressed data, not the
>>> uncompressed data that's returned to userspace.
>>
>> I agree with the skip of compressed extents, but I'd prefer to have a 
>> special flag to indicate that, other than NO_CSUMS.
>>
>> Or mkfs is unable to distinguish hole and compressed extents.

Compressed extents result in NO_CSUMS, a hole results in SPARSE.

>> [...]
>>> +/* Types for struct btrfs_ioctl_get_csums_entry::type */
>>> +#define BTRFS_GET_CSUMS_HAS_CSUMS    0
>>> +#define BTRFS_GET_CSUMS_SPARSE        1
>>> +#define BTRFS_GET_CSUMS_NO_CSUMS    2
>>> +
>>> +struct btrfs_ioctl_get_csums_entry {
>>> +    __u64 offset;        /* file offset of this range */
>>> +    __u64 length;        /* length in bytes */
>>> +    __u32 type;        /* BTRFS_GET_CSUMS_* type */
>>> +    __u32 reserved;        /* padding, must be 0 */
>>> +};
>>> +
>>> +struct btrfs_ioctl_get_csums_args {
>>> +    __u64 offset;        /* in/out: file offset */
>>> +    __u64 length;        /* in/out: range length */
>>> +    __u64 buf_size;        /* in/out: buffer capacity / bytes 
>>> written */
>>> +    __u8 buf[];        /* out: entries + csum data */
>>> +};
>>
>>  From the progs usage, it is always a single 
>> btrfs_ioctl_get_csums_entry at the beginning of buf[], then real 
>> buffer for csum, can we just combine both structures into one?
>>
>> Furthermore, since we only query one extent at one time, the offset/ 
>> length are more or less duplicated between args and entry structure.
>>
>> We can just save the length into the args without the need for entry 
>> members (except the type).
>>
>> Thanks,
>> Qu
>>
>>> +
>>>   /* Flags for IOC_SHUTDOWN, must match XFS_FSOP_GOING_FLAGS_* flags. */
>>>   #define BTRFS_SHUTDOWN_FLAGS_DEFAULT            0x0
>>>   #define BTRFS_SHUTDOWN_FLAGS_LOGFLUSH            0x1
>>> @@ -1226,6 +1245,8 @@ enum btrfs_err_code {
>>>                        struct btrfs_ioctl_encoded_io_args)
>>>   #define BTRFS_IOC_SUBVOL_SYNC_WAIT _IOW(BTRFS_IOCTL_MAGIC, 65, \
>>>                       struct btrfs_ioctl_subvol_wait)
>>> +#define BTRFS_IOC_GET_CSUMS _IOWR(BTRFS_IOCTL_MAGIC, 66, \
>>> +                  struct btrfs_ioctl_get_csums_args)
>>>   /* Shutdown ioctl should follow XFS's interfaces, thus not using 
>>> btrfs magic. */
>>>   #define BTRFS_IOC_SHUTDOWN    _IOR('X', 125, __u32)
>>
>>
> 
> 

