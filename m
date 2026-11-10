Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794304457;
	b=hVta5fOnooVdL5/lF1HrRJJGRD9UgDz9gxhgzHOpXvTAuEeUFCVNLmCK16s/g6siYOj5
	 FuWHYISzLtkG9d/Etw5/6KB1b98DERqmp1OWaHb78FfZW/R3NbQVremiyxPIw6WOVoyy8
	 i1/c3jwxDenJ2TrtlZm27ycPBbPY+u/Kug7DbFL1gBwN0J3ag7YNhH9sap6cD4mu0+H6C
	 J7Em28R0aFvk4xhGNMvRwoCk8lfQj3ASzz0hYByjr9YYgn04eticbcGOOoptoshKdY7yg
	 IqxeGcs49rqk9YsIVfZqfd6+71UFVb4faOu9gtfeA4d2WP76AYyUTkf7zTL66zvxNng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794304457;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:Autocrypt:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=kBaqYCIIdsTzkPz0tRcd6R/kONSdbquqHZDhox3BQgw=;
	b=KKHCb8gMXGquO20RPL7Y4mFKHJ2OnyHPhVgEmQ1/PoNyAnrt/F4EKWS2QP6pbB7YRCc8
	 os8HcIfBbMKcoi0g2HXYepWWFbRjke/jiyZxlgQEzyNHsgYw+n2/a0DxDyeNkpb4CmUvV
	 BUCP8I1LMTHJOdzq66bMn01k67E5uEUd2QDOy9qfBgiBDECXMZh5aWe08MSuskOmKkmBB
	 IQgicNdBMYIv+azFg7iK1ZNva6tkxUeWvMxbJBQdyuc/gAtdYizzMDvf0YaPheRw3iiRP
	 XCYZbOgYgSadoroxZQgF4slvTsThgwbZnPJLEWXRiQrMgwtM6VKBbQQdUZpwYwdhadQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=OhTe6nsf;
	arc=none smtp.remote-ip=209.85.218.44
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF90F606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 09:54:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF90F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=OhTe6nsf
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c4d7d591607so265228866b.2
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 01:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794304455; x=1794909255; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kBaqYCIIdsTzkPz0tRcd6R/kONSdbquqHZDhox3BQgw=;
        b=OhTe6nsfO4Wp1Fxy2rsvZmDN0ZClSn0jcgg3y90fJUhgF4/HPIXggD1ec8tiBTVIPP
         Jm9ZqXISJ3VH/u4U87P1bfflGWO0RGkHxxs72LUAq/hWuiR4rzm/D4r7LBVdPyU2Y+R9
         lT35xg+WbtgZwVqHxNgZyDpnIhiURVOtvNFURpUrmkM+W1YPuA4o9b0t4rbsPDXyPHpJ
         evk/kHOw4pLqrrqfAONSKEA1xP6fDz6DXUoyITqdn7M6F9itXFTXBCp+c3RH2EB6hrQI
         8lEHBpzNnpT2fsnS0fDmFc1pOWw4koxDo1Gayf4L85v0Hah8drIgCL6TioHvgdf11NfQ
         hvjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794304455; x=1794909255;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kBaqYCIIdsTzkPz0tRcd6R/kONSdbquqHZDhox3BQgw=;
        b=sn1knXjIjOReOcZSX+wsEajnCN0NzqF938bLdLMDIIZvqWqqeAaiRfY9eFD/xF25fN
         mYvR7dY4n6AXG/EFWvHO4AYMI0ydO0hXz2NcClBvGe7dB+dn5MAx1waR81hQCXE/m0r5
         8HLt05JxLRSJ0SBMrWCLk1ai9RIcFRLLJUydZVgtxUVo0xo1FWX5XFgYO5ZS5mnSwVAY
         PryiGr1vkAliCShs+LQW4AyLscueFXqEMnbyJjBsxdKmlbaa1UYuRCjSqmh9kSxzxMkX
         3TlOZF+tP8XgXB4SiAOZwEhrnm+MhxW5gn2F34ctasJF7lWT2MN0pgGu6WD0FhXjGPWZ
         ceYg==
X-Gm-Message-State: APuU4Z9USyvIgiFzxmlAhx+B5n14/rYS2oQl98fVMjHqdML/bHgxGiv7
	aPj6vfp2ASHlG82moQjnKjeXHIivsfEp5QydXbMUTSfUBR29VYnisRdl1/d4mrIT1XI=
X-Gm-Gg: AYBFou11zwtENQbvzLq4IY+6Lr717N90JRGBZEFad2S8SzACrC+XfckdOP8QG58qtLf
	WdXcWXW3WyVzaV2OsNGCgP41voJcHGxUZLrOriIf3VWl7pAHYgwze59lC7vAy5Dtw4ddlSKw/5o
	rzo65dahZG6vH5REWNwD1GTmxp8RTEreWAgWj7Ja/w+0pdzNRRp/iTK6pd4NUQF2uTv96CXjRMp
	aw2va7qKIZxkjaGpexu5zlqKxJc3KXfZLu0zqqe5vuoBNIVfWNrpaPxbOx/nkrRSl2Qnrdpt0H9
	6vLCgmRdwWNkdXhTAE5kU5Vq+GFs+z5ZhjY2AMLhJzAPRDphMO0Hl3pglAJgIcr3ZxCl5mgd3Oy
	5OzEDVeFolEsRiZEPJ2NSOOtM0qT2wMpQwZhe2hw/4d6OKgWpsJj31O0ePlh3UumZ0PKKBmu7lh
	tM4CX+Y0lvVP51ZvOYrLX8QMAZEw4gOVwiocN2erh2gDfaBADxutTSXDg0YLZ2r6wJ1K2JDRnah
	j+VMnxwBsUnImUuJwsqrFnWI8z5SxOfjsToVGTLHArpL9a+BQGuRIRM+vHCb968rhrVR4IZTrCi
	mHbbVvtQSRPtH0Fs6uSg+w==
X-Received: by 2002:a17:907:3e91:b0:c2d:bae5:27d9 with SMTP id a640c23a62f3a-c5049654350mr163638466b.46.1794304454810;
        Tue, 10 Nov 2026 01:54:14 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1690f4733sm1161652a91.3.2026.11.10.01.54.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 01:54:13 -0800 (PST)
Message-ID: <102f3db1-958d-4990-816c-ca1b5181c8fb@suse.com>
Date: Tue, 10 Nov 2026 20:24:06 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: set write error flags before clearing writeback on
 failed buffered writes
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org
References: <93ad6002c98614b7a35c87b2792bce8dadb1e6b2.1794300081.git.wqu@suse.com>
 <CAL3q7H6JQk7X0Y-BtJmUHp+qhEMFYB=1=qxYkCihXVpcFGBPtg@mail.gmail.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ujyBQkUpLw5AAoJEMI9kfOh
 Jf6o8OIH/0mqW+TQM4m2x3hCsnK+oB4yJH1qnGvIhFF/Lhs48wI02sGh6/4aA0hkCDfd9LHQ
 +ci4FUepZ9y4VS01+oIExbg/8ytzGYTzLtb44jK2GBOBVSJkMiha6jp22XFt7WUkT/tvbreu
 WWdGsaJIRQaZChy7xsMI8lqQ2WdmluZJ4LT0wD3l/l6QU1ZseMGySebdY9sVOQEOJNV7Qj92
 /KOAFNmeZshV/qDI8Iw1RTs6TvLqCcqmlZLCmJkYSVhT1RonWRren8xIRcFEgMe004IDnt7V
 qdQhk/nhTS9x9MBAhMRl0TTE1VKDLvVALsud3iZLrmmtYvwPApzGJk052f0m28vOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ukKBQkUzDspAAoJEMI9kfOhJf6o
 SNsH/1ysUWOKmzY0rGS3ZdS61QgqMGhSWD/EJ4UiPw+xO4l4+GtX0fOAqxqsmBKqje3vyhBa
 Z5o/1Y+gNiN+E6RBcSz4b1TAd78sQ2bvT5DWOvBjeeVxHdiuQMIn4S8xk5ZpySBw5ifjoiuL
 0M33UVtJOzM8yfAeL+d/Rp4leJw72SutjkLyZTG/gJIp4pJGD/kFHn24OLL0IxEcO0gOekNZ
 os5e1R6jAJ2ILk7+MDnvU8wXHcCiVzuDhJLI1tih1uUIE50muHQJWbYuVBbdJeu8WlIDDssx
 UOCxLylNG3gDXV5MhLubPTOpp9OiFc/XC37nvkgEcrlmlOFBv4/NJCbECpo=
In-Reply-To: <CAL3q7H6JQk7X0Y-BtJmUHp+qhEMFYB=1=qxYkCihXVpcFGBPtg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/10 20:19, Filipe Manana 写道:
> On Tue, Nov 10, 2026 at 8:43 AM Qu Wenruo <wqu@suse.com> wrote:
>>
>> [BUG]
>> After commit f13e01b89daf ("btrfs: ensure fast fsync waits for ordered
>> extents after a write failure"), a failed COW write sets the inode's
>> BTRFS_INODE_COW_WRITE_ERROR flag.
>>
>> That flag makes the next fast fsync wait for ordered extents to complete,
>> so that it never logs the failed extents.
>>
>> However for buffered writes the flag can be set too late, and a fast
>> fsync can still log file extent items for the failed write.
>>
>> [CAUSE]
>> In end_bbio_data_write() the folios' writeback is cleared before the error
>> is recorded:
>>
>>   CPU0 (endio, failed buffered bio)  CPU1 (fast fsync)
>>   end_bbio_data_write()
>>   |-btrfs_folio_clear_writeback()
>>   | ^^^ wakes up the fsync           btrfs_sync_file()
>>   |                                  |-filemap_fdatawait_range()
>>   |                                  | ^^^ Returns after the writeback
>>   |                                  | finished
>>   |                                  |
>>   |                                  |-test_and_clear_bit(COW_WRITE_ERROR)
>>   |                                  | ^^^ Still 0, skips
>>   |                                  |     btrfs_wait_ordered_range()
>>   |                                  |
>>   |                                  \-btrfs_log_changed_extents()
>>   |                                    ^^^ logs the extent maps of the
>>   |                                        failed ordered extent
>>   |-mapping_set_error()
>>   \-btrfs_finish_ordered_extent()
>>     \-set_bit(COW_WRITE_ERROR)
>>       ^^^ Too late.
>>
>> A power loss after the log tree is persisted makes log replay point the
>> file to blocks that didn't receive its data.
>>
>> The mapping error is recorded late too, so the fsync can miss it as well.
>>
>> [FIX]
>> Record the error before anything a fast fsync can wait for.
>>
>> Introduce btrfs_ordered_extent_io_failed(), which marks the ordered
>> extent with BTRFS_ORDERED_IOERR, sets the mapping error and sets
>> BTRFS_INODE_COW_WRITE_ERROR for COW ordered extents.
>>
>> Call it from end_bbio_data_write() before clearing writeback, along with
>> mapping_set_error() with the real error code.
>>
>> Also call it from btrfs_finish_ordered_extent() before
>> can_finish_ordered_extent(), which sets BTRFS_ORDERED_IO_DONE, so that the
>> flag is also visible to anyone woken up by IO_DONE.
>> Compressed writes already finish the ordered extent before clearing
>> writeback and are not affected.
>>
>> Assisted-by: LLM (exposing the bug and coding)
>> Fixes: f13e01b89daf ("btrfs: ensure fast fsync waits for ordered extents after a write failure")
> 
> If you look at when that commit was made, we cleared the writeback bit
> from the folio after calling btrfs_finish_ordered_extent(), so all was
> fine.
> The commit that introduced the bug is:
> 
> a11d6912fdd9 ("btrfs: remove folio parameter from ordered io related functions")

And also 9d7db4100057 ("btrfs: move the
mapping_set_error() out of the loop in end_bbio_data_write()").

Pointed out by Sashiko.
> 
> And we already have an in-progress patch to solve this:
> 
> https://lore.kernel.org/linux-btrfs/20261103-b4-btrfs-data-integrity-v2-3-577dc2690061@toxicpanda.com/

Oh, thanks for pointing this out, unfortunately I only noticed your 
comment after sending out an unnecessary v2 patch...

Thanks,
Qu>
> 
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/extent_io.c    | 13 ++++++++++---
>>   fs/btrfs/ordered-data.c | 40 +++++++++++++++++++++++++++++-----------
>>   fs/btrfs/ordered-data.h |  1 +
>>   3 files changed, 40 insertions(+), 14 deletions(-)
>>
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index b2739838c646..53fced2756b5 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -545,6 +545,16 @@ static void end_bbio_data_write(struct btrfs_bio *bbio)
>>          u32 bio_size = 0;
>>
>>          ASSERT(!bio_flagged(bio, BIO_CLONED));
>> +
>> +       /*
>> +        * Record the error before clearing writeback, as a fast fsync waiting
>> +        * for writeback checks the error right after being woken up.
>> +        */
>> +       if (error) {
>> +               mapping_set_error(bbio->inode->vfs_inode.i_mapping, error);
>> +               btrfs_ordered_extent_io_failed(bbio->ordered);
>> +       }
>> +
>>          bio_for_each_folio_all(fi, bio) {
>>                  struct folio *folio = fi.folio;
>>                  u64 start = folio_pos(folio) + fi.offset;
>> @@ -554,9 +564,6 @@ static void end_bbio_data_write(struct btrfs_bio *bbio)
>>                  btrfs_folio_clear_writeback(fs_info, folio, start, len);
>>          }
>>
>> -       if (error)
>> -               mapping_set_error(bbio->inode->vfs_inode.i_mapping, error);
>> -
>>          btrfs_finish_ordered_extent(bbio->ordered, bbio->file_offset, bio_size, !error);
>>          bio_put(bio);
>>   }
>> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
>> index df74c75d6c29..0a851203e589 100644
>> --- a/fs/btrfs/ordered-data.c
>> +++ b/fs/btrfs/ordered-data.c
>> @@ -423,18 +423,18 @@ static void btrfs_queue_ordered_fn(struct btrfs_ordered_extent *ordered)
>>          btrfs_queue_work(fs_info->endio_write_workers, &ordered->work);
>>   }
>>
>> -void btrfs_finish_ordered_extent(struct btrfs_ordered_extent *ordered,
>> -                                u64 file_offset, u64 len, bool uptodate)
>> +/*
>> + * Record that the IO of @ordered failed.
>> + *
>> + * Must be called before anything a fast fsync can wait on is signaled: the
>> + * writeback bit of the folios for buffered IO, or BTRFS_ORDERED_IO_DONE for
>> + * direct IO. Otherwise the fast fsync can miss the error.
>> + */
>> +void btrfs_ordered_extent_io_failed(struct btrfs_ordered_extent *ordered)
>>   {
>>          struct btrfs_inode *inode = ordered->inode;
>> -       bool ret;
>>
>> -       trace_btrfs_finish_ordered_extent(inode, file_offset, len, uptodate);
>> -
>> -       spin_lock(&inode->ordered_tree_lock);
>> -       ret = can_finish_ordered_extent(ordered, file_offset, len,
>> -                                       uptodate);
>> -       spin_unlock(&inode->ordered_tree_lock);
>> +       btrfs_mark_ordered_extent_error(ordered);
>>
>>          /*
>>           * If this is a COW write it means we created new extent maps for the
>> @@ -442,7 +442,7 @@ void btrfs_finish_ordered_extent(struct btrfs_ordered_extent *ordered,
>>           * before submitting a bio or during IO.
>>           *
>>           * We have marked the ordered extent with BTRFS_ORDERED_IOERR, and we
>> -        * are queuing its completion below. During completion, at
>> +        * will queue its completion. During completion, at
>>           * btrfs_finish_one_ordered(), we will drop the extent maps for the
>>           * unwritten extents.
>>           *
>> @@ -464,8 +464,26 @@ void btrfs_finish_ordered_extent(struct btrfs_ordered_extent *ordered,
>>           * Set a flag in the inode so that the next fast fsync will wait for
>>           * ordered extents to complete before starting to log.
>>           */
>> -       if (!uptodate && !test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags))
>> +       if (!test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags))
>>                  set_bit(BTRFS_INODE_COW_WRITE_ERROR, &inode->runtime_flags);
>> +}
>> +
>> +void btrfs_finish_ordered_extent(struct btrfs_ordered_extent *ordered,
>> +                                u64 file_offset, u64 len, bool uptodate)
>> +{
>> +       struct btrfs_inode *inode = ordered->inode;
>> +       bool ret;
>> +
>> +       trace_btrfs_finish_ordered_extent(inode, file_offset, len, uptodate);
>> +
>> +       /* Must be done before BTRFS_ORDERED_IO_DONE can be set below. */
>> +       if (!uptodate)
>> +               btrfs_ordered_extent_io_failed(ordered);
>> +
>> +       spin_lock(&inode->ordered_tree_lock);
>> +       ret = can_finish_ordered_extent(ordered, file_offset, len,
>> +                                       uptodate);
>> +       spin_unlock(&inode->ordered_tree_lock);
>>
>>          if (ret)
>>                  btrfs_queue_ordered_fn(ordered);
>> diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
>> index 8d5d5ba1e02f..1bb8f9c8c472 100644
>> --- a/fs/btrfs/ordered-data.h
>> +++ b/fs/btrfs/ordered-data.h
>> @@ -226,6 +226,7 @@ bool btrfs_try_lock_ordered_range(struct btrfs_inode *inode, u64 start, u64 end,
>>   struct btrfs_ordered_extent *btrfs_split_ordered_extent(
>>                          struct btrfs_ordered_extent *ordered, u64 len);
>>   void btrfs_mark_ordered_extent_error(struct btrfs_ordered_extent *ordered);
>> +void btrfs_ordered_extent_io_failed(struct btrfs_ordered_extent *ordered);
>>   void btrfs_mark_ordered_extent_truncated(struct btrfs_ordered_extent *ordered,
>>                                           u64 truncate_len);
>>   int __init ordered_data_init(void);
>> --
>> 2.56.0
>>
>>

