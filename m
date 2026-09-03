Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450B9372EF7
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 05:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788413063; cv=none; b=MnRtN9fB1tzd4ut2TknLoVA+p8WCbfm/JX9h3hutckFolbx2ZOb6pS35E/08MEpzT5BlGB1T+1Rhwc2WKEvwX8TVLkxQ0rPFgflhTurOHRwcDo0G/wki0jCy/w5u4qGphhhtXCiPUyGtMnoJ1FDK15eadz8u03fkDrGvSZLlGLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788413063; c=relaxed/simple;
	bh=NvAjugQ2xUXroQJD6coB/kClXj+RyNPk6rFYD/zNmRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FSWHNamggl/mK4qXTh66u9kgH2/D9OWldQr4q1JQxc2bPMMCzoD+9jow4f2XkJGrWdXCvBdYKHzw6mIwTZOiXBrV1ANSqpt7HLO+0Jw3TxlhD0ZlTeltASI/BgRYRrQ8QPw7fliDW6yNjlZouPUWT3jGok3LnYQeYUjUB44fHJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=M7d4TN9s; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="M7d4TN9s"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4980fe6b3beso4346715e9.0
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Sep 2026 22:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788413058; x=1789017858; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MEAp/mPtMVTScE8SJ/kXLR3N/wyYMltR65VcG1rtPU0=;
        b=M7d4TN9s1J6YDleJC//Z7o1WG3moDGixY//1Vcs62e8XDB0PQREH9LOzv5waS18Ycm
         1WWSXfi4nTp7QepF2s/P5i4GoCSdNCxj9lTV8FlFMJd7M76pqqp/U5pEYhe10coZSaXU
         ppylOyKuZAuAoVRCxHIcgsq0rysXjJZTWkOIYK6dAGLEKJeffKTHDnTLcp8ev5rY+QH9
         c9IX30+/KGlAFzAYPFC7gbJlCtFW2yFSVlMo/9CVaGB5ZDePQVHP2PrhHXo3KbI22rdF
         geTvUA165nn//plPr0xkYsQsGUb9qytkIaF3UAFv2pCGGum50kZGl+Qlu8HhayiHUAgN
         yukw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788413058; x=1789017858;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MEAp/mPtMVTScE8SJ/kXLR3N/wyYMltR65VcG1rtPU0=;
        b=JFvuxHyl9p3RCVFcYR7G4z57zl0mEjnAySFA1VsFjdko6F2khB37J432NHK3IqHC5W
         CryzSHLw8ZCXbPWjnKWOXPW8BLn7vPHPw5THbeSV9CFP3ipKV7QWcdsi0nuDMQ+MxvwH
         pwr9SwlLYhdt6xA3JHc7oHmZmVRrti9EZOKwOe+HXS1qQ2jNuQRQnQerqh6ClmCwNtOb
         qIlaDehtdGb4eu6bdXX1qNbKHc7ruhMcNGILuSwPWKWGgfyMEUI/6WnukoMDF3MZ2gdN
         HllTQI0jPr7vv6eQ0iNp+djZbqEDzH/M6iKUQt09uDXZ0OrZ5AFQoUboVNTwhbUidU7X
         zX4w==
X-Gm-Message-State: AFuF++kAqH6OlWFpS7w5JfE45IpSrx4NIUPwZjFYV1pS8VPodmEu6cVa
	lYXyc45BgOnWOtt9xiaU6ONwdc3oLS2wGQtbO4bNa9pjGLEgnfcbifApFfdE3xkyKX+B1Ef95hC
	MS4mRYuEL7Q==
X-Gm-Gg: AYBFou1B1+RmxDFOX/NYimnV5dEnPK0yY+5yiETQz8UN6guw862YFYLRGsKc783hCOS
	kWF7ptoakqUqaUkcPUfBpb0qS4E2YTtgQcsWp5ULASVpLEYGXDgBVIb2pVNz4nHShzOjZ9aBT4K
	ei03sK+D9lE5SZYlv6+eVK5CXFoIx8R7NAIr0BWLDxwA2ewawF8b+dLzKA1plIJjmMTWpiXcBiY
	T4ou60/L26RFP/b9uv5vAsW+RjuEtSKlbQV/7/oxXFBV+Y7S/wUPm3Unjg9nP85fko7Vn5s7Vqg
	EpFMj5tdgD/BXt9h5+Z8LJmBkToj2vTpv4m3qrCJJMfCOkXcq7LfYdivXmH107VSJ+OOy88/fwh
	Vwgxt1VH23+c2EiXZzJ1ejIzwNdLp2pNT5CBSl2lZfsevL02f670c2H+bRh8W83gkt7EEEGczny
	pJdOoETUpJfTVVqpZWGIoWDNiG61t3IxMEejSgK2Bp5y1pE5JMVDDy
X-Received: by 2002:a05:600c:214e:b0:49c:e795:9e73 with SMTP id 5b1f17b1804b1-49cee5db33cmr39732975e9.6.1788413057784;
        Wed, 02 Sep 2026 22:24:17 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc43d2448a1sm388448a12.4.2026.09.02.22.24.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2026 22:24:16 -0700 (PDT)
Message-ID: <a8a47490-1a67-4765-a713-1c01b8d3d8d8@suse.com>
Date: Thu, 3 Sep 2026 14:54:12 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/7] btrfs: introduce btrfs_bio::async_csum
To: Daniel Vacek <neelx@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <cover.1761715649.git.wqu@suse.com>
 <2b4ff4103f157ffd2d7206a413246990b3ef2746.1761715650.git.wqu@suse.com>
 <CAPjX3FfrPcXGPur5RNtGtDzMMNMNp735v9vKaO-KxFHn0TqvPQ@mail.gmail.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <CAPjX3FfrPcXGPur5RNtGtDzMMNMNp735v9vKaO-KxFHn0TqvPQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/3 14:37, Daniel Vacek 写道:
> On Wed, 29 Oct 2025 at 06:43, Qu Wenruo <wqu@suse.com> wrote:
>> [ENHANCEMENT]
>> Btrfs currently calculate its data checksum then submit the bio.
>>
>> But after commit 968f19c5b1b7 ("btrfs: always fallback to buffered write
>> if the inode requires checksum"), any writes with data checksum will
>> fallback to buffered IO, meaning the content will not change during
>> writeback.
>>
>> This means we're safe to calculate the data checksum and submit the bio
>> in parallel, and only need the following new behaviors:
>>
>> - Wait the csum generation to finish before calling btrfs_bio::end_io()
>>    Or we can lead to use-after-free for the csum generation worker.
>>
>> - Save the current bi_iter for csum_one_bio()
>>    As the submission part can advance btrfs_bio::bio.bi_iter, if not
>>    saved csum_one_bio() may got an empty bi_iter and do not generate any
>>    checksum.
>>
>>    Unfortunately this means we have to increase the size of btrfs_bio for
>>    16 bytes.
>>
>> As usual, such new feature is hidden behind the experimental flag.
>>
>> [THEORETIC ANALYZE]
>> Consider the following theoretic hardware performance, which should be
>> more or less close to modern mainstream hardware:
>>
>>          Memory bandwidth:       50GiB/s
>>          CRC32C bandwidth:       45GiB/s
>>          SSD bandwidth:          8GiB/s
>>
>> Then btrfs write bandwidth with data checksum before the patch would be
>>
>>          1 / ( 1 / 50 + 1 / 45 + 1 / 8) = 5.98 GiB/s
>>
>> After the patch, the bandwidth would be:
>>
>>          1 / ( 1 / 50 + max( 1 / 45 + 1 / 8)) = 6.90 GiB/s
>>
>> The difference would be 15.32 % improvement.
>>
>> [REAL WORLD BENCHMARK]
>> I'm using a Zen5 (HX 370) as the host, the VM has 4GiB memory, 10 vCPUs, the
>> storage is backed by a PCIE gen3 x4 NVME SSD.
>>
>> The test is a direct IO write, with 1MiB block size, write 7GiB data
>> into a btrfs mount with data checksum. Thus the direct write will fallback
>> to buffered one:
>>
>> Vanilla Datasum:        1619.97 GiB/s
>> Patched Datasum:        1792.26 GiB/s
>> Diff                    +10.6 %
>>
>> In my case, the bottleneck is the storage, thus the improvement is not
>> reaching the theoretic one, but still some observable improvement.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/bio.c       | 21 +++++++++++----
>>   fs/btrfs/bio.h       |  7 +++++
>>   fs/btrfs/file-item.c | 64 +++++++++++++++++++++++++++++++-------------
>>   fs/btrfs/file-item.h |  2 +-
>>   4 files changed, 69 insertions(+), 25 deletions(-)
>>
>> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
>> index 5a5f23332c2e..8af2b68c2d53 100644
>> --- a/fs/btrfs/bio.c
>> +++ b/fs/btrfs/bio.c
>> @@ -105,6 +105,9 @@ void btrfs_bio_end_io(struct btrfs_bio *bbio, blk_status_t status)
>>          /* Make sure we're already in task context. */
>>          ASSERT(in_task());
>>
>> +       if (bbio->async_csum)
>> +               wait_for_completion(&bbio->csum_done);
>> +
>>          bbio->bio.bi_status = status;
>>          if (bbio->bio.bi_pool == &btrfs_clone_bioset) {
>>                  struct btrfs_bio *orig_bbio = bbio->private;
>> @@ -538,7 +541,11 @@ static int btrfs_bio_csum(struct btrfs_bio *bbio)
>>   {
>>          if (bbio->bio.bi_opf & REQ_META)
>>                  return btree_csum_one_bio(bbio);
>> -       return btrfs_csum_one_bio(bbio);
>> +#ifdef CONFIG_BTRFS_EXPERIMENTAL
>> +       return btrfs_csum_one_bio(bbio, true);
>> +#else
>> +       return btrfs_csum_one_bio(bbio, false);
>> +#endif
> 
> Btw, what are your plans with async csums, Qu? You marked it
> experimental here, but I don't really see any reason to limit it this
> way. Shall we just go live?

Oh, thanks for reminding me about this.

Too many pending features make me forget that async csum is still 
experimental.

I'll send out a patch enabling it soon.

Thanks,
Qu

> 
> --nX
> 
>>   }
>>
>>   /*
>> @@ -617,10 +624,14 @@ static bool should_async_write(struct btrfs_bio *bbio)
>>          struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
>>          enum btrfs_offload_csum_mode csum_mode = READ_ONCE(fs_devices->offload_csum_mode);
>>
>> -       if (csum_mode == BTRFS_OFFLOAD_CSUM_FORCE_OFF)
>> -               return false;
>> -
>> -       auto_csum_mode = (csum_mode == BTRFS_OFFLOAD_CSUM_AUTO);
>> +       if (csum_mode == BTRFS_OFFLOAD_CSUM_FORCE_ON)
>> +               return true;
>> +       /*
>> +        * Write bios will calculate checksum and submit bio at the same time.
>> +        * Unless explicitly required don't offload serial csum calculate and bio
>> +        * submit into a workqueue.
>> +        */
>> +       return false;
>>   #endif
>>
>>          /* Submit synchronously if the checksum implementation is fast. */
>> diff --git a/fs/btrfs/bio.h b/fs/btrfs/bio.h
>> index 5d20f959e12d..deaeea3becf4 100644
>> --- a/fs/btrfs/bio.h
>> +++ b/fs/btrfs/bio.h
>> @@ -56,6 +56,9 @@ struct btrfs_bio {
>>                  struct {
>>                          struct btrfs_ordered_extent *ordered;
>>                          struct btrfs_ordered_sum *sums;
>> +                       struct work_struct csum_work;
>> +                       struct completion csum_done;
>> +                       struct bvec_iter csum_saved_iter;
>>                          u64 orig_physical;
>>                  };
>>
>> @@ -83,6 +86,10 @@ struct btrfs_bio {
>>           * scrub bios.
>>           */
>>          bool is_scrub;
>> +
>> +       /* Whether the csum generation for data write is async. */
>> +       bool async_csum;
>> +
>>          /*
>>           * This member must come last, bio_alloc_bioset will allocate enough
>>           * bytes for entire btrfs_bio but relies on bio being last.
>> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
>> index a42e6d54e7cd..4b7c40f05e8f 100644
>> --- a/fs/btrfs/file-item.c
>> +++ b/fs/btrfs/file-item.c
>> @@ -18,6 +18,7 @@
>>   #include "fs.h"
>>   #include "accessors.h"
>>   #include "file-item.h"
>> +#include "volumes.h"
>>
>>   #define __MAX_CSUM_ITEMS(r, size) ((unsigned long)(((BTRFS_LEAF_DATA_SIZE(r) - \
>>                                     sizeof(struct btrfs_item) * 2) / \
>> @@ -764,21 +765,46 @@ int btrfs_lookup_csums_bitmap(struct btrfs_root *root, struct btrfs_path *path,
>>          return ret;
>>   }
>>
>> -/*
>> - * Calculate checksums of the data contained inside a bio.
>> - */
>> -int btrfs_csum_one_bio(struct btrfs_bio *bbio)
>> +static void csum_one_bio(struct btrfs_bio *bbio, struct bvec_iter *src)
>>   {
>> -       struct btrfs_ordered_extent *ordered = bbio->ordered;
>>          struct btrfs_inode *inode = bbio->inode;
>>          struct btrfs_fs_info *fs_info = inode->root->fs_info;
>>          SHASH_DESC_ON_STACK(shash, fs_info->csum_shash);
>>          struct bio *bio = &bbio->bio;
>> -       struct btrfs_ordered_sum *sums;
>> -       struct bvec_iter iter = bio->bi_iter;
>> +       struct btrfs_ordered_sum *sums = bbio->sums;
>> +       struct bvec_iter iter = *src;
>>          phys_addr_t paddr;
>>          const u32 blocksize = fs_info->sectorsize;
>> -       int index;
>> +       int index = 0;
>> +
>> +       shash->tfm = fs_info->csum_shash;
>> +
>> +       btrfs_bio_for_each_block(paddr, bio, &iter, blocksize) {
>> +               btrfs_calculate_block_csum(fs_info, paddr, sums->sums + index);
>> +               index += fs_info->csum_size;
>> +       }
>> +}
>> +
>> +static void csum_one_bio_work(struct work_struct *work)
>> +{
>> +       struct btrfs_bio *bbio = container_of(work, struct btrfs_bio, csum_work);
>> +
>> +       ASSERT(btrfs_op(&bbio->bio) == BTRFS_MAP_WRITE);
>> +       ASSERT(bbio->async_csum == true);
>> +       csum_one_bio(bbio, &bbio->csum_saved_iter);
>> +       complete(&bbio->csum_done);
>> +}
>> +
>> +/*
>> + * Calculate checksums of the data contained inside a bio.
>> + */
>> +int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
>> +{
>> +       struct btrfs_ordered_extent *ordered = bbio->ordered;
>> +       struct btrfs_inode *inode = bbio->inode;
>> +       struct btrfs_fs_info *fs_info = inode->root->fs_info;
>> +       struct bio *bio = &bbio->bio;
>> +       struct btrfs_ordered_sum *sums;
>>          unsigned nofs_flag;
>>
>>          nofs_flag = memalloc_nofs_save();
>> @@ -789,21 +815,21 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio)
>>          if (!sums)
>>                  return -ENOMEM;
>>
>> +       sums->logical = bio->bi_iter.bi_sector << SECTOR_SHIFT;
>>          sums->len = bio->bi_iter.bi_size;
>>          INIT_LIST_HEAD(&sums->list);
>> -
>> -       sums->logical = bio->bi_iter.bi_sector << SECTOR_SHIFT;
>> -       index = 0;
>> -
>> -       shash->tfm = fs_info->csum_shash;
>> -
>> -       btrfs_bio_for_each_block(paddr, bio, &iter, blocksize) {
>> -               btrfs_calculate_block_csum(fs_info, paddr, sums->sums + index);
>> -               index += fs_info->csum_size;
>> -       }
>> -
>>          bbio->sums = sums;
>>          btrfs_add_ordered_sum(ordered, sums);
>> +
>> +       if (!async) {
>> +               csum_one_bio(bbio, &bbio->bio.bi_iter);
>> +               return 0;
>> +       }
>> +       init_completion(&bbio->csum_done);
>> +       bbio->async_csum = true;
>> +       bbio->csum_saved_iter = bbio->bio.bi_iter;
>> +       INIT_WORK(&bbio->csum_work, csum_one_bio_work);
>> +       schedule_work(&bbio->csum_work);
>>          return 0;
>>   }
>>
>> diff --git a/fs/btrfs/file-item.h b/fs/btrfs/file-item.h
>> index 0d59e830018a..5645c5e3abdb 100644
>> --- a/fs/btrfs/file-item.h
>> +++ b/fs/btrfs/file-item.h
>> @@ -64,7 +64,7 @@ int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
>>   int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
>>                             struct btrfs_root *root,
>>                             struct btrfs_ordered_sum *sums);
>> -int btrfs_csum_one_bio(struct btrfs_bio *bbio);
>> +int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async);
>>   int btrfs_alloc_dummy_sum(struct btrfs_bio *bbio);
>>   int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
>>                               struct list_head *list, int search_commit,
>> --
>> 2.51.0
>>
>>

