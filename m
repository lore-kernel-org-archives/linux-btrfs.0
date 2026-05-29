Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A23C35B62C
	for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2026 04:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780029182; cv=none; b=gdkOnN7oYrw5P1Ig3epaxXfzEu59n31azjuKXsS5h9l8aeILrOXZ/vUm3zD4aO3J4gUEwFgVAI11GBtolTmcQNk1Arp15XmJB1Jy27c0vooGmYgN51a7UXKXzM3XZQToTFbiA8wZOO8lfn2+2Soy5L639x9aZolllfMsR0M0FCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780029182; c=relaxed/simple;
	bh=62zNBFgvQLro1VxRfSmByKmGGLlJc7xQqiJ97q0s+sc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pdNG9iKwAaw3SU5heCOxe1duaLllad5F5e6nbfPfQx3CGGcKvWa3TZLpO7v/JY0RnNqwjpEHyg42wECgoCYd0SH/2LeIM05yDRoDee8l3mOxwzDfqbYnIi5YeEuSuIG9Dl9j07/Qe94ac2LxyK65zbewiDFFfsOF77NhSuaGNXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HoRW3lS/; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HoRW3lS/"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4903f7a90d1so63686275e9.2
        for <linux-btrfs@vger.kernel.org>; Thu, 28 May 2026 21:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780029180; x=1780633980; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=u61ZBIXJlKau2NUbJ1xnjRW0I95FN1h148sm4DYkpJc=;
        b=HoRW3lS/QiYx29JPg32G/KJC7MvKL1GO0LaBOrmAaveu38y0Atg1GA+8t6rnHKdZLL
         C0GyNkdbjidxC/GyBvTREFGvNyarfJ8cfXDLmHW2yZyYq8EuOGIK9eR5b6J+0C/F5X+T
         SwbOditl1zUTHCdyLgM0DrSSJRo2ieCHEGohnvecPH8nAckSML3/y429vxTLGOvqAycL
         vBPPHAdt5j2oov8A6HlxbLq520WgdUDVVLyb+SEH1/nZGnt6pF5OwINcsKorI5ho/F7+
         nx7NMDiEYUOzmQZv0qDnbuSksPuzT/M/HtmFJ+llSwJ5mnHpGr1A656ioGROmFQ4mioD
         KhUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780029180; x=1780633980;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u61ZBIXJlKau2NUbJ1xnjRW0I95FN1h148sm4DYkpJc=;
        b=e0kpEy9sCvQx1xWUjJJcvO13MCIym8KYKv5En7VZa6gM+iXI2AUkhUiiWVhpbFe1fL
         A1363sjDIH0XUriFNtPCs6lBWHRf3zOUpzLCMW3IZjXUc1eFpYuO8Q8+6oPg7Sgcy4Kd
         wwYtMxnN6gWXnzSdXshMMUjrL4bG3WmnPrnbvAY7m0kejyBE9h/YEE48sgwQcumFRA1D
         7ZR2sEQJ7YbL0d+57KfrlxH9/Lj94gH+TjJgwEvZZWyif0AxWF5WCY0pqCF04+0gG/No
         D55Wd8fs6AeTXSQ7XChKGEEUIiTBZ/rSprhFvIGwt5kLBNjS3u77CF7GONKe1MAwNZEi
         BjXQ==
X-Gm-Message-State: AOJu0Yxz/7CFIB3JxZaaCDfXO/siReo57vcZqL1Jemx8nWwJEQvBLy44
	8D65UrLA4/oUNkrDkle7eOYQFWTY7GXzHndF9NynOT8Q/bRyeZd5t9a8aRi6Xiuijd0=
X-Gm-Gg: Acq92OF0X6BYsb+5WCI41JsYd6jVauSse9ZZ0OQ33K3Y7fCRUF132qadm3WMItec0vP
	uNY2E4wcQtP4sXkSWoOwyfzdijNggNcBS2s7Vmk4SrZqKKcOEyfD+CnW8IGoJDAY78DdE7KCDLo
	ET/2/d+vwbLjTnY1brEs4z5YCh3R/xghf9VlqYBlNiNokZj4nl1dHOASNDu9U0ItJeU85jwZwib
	yuG9rwjOpQ1Sh8wMvU2iSs9U1rM++M7z5KQHwKiHtcIgHLBIdmdclKlo2Be04ulv5WrQLSiX60A
	MX2wbEngBLYgjR9hqVFT9fz/dZCe1StXf0D5j1NZ1gFLDggPSK+o/I2f5ryVsrJqgO1vz2YZzs2
	L3hBFN2jlxlaILZSE+EBDnGDXqVnlWvKuHt/cmaJGSNrDqnXsyucK527AKof/gSg7LAHk8p9i73
	xV37nYr3TmzCxDDoMSZfQjGoW6+kmSqrxhHz+hUg34RzNMPJI+GuVbgHUP8281zK5NDe5J/Yb1H
	uQg+kKMl8qyfoaVrP1MKJM7fFIwD8O17HxIAOtWsNTfj3xhZL4H5fIhjUUMl23+ZxqW
X-Received: by 2002:a05:600c:5247:b0:490:3d62:eb0 with SMTP id 5b1f17b1804b1-4909c0c6e4fmr20211615e9.24.1780029179368;
        Thu, 28 May 2026 21:32:59 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf23c5a350sm4567425ad.83.2026.05.28.21.32.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2026 21:32:58 -0700 (PDT)
Message-ID: <48638d5d-906c-4280-aeff-cc68cacea595@suse.com>
Date: Fri, 29 May 2026 14:02:53 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] btrfs: fix false IO failure after falling back to
 buffered IO
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <cover.1779846117.git.wqu@suse.com>
 <b3393b113c45ac7bd7b2649576b5667395c22a1b.1779846117.git.wqu@suse.com>
 <20260527160112.GB1981571@zen.localdomain>
 <2a0b085c-bc28-49b9-8c75-376ad2fe9daf@gmx.com>
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
In-Reply-To: <2a0b085c-bc28-49b9-8c75-376ad2fe9daf@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/28 07:10, Qu Wenruo 写道:
> 
> 
> 在 2026/5/28 01:31, Boris Burkov 写道:
>> On Wed, May 27, 2026 at 02:36:44PM +0930, Qu Wenruo wrote:
>>> [BUG]
>>> The test case generic/362 will fail with "nodatasum" mount option (*):
>>>
>>>   MOUNT_OPTIONS -- -o nodatasum /dev/mapper/test-scratch1 /mnt/scratch
>>>
>>>   generic/362  0s ... - output mismatch (see /home/adam/xfstests/ 
>>> results//generic/362.out.bad)
>>>      --- tests/generic/362.out    2024-08-24 15:31:37.200000000 +0930
>>>      +++ /home/adam/xfstests/results//generic/362.out.bad    
>>> 2026-05-27 10:21:17.574771567 +0930
>>>      @@ -1,2 +1,3 @@
>>>       QA output created by 362
>>>      +First write failed: Input/output error
>>>       Silence is golden
>>>      ...
>>>
>>> *: If the test case has been executed before with default data checksum,
>>> the failure will not reproduce. Need the following fix to make it
>>> reliably reproducible:
>>> https://lore.kernel.org/linux-btrfs/20260526070055.60193-1-wqu@suse.com/
>>>
>>> [CAUSE]
>>> Btrfs direct write disable page fault of the input buffer, this is to
>>> avoid a deadlock specific to btrfs.
>>>
>>> So for the test case generic/362, it uses an anonymous page as input
>>> buffer. And since the page is not yet faulted in, the direct IO will
>>> fail with -EFAULT, causing us to go through the following call chain:
>>>
>>>   btrfs_direct_write()
>>
>> I believe that when direct_write() sees EFAULT from btrfs_dio_write() it
>> should do the fault and retry, not fallback straight to buffered.
> 
> It doesn't return -EFAULT.
> 
> btrfs_direct_write() returned an dio pointer, although it has not 
> submitted any bytes for that dio structure.
> 
> So later iomap_dio_complete() returned 0.
> 

I added more trace_printk(), and it shows it's the EFAULT handling reset 
the error number:
("r/i=" shows the root id and ino from btrfs, "i=" shows the generic 
ino, "pos=" shows the file pos and length)

  22.223076: __iomap_dio_rw: enter, i=257 pos=0/4096
  22.223078: btrfs_dio_iomap_begin: enter, r/i=5/257 pos=0/4096
  22.223097: btrfs_dio_iomap_begin: exit, r/i=5/257 pos=0/4096 phy=13631488
  22.223106: __iomap_dio_rw: while loop, iomap_dio_iter ret=-14
  22.223107: btrfs_dio_iomap_end: enter, r/i=5/257 pos=0/4096 written=0 
ordered=0/4096
  22.223126: btrfs_dio_iomap_end: exit, r/i=5/257 pos=0/4096 written=0 
ret=-15
  22.223179: __iomap_dio_rw: after while loop, ret=-15 dio->size=0
  22.223180: __iomap_dio_rw: exit with dio, i=257

As you can see, iomap_dio_iter() itself returned -EFAULT, which is 
expected as we disabled the page fault for the iov_iter.

But then it's at the following code block that our return value is reset 
to 0:

         if (ret == -EFAULT && dio->size && (dio_flags & 
IOMAP_DIO_PARTIAL)) {
                 if (!(iocb->ki_flags & IOCB_NOWAIT))
                         wait_for_completion = true;
                 ret = 0;
         }

So that explains why we will never get a -EFAULT directly from 
__iomap_dio_rw(), at least for the write case.


> Furthermore, the page fault in won't make any difference for this 
> particular case, exactly explained by the comment itself, that the page 
> cache will be invalidated.

Sorry, I got confused with another case where the buffer page is from 
page cache.

For this particular case, it's unrelated, and we are able to fault-in 
the anonymous page.


>>> [FIX]
>>> When a short dio write happened, we shouldn't mark it as an error, but
>>> treat it like a truncated write.
>>
>> I am quite skeptical of this as the proper fix. I looked into this
>> really thoroughly back in
>> https://lore.kernel.org/linux-btrfs/20230328051957.1161316-12-hch@lst.de/
>> and remember concluding it was much better to do the OE split and submit
>> separate direct writes, and I believe it was more or less working.

Firstly, the OE split and the proper fix doesn't conflict at all.

In fact both co-operate with each other pretty well, especially shown by 
the second write of the test case, shown by the trace:

  22.223529: btrfs_direct_write: enter, r/i=5/257 pos=0/8192
  22.223530: __iomap_dio_rw: enter, i=257 pos=0/8192
  22.223531: btrfs_dio_iomap_begin: enter, r/i=5/257 pos=0/8192
  22.223545: btrfs_dio_iomap_begin: exit, r/i=5/257 pos=0/8192 phy=13635584
  22.223561: __iomap_dio_rw: while loop, iomap_dio_iter ret=0
  22.223561: btrfs_dio_iomap_end: enter, r/i=5/257 pos=0/8192 
written=4096 ordered=4096/4096

Here we only copied the first page, and at this stage, the original 8K 
OE is already being split into two.
And the fix will properly truncate and remove the later half.

  22.223568: btrfs_dio_iomap_end: exit, r/i=5/257 pos=4096/4096 
written=4096 ret=-15
  22.223582: btrfs_dio_iomap_begin: enter, r/i=5/257 pos=4096/4096
  22.223588: btrfs_dio_iomap_begin: exit, r/i=5/257 pos=4096/4096 
phy=13639680

This time we retry with the 2nd page.

  22.223588: __iomap_dio_rw: while loop, iomap_dio_iter ret=-14

And still failed to fault in.

  22.223588: btrfs_dio_iomap_end: enter, r/i=5/257 pos=4096/4096 
written=0 ordered=4096/4096
  22.223590: btrfs_dio_iomap_end: exit, r/i=5/257 pos=4096/4096 
written=0 ret=-15

So again remove the failed OE.

  22.223610: __iomap_dio_rw: after while loop, ret=-15 dio->size=4096
  22.223712: __iomap_dio_rw: exit with dio, i=257
  22.223713: btrfs_direct_write: iomap_dio_complete() ret=4096

So __iomap_dio_rw() only succeeded writed 4K.

Now btrfs will fault-in the 2nd page and retry.

  22.223717: __iomap_dio_rw: enter, i=257 pos=4096/4096
  22.223718: btrfs_dio_iomap_begin: enter, r/i=5/257 pos=4096/4096
  22.223730: btrfs_dio_iomap_begin: exit, r/i=5/257 pos=4096/4096 
phy=13639680
  22.223740: __iomap_dio_rw: while loop, iomap_dio_iter ret=0
  22.223740: btrfs_dio_iomap_end: enter, r/i=5/257 pos=4096/4096 
written=4096 ordered=4096/4096
  22.223741: btrfs_dio_iomap_end: exit, r/i=5/257 pos=4096/4096 
written=4096 ret=0

Now with the 2nd page faulted in, this time we succeeded in handling the 
2nd page, and every thing goes one.

  22.223755: __iomap_dio_rw: after while loop, ret=0 dio->size=4096
  22.223847: __iomap_dio_rw: exit with dio, i=257
  22.223848: btrfs_direct_write: iomap_dio_complete() ret=8192
  22.223849: btrfs_direct_write: exit, r/i=5/257 pos=0/8192 ret=8192 
written=8192

So this looks exactly the correct fix.

If this extra trace helps, I can definitely reword the commit message to 
reduce any possible confusion.

Thanks,
Qu
