Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E25C25B09C
	for <linux-btrfs@vger.kernel.org>; Sun, 24 May 2026 04:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779596046; cv=none; b=HVcqH8dM0mB8CUVTv43TfTboQph6JWNw57dKmXj2m28XBIOzTVyYhtim9WVfwzLIfD1g8VKi743upjRTKejjE2jvcrwWdyv9zAmYyPvkjGYzrFMmYQpFQsIoYiqx1vbD2Z0GSZQFFFq8TgXRTlAZJf0zlSOApawPgG2Pq1i40dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779596046; c=relaxed/simple;
	bh=KPxX+CiakLYHNZgqT5sKhD3JZ76ErFKbUsuCw26mOII=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=kpfmI3sAkrnbl4QJ+QFXtnZXyEJtmtggvGwmnjcu2wP7rehEDE08XkDvo+M6kvKHYM2kegfg8XSlOC0ae5EmC62ndfXSD+0g1Vila1jMhIGeIh/Z9rYkkXqx/e3xASpFrKxkRCAjlzvZMZ0KAqLBYwUfAZ2JWOfkfRGXhKrKCo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bOK98/FG; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bOK98/FG"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4903997fcb5so29320515e9.2
        for <linux-btrfs@vger.kernel.org>; Sat, 23 May 2026 21:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779596042; x=1780200842; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=RsUtZiDUfdzVtc95zyor9Mlvs8U7pMXaQiF7o7hOrb0=;
        b=bOK98/FG7cJCgv/12C8BOvpjCzHW5oGNbxYcFW/cUT0GjygiLxjuMhl6ocEUtYulDa
         x7WLGB4VDm80xD+r+n/JTdxduz1JTPAJmzmID9IMzlcCDUZXn6Bkrl5U1Byn8rfmfYWb
         K5Zt0B1LHWzXXyx8JHSMb6h5l44/3QBv47NkkhYhN3WEvYS68Qi1STgDYQ8n6kFOs5YZ
         AWjBYu6MIbKQM1FGRY1y9ME8gQ7IyilXXskWV49qYpnHL8460PagzMM5QmZ7sbTLNx45
         p7Cz2vyAUELui534OOCmqc8P2ni+cTxIvaxI8FRuPOquOIuq8FnA1HzjjSvmJYmGlxE/
         wuSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779596042; x=1780200842;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RsUtZiDUfdzVtc95zyor9Mlvs8U7pMXaQiF7o7hOrb0=;
        b=KB1Sf64Fv/ZDxl/jUIb2K7Ktm6oFpuTXVQed4sud+ny0DoUQpmwuIfaS70kakU4hvA
         IJG4+L1mAa8g3qucXav7JZjZc2y8gmG+RPJjHC+30epqTGWo/rHFy/Dglve2rKCXv+46
         yT9fj7vr7L3+9pMjfFeip2yZTkH5EY09Iu1pQ6yTa5DXTRQymRx1zxebZkVX08w/Eeu/
         a4Nva76y2aksulY9mx/Fn4iCL/8BjMFnobQ+VdicjYdrqkwp8yBdTGcxcrcGQERgUnhj
         NS3uZ81E5RCsQJM/VNvVAo9eu4zDmPRrnDvvHKGljFU4TqnCNCfF84LSGiBZCuArOscR
         FVMQ==
X-Gm-Message-State: AOJu0YyocF5+Tq7p1sVoOB2ecN5IV8KKXUK5SXX1fBrDd5kJBXYsds3g
	Eum8adNfSuAFRblxOgVnrbTjO1UJeDYTKMu7XCU4HsYJNYrZwjSMXoCGrZLQ/iLAo2Q=
X-Gm-Gg: Acq92OH7Eq98DqwjDTqQyvK6XdijJwuy+f48BrBDxNQYSXifjFWIx0iVf7HUJxMyV78
	GdLvhfImS3x/xfuB4gPkW1Sj8vLjaqmp0FUP7H9Uzb0dyvd+37Dm3wfZmnHgQpUbpdbDElyXgr8
	bh6XHIivI1d2wsy0wAsyw+cxOp63Qtwxvep31x9RXaVjrUu1hWOsrR4WO2KAP+jaqY5nDHEMu0t
	k16zJnQzHjCpwDojzSmnwjsLLrjqjHxZYmZ+PnyZfwpX3vUcCVHJf9Xk3ZHYAfcwGjeCKakz0Qx
	lURSSig4Bja2nje9g6JhSMzA4qob8HHiHLwpUWSwkZmHjAyMGhv/ByMG1V9R0Fw5XEzvCarmBsA
	NFH8capgg+4LLyt2gYswCiIRNFBaM7h7i0u/7G0zOnaTe+dQIf1nD5PnwSL/lkEGt1IDsD19Lt7
	uRgFKq9KlSjufHPILNJxC+w6/eT/ZeFnepjfcdyOwQtR5xNmSsj4lqXQfj1KvlHzVNf6TNP8/qh
	XNMcnbZrG2leQFHXOC9n6msgDk6upChlvyEkUPwZ3Xz7OEvOxf83LEspw==
X-Received: by 2002:a05:600c:4fd0:b0:48e:82b4:b54 with SMTP id 5b1f17b1804b1-490426d1ebbmr146277385e9.23.1779596042310;
        Sat, 23 May 2026 21:14:02 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb591d07fsm61894625ad.82.2026.05.23.21.13.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 May 2026 21:14:01 -0700 (PDT)
Message-ID: <1b5c39fe-df28-4a21-bace-fc742498945e@suse.com>
Date: Sun, 24 May 2026 13:43:54 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] btrfs: disguise single-data-RAID56 as RAID1/RAID1C3
From: Qu Wenruo <wqu@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, hch@lst.de, linux-raid@vger.kernel.org
References: <cover.1779412152.git.wqu@suse.com>
 <ce02ebf8a9a6f5e2357b838df9d7ecce1f0cfd4b.1779412152.git.wqu@suse.com>
 <20260523142344.GC183694@twin.jikos.cz>
 <e1961351-d563-4d73-b9f3-30063bbe7c4d@suse.com>
Content-Language: en-US
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
In-Reply-To: <e1961351-d563-4d73-b9f3-30063bbe7c4d@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/24 08:16, Qu Wenruo 写道:
> 
> 
> 在 2026/5/23 23:53, David Sterba 写道:
>> On Fri, May 22, 2026 at 06:53:53PM +0930, Qu Wenruo wrote:
>>> Recently kernel RAID56 lib is trying to remove the unexpected
>>> single-data-RAID56 (2 disks RAID5 or 3 disk RAID5) support, meanwhile
>>> btrfs still supports such setup, which means in the long run btrfs has
>>> to handle such corner case by ourselves.
>>>
>>> Thankfully single-data-RAID56 is really RAID1/RAID1C3, since data and
>>> P/Q stripes all match each other, rotation also makes no difference.
>>>
>>> This patch will disguise those single-data-RAID56 chunks as
>>> RAID1/RAID1C3 chunks.
>>
>> I don't think this is the right way to fix it. Calculations are an
>> implementation detail and should be done at the time of the xor_gen or
>> raid6_call, not touching the upper level structures related to format.
>>
>> Instead, please add helpers that take the same parameters and do the
>> switch if there's the edge case of raid5 or raid6, using memcpy. Thanks.
> 
> I'd say going dedicated memcpy() is an adhoc fix, and not any easier to 
> maintain.
> 
> Now you have two paths, one from the raid56 lib, one from the btrfs 
> specific handling for the single-data specific corner case, and that no 
> one else is going to review/utilize that corner case.
> 
>  From this point of view, reusing the existing RAID1/RAID1C3 is way more 
> reliable and sane.

I tried the idea, and it doesn't look elegant at all, we need a lot of 
if () checks around every xor_gen()/raid6_call.

Sure the end result is not that huge (and I have only compile tested 
it), but if we had some parameters passed wrongly, or some corner case 
missed, it can be very hard to notice.

Just paste the adhoc fix for reference:

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 08ee8f316d96..50fefe33bbe3 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1410,11 +1410,17 @@ static void generate_pq_vertical_step(struct 
btrfs_raid_bio *rbio, unsigned int
  				rbio_qstripe_paddr(rbio, sector_nr, step_nr));

  		assert_rbio(rbio);
-		raid6_call.gen_syndrome(rbio->real_stripes, step, pointers);
+		if (rbio->nr_data > 1) {
+			raid6_call.gen_syndrome(rbio->real_stripes, step, pointers);
+		} else {
+			memcpy(pointers[1], pointers[0], step);
+			memcpy(pointers[2], pointers[0], step);
+		}
  	} else {
  		/* raid5 */
  		memcpy(pointers[rbio->nr_data], pointers[0], step);
-		xor_gen(pointers[rbio->nr_data], pointers + 1, rbio->nr_data - 1,
+		if (rbio->nr_data > 1)
+			xor_gen(pointers[rbio->nr_data], pointers + 1, rbio->nr_data - 1,
  				step);
  	}
  	for (stripe = stripe - 1; stripe >= 0; stripe--)
@@ -1987,11 +1993,17 @@ static void recover_vertical_step(struct 
btrfs_raid_bio *rbio,
  		}

  		if (failb == rbio->real_stripes - 2) {
-			raid6_datap_recov(rbio->real_stripes, step,
-					  faila, pointers);
+			if (unlikely(rbio->nr_data == 1))
+				memcpy(pointers[0], pointers[rbio->real_stripes - 1], step);
+			else
+				raid6_datap_recov(rbio->real_stripes, step,
+						  faila, pointers);
  		} else {
-			raid6_2data_recov(rbio->real_stripes, step,
-					  faila, failb, pointers);
+			if (unlikely(rbio->nr_data == 1))
+				memcpy(pointers[0], pointers[rbio->real_stripes - 2], step);
+			else
+				raid6_2data_recov(rbio->real_stripes, step,
+						  faila, failb, pointers);
  		}
  	} else {
  		void *p;
@@ -2002,6 +2014,9 @@ static void recover_vertical_step(struct 
btrfs_raid_bio *rbio,
  		/* Copy parity block into failed block to start with */
  		memcpy(pointers[faila], pointers[rbio->nr_data], step);

+		if (rbio->nr_data == 1)
+			goto cleanup;
+
  		/* Rearrange the pointer array */
  		p = pointers[faila];
  		for (stripe_nr = faila; stripe_nr < rbio->nr_data - 1;
@@ -2644,11 +2659,17 @@ static bool verify_one_parity_step(struct 
btrfs_raid_bio *rbio,
  	if (has_qstripe) {
  		assert_rbio(rbio);
  		/* RAID6, call the library function to fill in our P/Q. */
-		raid6_call.gen_syndrome(rbio->real_stripes, step, pointers);
+		if (rbio->nr_data > 1) {
+			raid6_call.gen_syndrome(rbio->real_stripes, step, pointers);
+		} else {
+			memcpy(pointers[1], pointers[0], step);
+			memcpy(pointers[2], pointers[0], step);
+		}
  	} else {
  		/* RAID5. */
  		memcpy(pointers[nr_data], pointers[0], step);
-		xor_gen(pointers[nr_data], pointers + 1, nr_data - 1, step);
+		if (rbio->nr_data > 1)
+			xor_gen(pointers[nr_data], pointers + 1, nr_data - 1, step);
  	}

  	/* Check scrubbing parity and repair it. */
--
2.54.0
