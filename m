Received: from mail.burntcomma.com (unknown [62.3.69.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D06A3DEFE1
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 14:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.3.69.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776090685; cv=none; b=pAwxlcRYOdRfWtmMEsIocd7WEolGaub8fVms52kxLvhdYhnEDa5KvxsAgGA5y+V0TxWpVpMSB7iEioki75QkAnmXpGUxDa0wfukB6nga5Uc9ei5hxzSjJYhKM6/cf6BEzIap99i9/YiKuX+/UKwtSVd2cFY4AGFGldrm3pJnZo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776090685; c=relaxed/simple;
	bh=i5S+5IYQlasEpBHhfKZDeKuw+wtkzLp0cXqtIETSvYA=;
	h=Message-ID:Date:Mime-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lcaIpbEw5iwFxjClPDUJyAaYmkWLrzmmFxjEYNBfM8Dy/UH/gD3defw/oBGWMu3Ab4HK1/BldsMD4B248WPT0/PG57M57LJWw/RHrip3V5WLYehiqeScE9Gpe4beFLLQa+iwtTW/S4vyEJMMFt4e8GbAsqqZTBpZCx3lZyXKOqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=fail smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=yKOkLqqI; arc=none smtp.client-ip=62.3.69.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="yKOkLqqI"
Received: from [IPV6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2] (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
	 client-signature RSA-PSS (2048 bits) client-digest SHA256)
	(Client CN "hellas", Issuer "burntcomma.com" (verified OK))
	by mail.burntcomma.com (Postfix) with ESMTPS id 5BB1F31CC05;
	Mon, 13 Apr 2026 15:31:19 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1776090679;
	bh=2HYAXQVtTAnbMoEoUiU4TT2ENgLZ6kWR/zYg3iRQxBg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=yKOkLqqIG8GlU6Th5nIrvLcBAifw0H2rNjLUBnf49PVjhTq78IpKbH9f/nhKfB+zq
	 TVFRqiupA8l+6Q+j5BrNw6RieLJ5flktIbAtTzquh/FwxlAYp0dgQxTI16w35jaPlX
	 SAaAVTcQpkroSVMl9ObhFcz0HE2/dbkEMEzZaN8I=
Message-ID: <740e8d8f-4d43-433d-8479-f71d9c467439@harmstone.com>
Date: Mon, 13 Apr 2026 15:31:19 +0100
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [PATCH v2] btrfs: add BTRFS_IOC_GET_CSUMS ioctl
To: Daniel Vacek <neelx@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, boris@bur.io
References: <20260408174642.136962-1-mark@harmstone.com>
 <b0a7acec-73ce-4cc2-aecd-d0f686a36e4d@suse.com>
 <33a920c9-c876-45bb-b1aa-eed42472efc4@harmstone.com>
 <CAPjX3Fc9_sLKh6m_9zX5hDKpwZ8+msnzh12+PTkrQaCYvL5BmA@mail.gmail.com>
Content-Language: en-US
From: Mark Harmstone <mark@harmstone.com>
Autocrypt: addr=mark@harmstone.com; keydata=
 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
In-Reply-To: <CAPjX3Fc9_sLKh6m_9zX5hDKpwZ8+msnzh12+PTkrQaCYvL5BmA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 13/04/2026 3.12 pm, Daniel Vacek wrote:
> On Mon, 13 Apr 2026 at 15:14, Mark Harmstone <mark@harmstone.com> wrote:
>> On 09/04/2026 12.08 pm, Qu Wenruo wrote:
>>> 在 2026/4/9 03:16, Mark Harmstone 写道:
>>>> Add a new unprivileged BTRFS_IOC_GET_CSUMS ioctl, which can be used to
>>>> query the on-disk csums for a file.
>>>
>>> After some more discussion, now I understand why you want an
>>> unprivileged ioctl instead of splitting the workload into fiemap + csum
>>> tree search ioctl.
>>>
>>> You want to do extra permission checks, which is impossible for the csum
>>> tree search ioctl.
>>>
>>> And if we allow unprivileged csum tree search, it will expose all the
>>> data checksum to an attacker.
>>> The csum itself is not enough to re-construct the plaintext even for the
>>> weakest CRC32C.
>>>
>>> But it is still enough info to know other aspects of some data, e.g. if
>>> some blocks are all zero, or some two blocks are (possibly) the same etc.
>>>
>>> Not sure if you want to include some short words on this design decision
>>> though.
>>
>> That's correct. I'll make sure the description is clearer for v3.
>>
>> The reason arbitrary csums can't be returned to unprivileged users is
>> principally because it is a good indication that a known block is
>> somewhere on the system. An attack vector might be an unprivileged user
>> scanning the whole filesystem to see if a known vulnerable ELF file is
>> installed.
>>
>>>> This is done by userspace passing a struct btrfs_ioctl_get_csums_args to
>>>> the kernel, which details the offset and length we're interested in, and
>>>> a buffer for the kernel to write its results into. The kernel writes a
>>>> struct btrfs_ioctl_get_csums_entry into the buffer, followed by the
>>>> csums if available.
>>>>
>>>> If the extent is an uncompressed, non-nodatasum extent, the kernel sets
>>>> the entry type to BTRFS_GET_CSUMS_HAS_CSUMS and follows it with the
>>>> csums. If it is sparse, preallocated, or beyond the EOF, it sets the
>>>> type to BTRFS_GET_CSUMS_ZEROED - this is so userspace knows it can use
>>>> the precomputed hash of the zero sector.
>>>
>>> Well, for mkfs it's going to skip the range as a hole, which is even
>>> faster than using any precalculated csum.
>>>
>>> Although keeping the ZEROED flag may be useful for future users, I would
>>> not mind to keep this flag.
>>
>> I wrote this before you added your hole-scanning code to mkfs, but I'm
>> keeping this because it's cheap and it might be useful... and you have
>> to handle the case where userspace asks for the csum of a hole regardless.
>>
>> One non-mkfs use that springs to mind is that XORing all the csums of a
>> file together should give you a pretty fast ad-hoc checksum.
>>
>>>> Otherwise, it sets the type to
>>>> BTRFS_GET_CSUMS_NO_CSUMS.
>>>>
>>>> We do store the csums of compressed extents, but we deliberately don't
>>>> return them here: they're hashed over the compressed data, not the
>>>> uncompressed data that's returned to userspace.
>>>
>>> Consdiering we're already treating prealloc/hole with a dedicated ZEROED
>>> flag, just to keep things consistent, it may be better to provide a
>>> ENCODED flag, to indicate the range is either compressed or encrypted
>>> for the incoming encyrption feature.
>>>
>>> We still don't provide the csum, but just let the user space to know why.
>>
>> This is free, so there's no reason not to.
>>
>> At any rate, it ought to be erroring out if the encryption field is set
>> on the file extent. From the looks of things Daniel's current encryption
>> work is setting this.
>>
>> There might one day be a use case for returning the csums of an
>> encrypted extent, but as with compressed extents this shouldn't be done
>> by default. At least there would be a one-to-one mapping between file
>> blocks and encrypted sectors, so this could be done by extending this
>> interface.
> 
> I'd say there is no reason not to return the csums. Even for
> compressed or encrypted extents, you can flag them ENCODED and still
> return the csum (given the permission check). Userspace is free to
> ignore it.
> 
> Note that you can read/write the raw data with the
> BTRFS_IOC_ENCODED_{READ|WRITE} ioctl.

Thanks Daniel. My concern there is that this probably won't be what 
userspace wants, so you'll be doing a copy for no reason. I'll think 
I'll just keep it for a later flag, so we can add this later if and when 
we need it.

One thing I'm working on at the moment is "encoded reflinks", so you can 
mark uncompressed data as being part of a compressed extent or vice 
versa. If we extended this to encryption, this would be a use case for 
this ioctl: you would be able to do mkfs.btrfs --rootdir --reflink on an 
encrypted directory without needing to have loaded the key.

> Other than that it looks like a very nice speed-up.
> 
> --nX
> 
>>>> +#define GET_CSUMS_BUF_MAX    (16 * 1024 * 1024)
>>>
>>> SZ_16M.
>>>
>>> [...]
>>>>    long btrfs_ioctl(struct file *file, unsigned int
>>>>            cmd, unsigned long arg)
>>>>    {
>>>> @@ -5294,6 +5622,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>>>>    #endif
>>>>        case BTRFS_IOC_SUBVOL_SYNC_WAIT:
>>>>            return btrfs_ioctl_subvol_sync(fs_info, argp);
>>>> +    case BTRFS_IOC_GET_CSUMS:
>>>> +        return btrfs_ioctl_get_csums(file, argp);
>>>>    #ifdef CONFIG_BTRFS_EXPERIMENTAL
>>>>        case BTRFS_IOC_SHUTDOWN:
>>>>            return btrfs_ioctl_shutdown(fs_info, arg);
>>>> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
>>>> index 9165154a274d94..d079e8b67fd740 100644
>>>> --- a/include/uapi/linux/btrfs.h
>>>> +++ b/include/uapi/linux/btrfs.h
>>>> @@ -1100,6 +1100,25 @@ enum btrfs_err_code {
>>>>        BTRFS_ERROR_DEV_RAID1C4_MIN_NOT_MET,
>>>>    };
>>>> +/* Types for struct btrfs_ioctl_get_csums_entry::type */
>>>> +#define BTRFS_GET_CSUMS_HAS_CSUMS    0
>>>> +#define BTRFS_GET_CSUMS_ZEROED        1
>>>> +#define BTRFS_GET_CSUMS_NO_CSUMS    2
>>>> +
>>>> +struct btrfs_ioctl_get_csums_entry {
>>>> +    __u64 offset;        /* file offset of this range */
>>>> +    __u64 length;        /* length in bytes */
>>>> +    __u32 type;        /* BTRFS_GET_CSUMS_* type */
>>>> +    __u32 reserved;        /* padding, must be 0 */
>>>> +};
>>>> +
>>>> +struct btrfs_ioctl_get_csums_args {
>>>> +    __u64 offset;        /* in/out: file offset */
>>>> +    __u64 length;        /* in/out: range length */
>>>> +    __u64 buf_size;        /* in/out: buffer capacity / bytes written */
>>>> +    __u8 buf[];        /* out: entries + csum data */
>>>
>>> Maybe you want to push more explanation on the output buffer format.
>>>
>>> The resulted buffer would be something like the following example:
>>>
>>> Input:
>>>
>>>    inode has [0, 4K) hole, [4K, 12K) data, isize 12K.
>>>
>>>    args.offset = 0
>>>    args.length = 1M
>>>    args.buf_size = 1M
>>>
>>> Output:
>>>
>>>    args.offset = 0
>>>    args.length = 1M
>>>    args.buf_size = buf_size_out
>>>    buf:
>>>
>>>    | [0, 4K) ZEROED | [4K, 12K) HAS_CSUM | CSUM | [12K, 1M) ZEROED |
>>>    |<------------------------ buf_size_out ----------------------->|
>>>
>>> As it takes me some time to understand the output buffer format from the
>>> code, which is different from my initial impression.
>>
>> Yes, that's right.
>>
>>> Another thing is, it may be better to add a flag/version member to
>>> btrfs_ioctl_get_csums_args.
>>>
>>> If we need to add extra flags to entry->type, or utilize the reserved
>>> entry padding for something, or even introduce some new behavior to the
>>> output buffer format, we must have a way to tell the end users.
>>
>> No objections here, that sounds like a good idea. Thanks Qu. One obvious
>> future flag would be to return the csums of encrypted extents rather
>> than ignoring them, if there was a use case for this.
>>
>>> Otherwise looks good to me.
>>>
>>> Thanks,
>>> Qu
>>

