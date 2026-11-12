Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794462201;
	b=Y9/JlPFAJ+Qh85tyg24XHiTQOB+3jFz5OUDcMWlAV8zzRyPp9c39lc/FSygwpUiecTmf
	 m9WoqsP4BbXDRWUWqDtY6BckXB2bebvMwzRi9z4hVIJBvdFB+w/df9e1yF/tLdPWPdYsA
	 9UyONN2lnxuhkZC+60antu92B4OHa12kyGZtMyXsytaOh1pdy64uWujGtrBdcKKoIyHed
	 nL+groBjsF5sTnsTFmKoK3/S4Rwhk1z40GNZPFoP7LxxbK/jjCqmyfPJ0E/OxrK3eSH4e
	 afsdLLoD/N7N7d04gde+MM3JB44JH0XJNy9AZMjhM/P3Dd+6td4H/alxUHEhzsS8QAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794462201;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=uSpdnwCCcl5s3VxxBaMPEQo56m+gTuRSQb5w+gs0FcM=;
	b=5mExMQLnSXCcUxQ78+8Rrdj0ADYfHRvMOukPLXTrozxEgld5qqgW7Lm4HjvtwJUPQUMI
	 /a+SuKLwz6f0/7vb5VcKVWtI3yQZPPLAkHkxJAupmz91wzILAUacXp5dPCke7lHluKVPq
	 CkD8qJakIMjVZIygo/apogI9JcJAydMw9lbEBXeZkk+15P9vXYPdyKB6dV4Shhlm8U6Gz
	 Re/LTVHHwxmKPlfLbozrIFjgUD6CMuCD/fvjCjJW7h1ARFhlfMABCVxifn1OPxxqrgi01
	 US+gmSyh3auzyvQMHP/6V9mdVB9SAnqt+/EpnFOgrkaglx23ElXqzenaWSWLkXb2+RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=IUi4Sr6O;
	arc=none smtp.remote-ip=209.85.218.50
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6884C606A323
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 05:43:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6884C606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=IUi4Sr6O
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c4c9abc1824so542689666b.1
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Nov 2026 21:43:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794462200; x=1795067000; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=uSpdnwCCcl5s3VxxBaMPEQo56m+gTuRSQb5w+gs0FcM=;
        b=IUi4Sr6OJLSxsf7172IrJjYS452TUyDWo9Sa8QRwLrCli61GVQIDtniOC7L67wB+XZ
         7YfjhTS74jEyagjz3p5KILUccQg7lVTjqPa+oKHW4I8avHW4DXmeZOEZ6cwVLWsoH1fh
         ksbCBbkpy3wOGXexSDTj+keWxFCDH01rIBJNgbX1W/dmlTYvy1a2zJvP04gEBgJ5O0fr
         gc1jKM7vw9HOlw/Ptm0GyHdLRTkvF7zbwlu9E5/PMGh3oPpFwDMLuYIzIXyPp3k0q4Fz
         MJnVQFeEmlOFoqjn7tiY3G8zHXpca8imb22B9X++ceHj+BK7c/ge6I1Lh8S7tzCYkop+
         bncg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794462200; x=1795067000;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uSpdnwCCcl5s3VxxBaMPEQo56m+gTuRSQb5w+gs0FcM=;
        b=JVSqLr1E3VPorUhaZD2SK1HcJ95FNnmR4QTwTR0ZLtBSPTOJiivaACMlZMaJmiWVb4
         bEQfVzUywH/jDk4itq6CXP7muQ0pdQBgnPnUHZzt/Vf22VokSA/L7K4cjiUy+hklxPLw
         X43ngdbadGO5hynFHRfdVzMXaUp8sEr+gPHBA9B+dznTYAZ98oaFPDSFWTQ9GyKZF1li
         fQxrFpCkk9pPqWIC2dE6dF0NbsSVfJ4+PBm2fIL5fNnjV7mR6+5Y3e4E7pAIkqOBG2ob
         VzDXDqt5mG5OutYaWV0waN1tDtdBuXdRtonNIPoO2+rrJzrGibWueKM8WvJErqDPKgIJ
         S8aw==
X-Forwarded-Encrypted: i=1; AL+hErGITvTNqr0EyfSHa88lgkYGHvW6+9L/vC36Ip/0S4o5gj2lzmBdlApScR4aDi4x779ewNjO0k0equzyCg==@vger.kernel.org
X-Gm-Message-State: APuU4Z/z+o6ABJIa1HVqWeYx990gWpQGRVG0tLyDRYY/kJLW0Sv94GGU
	uCyjcfxc/MMGq0DFlJO2ZTsaWV6Z5ENW0uChUX8e5gtJR/kUoZkUSfIrI8cTBc2itkQ=
X-Gm-Gg: AYBFou0PWAyG5kJ+wQiuYQkmVKYUHVd4xUxAfptTtN2FOyJjTJDuvk02UWPVcvo9g+w
	nonezD/TdnGnyPmVglRKxwKjTEX/xYeAshl01NX0HvM1VTA8/dzX92rdHmLMwzJNqj2jpBYqZ5Q
	tc159kWNeIGpYTsuCmkkrAVzE89hgmIkevgjdlXykUSdLW5MZLV9HUaKckZ5M3HrSwJojkzylDx
	FQ5DKU+89BWFn1Wb3w+Di2ici2rZc7c/NwuL/I822CaZ308uuiCXVW6PTIrq9Ue468dQ97BfAzj
	jblU8HzwOGrpSfxIitf+euH/9gha38P6EH6Tw34e6jl59OojiQUGwjsP9SjWxcKCkVet0PSedt6
	0lemFqDXYdU4QWYyR5TqVoW72TXOtqv0FBU3fssgwV3jbrvlMclKQhTlJBHX+w7pnETdEcy8lR1
	K5vfv5wRnCr3M/GG3+iP6Tbo+8pLPpLN2rVzxxuIo5VnnXygjrGgam5otnu0H1m1URhCOyWF8XO
	nUjO6AYe+iUn3Pr8M/1PYygId7biYBhVoUk0JE+F18ykKoFCsw5Ik1mZ2ugGQydpflIkJ8CMf5l
	4VOvT3+4IOd4Se5QgGMplg==
X-Received: by 2002:a17:907:2d2c:b0:c46:7ec3:fde7 with SMTP id a640c23a62f3a-c5066b32327mr351480666b.31.1794462199671;
        Wed, 11 Nov 2026 21:43:19 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6d4b12esm28552285ad.21.2026.11.11.21.43.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 21:43:18 -0800 (PST)
Message-ID: <bb7bfec5-eb4a-4f8b-9dc6-d5eabdec9bc7@suse.com>
Date: Thu, 12 Nov 2026 16:13:14 +1030
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
Subject: Re: [PATCH] btrfs: fix block group ref leak when scrub races with
 unused bg deletion
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
References: <52f2ee4b5d0879b99ea8c863ee40403bb06c5345.1794441990.git.boris@bur.io>
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
In-Reply-To: <52f2ee4b5d0879b99ea8c863ee40403bb06c5345.1794441990.git.boris@bur.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/12 10:38, Boris Burkov 写道:
> btrfs_delete_unused_bgs() takes a block group off fs_info->unused_bgs
> with list_del_init() and, when discard is on, later moves it onto the
> transaction's deleted_bgs list and takes a reference for that list
> membership. Meanwhile, it is possible for scrub to add it back to the
> unused block groups list:
> 
>           CLEANER                               SCRUB
>    btrfs_delete_unused_bgs()
>      list_del_init(&bg->bg_list)
>                                          scrub_enumerate_chunks()
>                                            btrfs_mark_bg_unused(bg)
>                                              if (list_empty(&bg->bg_list))
>                                                btrfs_get_block_group(bg)
>                                                list_add_tail(unused_bgs)
>      list_move(&bg->bg_list, deleted_bgs)
>      btrfs_get_block_group(bg)
> 
> Other users of list_move() for bg->bg_list (like btrfs_mark_bg_unused
> itself) ensure that the list was empty under the bg spin lock to decide
> whether it merits a fresh reference for being linked to the list, and
> we need to apply that pattern here as well.
> 
> Note that this is not abstracted to a helper function because some of
> the callers have additional logic deciding whether to link it or not and
> I think a twice used, twice unused helper would be more confusing than it
> would be helpful.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/bug/linux-821034ac-556f-4d72-af2c-d04468879af8
> Signed-off-by: Boris Burkov <boris@bur.io>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/block-group.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index 027830a53f7d..0b3b8843d221 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -1830,12 +1830,15 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
>   			/*
>   			 * A concurrent scrub might have added us to the list
>   			 * fs_info->unused_bgs, so use a list_move operation
> -			 * to add the block group to the deleted_bgs list.
> +			 * to add the block group to the deleted_bgs list. In
> +			 * that case the list reference moves along with it,
> +			 * so only take a new one if we were not on any list.
>   			 */
> +			if (list_empty(&block_group->bg_list))
> +				btrfs_get_block_group(block_group);
>   			list_move(&block_group->bg_list,
>   				  &trans->transaction->deleted_bgs);
>   			spin_unlock(&fs_info->unused_bgs_lock);
> -			btrfs_get_block_group(block_group);
>   		}
>   end_trans:
>   		/*

