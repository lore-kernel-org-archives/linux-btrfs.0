Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793393636;
	b=fElKBEkElsqfmg3D78WanWqCH4C0E3mwA3jLrwWiyixBhNexKUjRyhzjqqAFN2yUPnVI
	 PZ+nFo/3SpoeyiSOlTc5KNoTf1petvGBRMk61aN7puMd2CrD+yEp7WZrJtUrYsF6oZGrg
	 Dolq+QmOs6JS77IyrcoFRbVGm5f0itKkMsZS6qlavoqUvx30JQmrZphspfiaOcQ6T6mQZ
	 G8CFuPlIsxuE1l6SwQlvcm7Z9lApi7QczWyozQZV+P3gznvC6NputyzDPJPVX9sIuFQ7T
	 5XkSgWl+BsMuF1QHF4dFDxvxxTK6GgZU6ZYaVVKwACRe+qEjd/3oUyeLqQGLqhzPvkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793393636;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=AuwHLHwvZlBMY+ZJfBhSRKPxx3F2S1R3eMxxTQdDhB8=;
	b=FCsPgPZ7CQd/iQp8yERjIv5u0wX5+WzG4Q8zYoghGouXP6RqtNA1bbgqSE0bRWQkwWbq
	 9tMd89gatmj69+o9tamxfdNddnw9MSrw0RqPm23X7VELI/FcATfC1VP9AUmKahFkpexL8
	 QBVju1n9gSHhfsz7PWx3iASEloq8n0uC9KYWy0C7eZlkCe4VGm9AYRSoZGFNh617Ij5cg
	 aLT8fSyGyhCOxBbx1qulyA0Lo6zcVPBZQGC/yBCFM1eJCZX8WXQcPkwUNB4F/wfs7shp3
	 kD26nFKfCyc+fDls/bsBgXS9xDcHRRrXZOLiGhA0BwZb0TG+Xh1DRvTVfWUAYjNyQPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=gFFJacL3;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B767606A31A
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 20:53:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B767606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=gFFJacL3
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a2153c8525so7871475e9.3
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 13:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793393634; x=1793998434; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AuwHLHwvZlBMY+ZJfBhSRKPxx3F2S1R3eMxxTQdDhB8=;
        b=gFFJacL37RzZIU1Y64b4f5WAUJgqks3lEIyKWeVmXbQxTQFXYTmLt+aL/9HH/FfZW8
         Qzm8MtdXJt9wtkcuo/tGhM2z6Q1BMcJRyKaQwPG90xn2nNkOifpFVniDetnvjA5Oa3jq
         LJUlaVNdrYuj+BePo2m1HYCod3dniUvctt5W4tDMKENCdaYKCe7DXuuUzHX15tP3GsAm
         XBl34k1RYAwIaeHp6HZkeXbFOBn5eySsQgbggIyhQmu4Ohjn66lUZunjsZeHCB8fOTf0
         HnD2AdPN9JXmllYZVkkYhCQt49XiqPXxfCrKTAStHrC4us5hATnC7uVYYDpCMX0oJ+R1
         ILjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793393634; x=1793998434;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AuwHLHwvZlBMY+ZJfBhSRKPxx3F2S1R3eMxxTQdDhB8=;
        b=P2dn0HA0qVhhdrj6tU8Bt2MCH9oHxjGzqH6p+lWiMoPDrDlGeF/mBq3/kDjE0oMaFv
         q4HvFMI1oGJ8CkljcEimzUMSY27qwGuJUCprlE4Q3BORDrauswobYjnOCb/0RVN2VPHT
         U0lcPJGXKAbh+UC1w3Rj/wH05nIg1//l0/kVDdhbuSH+TsN3bE/yVmmdVrACkqH5PjRs
         lEdU5yLPkMDBSSAzgb7zf4fRkZdNDRvNP23nh6uCzBZUZVX/0I0gNdP62bJLRJr0OJFj
         cJYtBaGSvhWvm/2F6HyWPbkaf9DF1SAk7pBhq/SWvQENhmZpWFqwA8rk0kidJgHjvp3g
         q+QA==
X-Forwarded-Encrypted: i=1; AKwUvBxCXMecbbMHdAytb/JHRQPi6z7z+dqXjqdOz97CwVBFjqcqq0hdt7gkcqhYfcKnrDnT/GTf0fcARBNXoQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYKWUfm6fTJtVSgH+rEqvAI52ppG/xCZTv+0X4b02Hezubjb1f0b
	ZL+Q81nGH3ApSFWym2QBLM+pYQDXu7NxKKkZUVtHC8E7tCmc8Oko/JgELkLlZQlk6VA=
X-Gm-Gg: AYBFou1D3DTEfBOAbkvDY8qaqiu5Gr9Wq7HYHAo+02BJMSGtXOaXRDxUf/bM9XxqQiw
	9VftI62ieM25RDhfiSOj+Rg7qP9hANeFB6I4PUQFWOVvkBvzru35XNS/SKS7mAzpQrpmeZltI9v
	qmj7+PIxD88c8jS4OhBVCwmrJNv+x/VEyfcQZGpCACB+brRwcUtpzHy89m8ktlfaDa1sGejeOrJ
	eaAkXlp7K67b3CAM7jy/p+8rwPtl0ewL25xJvNPGweQSSCvrxPWoLoEPBIwH0/z2dtjQcCnvoHr
	L7Zd9qp6+dqSO2L4ZCcWob+G7toZk2vURUR1PzLtyHcQzAoOWqZDNyzyUxVCkf4Ry4a/Q2wZ3tz
	O7I3rxMaTwB1EYmuSalMj8NcrQZoCkpfF00Pk0f8r36e8pcuOzlvq9PEgOVHJ2lvOOvfMFCWwei
	e7jJm5ksAnT85V0uVRV/0dkmW3+F5udgZxc6x6kvLDdoVc5KVd4H5KKwYZgIUDSpSGi2ZiUsYZf
	mBoRTQb1FyD0vZ/bVi3u+9o8Nc4dzwoq+Ag5SdvE+u0FdMLzM8I6I54qlFvWmtKrI0CPWG6NyFc
	sbx80fGprt+CkLourxTtbQ==
X-Received: by 2002:a05:600c:3554:b0:4a1:f7f4:7cf2 with SMTP id 5b1f17b1804b1-4ac1737c474mr78096505e9.17.1793393633915;
        Fri, 30 Oct 2026 13:53:53 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae85f37e7esm2676235a91.1.2026.10.30.13.53.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2026 13:53:51 -0700 (PDT)
Message-ID: <1779ca3f-a227-48ac-af2c-245b7634c5f1@suse.com>
Date: Sat, 31 Oct 2026 07:23:47 +1030
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
Subject: Re: [PATCH] btrfs: move async csum generation out of experimental
 features
To: Daniel Vacek <neelx@suse.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <700ba6c46da86ace18a502b43c5e61d16a556060.1788424754.git.wqu@suse.com>
 <20260904170035.GN9053@twin.jikos.cz>
 <d79d06ab-721d-4fec-a2a3-823e9380c792@gmx.com>
 <CAPjX3Fc3U3MDHhzBNOk=6KsBELvrU8T_i=2U-z1kRHjkfAY1SQ@mail.gmail.com>
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
In-Reply-To: <CAPjX3Fc3U3MDHhzBNOk=6KsBELvrU8T_i=2U-z1kRHjkfAY1SQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/31 02:24, Daniel Vacek 写道:
> On Sat, 5 Sept 2026 at 00:21, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>> 在 2026/9/5 02:30, David Sterba 写道:
>>> On Thu, Sep 03, 2026 at 06:09:41PM +0930, Qu Wenruo wrote:
>>>> @@ -4437,19 +4432,6 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
>>>>        */
>>>>       btrfs_flush_workqueue(fs_info->delalloc_workers);
>>>>
>>>> -    /*
>>>> -     * We can have ordered extents getting their last reference dropped from
>>>> -     * the fs_info->workers queue because for async writes for data bios we
>>>> -     * queue a work for that queue, at btrfs_wq_submit_bio(), that runs
>>>> -     * run_one_async_done() which calls btrfs_bio_end_io() in case the bio
>>>> -     * has an error, and that later function can do the final
>>>> -     * btrfs_put_ordered_extent() on the ordered extent attached to the bio,
>>>> -     * which adds a delayed iput for the inode. So we must flush the queue
>>>> -     * so that we don't have delayed iputs after committing the current
>>>> -     * transaction below and stopping the cleaner and transaction kthreads.
>>>> -     */
>>>> -    btrfs_flush_workqueue(fs_info->workers);
>>>
>>> In the final fs closing sequence there's always some possible
>>> interaction between the workers, but I don't think we need an explicit
>>> flush anymore. The work offloaded to the system workers will be done
>>> before we get here.
>>
>> In fact, Daniel's commit ("btrfs: use bio::remaining for async
>> checksumming synchronization") changed the behavior back, and we may
>> need to be more cautious now.
>>
>> Previously, the csum generation workload will never call endio in its
>> context, the only work it really bothers is just to wake the completion.
>>
>> But now his commit changed to use bio_endio(), which means we can again
>> run the workload from csum generation workqueue.
>>
>> In fact, I do not believe it's the proper timing to move async csum out
>> of experimental anymore, after his commit.
>>
>> I'd prefer more the next merge window at least.
> 
> Hi Qu,
> 
> Are you going to push this one now?

I'll re-check the patch and resend, to be sure it can pass both claude 
code review and sashiko.

Thanks,
Qu

> 
> --nX
> 
>> Thanks,
>> Qu

