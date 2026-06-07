Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF09133AD91
	for <linux-btrfs@vger.kernel.org>; Sun,  7 Jun 2026 22:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780870892; cv=none; b=trPo0xDR1aXGDXYdCKw33fI9GH/uFKSBwuPBkmAQflpTiM85YaXUn1Y5m5OS9yUuDaUmwL8J34pirFzzC7/+ctLc/Qo7zG7HFgOGiZjs1oAjlHOWviiavEt0S/eMopxW9fb+eeRhXUBY6ueUr1H67iOSR0TTZjZmuQeWDTs/acA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780870892; c=relaxed/simple;
	bh=tHTV7XZCc6bUWj9dtObgPM+xgmYEqR4BypL9I4Paa/A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k/xW3UIKZjxZOmwquzIYNrXRePbpAKRRAt6blYw4ASbOtDxvgFEywA/yyh0FrXjyxMgY2nDRCO8f/F669oN3pfgNdxury8yfiELb/pjc+n1f5bFYtmeBetCOqGIewxKCAEDw7NzopQnDBUSLr3uAn6asF85vizOzAeV2IuwoAEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PjTr+WIk; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PjTr+WIk"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490ac357c55so42244495e9.1
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Jun 2026 15:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780870889; x=1781475689; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Ou3kdngIZWA82utDIbbLuD/0yiZ6IYaSCBlqQVl8Mwk=;
        b=PjTr+WIkssXaYffWfqVbfREVPDiKVS6CHrDdNYBU4O469sLPZluojY3NbYaoxXIVbV
         VlLuOV9H6ZhOf55wVGPFkRjr/nR/csq8Iu4+SZG8saB8abj9O2jhA551u7fpFWjpjs40
         lMLg8KfnPsJ4Rxmm4LNN8f64RjBmbbOg7yvGkYsY1T8C9yy+TpmuIoh3fWj33D4Ft4hf
         Mj8Pd0lQONwBrKNVVaRvQN1sDo6zm4W7sEcvz5MGzbDu8z0rCsq+x6z5lHp/tzSsnrsZ
         WtzmFMsp0KR3EVmSYaveYW4q4R/iK2Th3LlXuYkyaUlcfAIgZbA0UWXh9C6cPFiu59Io
         NE/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780870889; x=1781475689;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ou3kdngIZWA82utDIbbLuD/0yiZ6IYaSCBlqQVl8Mwk=;
        b=mBDGdfxCoNwcMOUEUZCyl9R4TqcGmojchhjvlbYXenG72kWYMId7n3aVcJrJu2VfZr
         kBiOSXAH2qsoH+rFr4UF9e/bH0W/1+ZoQOT4uICsDlpabQoQASdMtgukWA7G67BaI43m
         iqXYN4CH9J/n4HEEXZ8HkOeRa90VyTHnPZeEYKaWCkbrhXjNq+74DWngc1NiLItwLqpM
         CjRhedR9F6dBo4Kn0+pCp4f8xbyLvMt/QUTlheAz9NEWIDgrk0FRlL9Xn3meyxDFxLjH
         l2plRhsKCygeknTBsZG/No9QVzMsp3/AywX2f4MjQLj7j0U2LIiagzqCwe1ZCWvDxggB
         UByA==
X-Forwarded-Encrypted: i=1; AFNElJ97R6z/+++hoy2odyF0s/VYFiS2QqJCmWiuzkHrXmx8diq2ofmQpdywJeNzL15+n6ipucbqXSkFM3NjEw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxB8Sz57NLSWhziqAZcg6Du78YQ9h5+bjf4g4IvfWrj2dSZ2Udq
	dP/+OF3HOc3gTLNxBvgYG+4jed2aAAFpn4uq3Sxp2ZR9bCGADTVnHPuJuy1GsNJ+8KM=
X-Gm-Gg: Acq92OFDs/Dk8VKywHkSxGbbbzfUIofdevd6QN5ToIi6sP+6QyOHLaNIWACthDOCoUZ
	zNuELLTaROKb8Gj2qYw0JS/pu0M2tUzzP6kgByHxDFNAh1R2x0EW7QWmzW279E93cQ8KtQtlWbY
	x28apsD1FAn5Xw3xV2GS2t5jYr5kiVwd5eRy54Bs4M2SvmBPIDMqQ5SVf3ud3kbLG9kreZ3asnF
	l51R7z/exHcj9NwZ0S+orxSQ+3GPRI4HN+RFpTwqKLv5fYZLq2VemuBgngAj78MdeyyS3DkrQyw
	JnMgxLmm4Daems62ws5C1xsPZllWZn+yw5mqe+FXeNfvxVEaGPWeN+XQ0PkTyoG9NXCt1rZJUSx
	1j1+ZWYtdvTxEwCDxrhRvweiM7Gdx7jpzTZkvJAmVEkKQ/dB09niFxou072Ck/uslMaW6Ry2dT8
	PJp5QNbRPRSxg1Cxj1l0HqG1Jt50jAaQ+5DSxobmthO2FXwzRs1nFZ8U12o+7/e3wXd3xmlzr4M
	ZOZCYGcaawUKNsghzNWtATcuXsSunIZQZ7IXIW1rmiFcVeJhL58xe1B
X-Received: by 2002:a05:600c:4708:b0:490:bd66:e522 with SMTP id 5b1f17b1804b1-490c26038d2mr213868465e9.29.1780870889191;
        Sun, 07 Jun 2026 15:21:29 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164f6e2adsm167311345ad.5.2026.06.07.15.21.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2026 15:21:28 -0700 (PDT)
Message-ID: <a9a18bff-520a-4a8d-bdd6-d36fb41c2c43@suse.com>
Date: Mon, 8 Jun 2026 07:51:22 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: reject names longer than BTRFS_NAME_LEN in
 btrfs_get_name()
To: Weiming Shi <bestswngs@gmail.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, josef@toxicpanda.com, clm@fb.com, xmei5@asu.edu
References: <20260607121429.2091845-1-bestswngs@gmail.com>
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
In-Reply-To: <20260607121429.2091845-1-bestswngs@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/7 21:44, Weiming Shi 写道:
> btrfs_get_name() reads the name length straight from the on-disk
> inode_ref (or root_ref) and copies that many bytes into the caller's
> buffer with no upper bound. The caller (exportfs_get_name()) supplies a
> fixed NAME_MAX + 1 byte stack buffer, but name_len is a __le16 read from
> the leaf and the tree-checker only bounds it to the item size, not to
> BTRFS_NAME_LEN. A crafted leaf with name_len = 4096 therefore overflows
> the 256-byte buffer with attacker-controlled bytes. It is reachable from
> a mounted untrusted btrfs image via open_by_handle_at(), and on btrfs
> filesystems exported over NFS.
> 
>   BUG: KASAN: stack-out-of-bounds in read_extent_buffer (fs/btrfs/extent_io.c:3742)
>   Write of size 633 at addr ffffc90006c9fc40 by task exploit/5192
>    read_extent_buffer (fs/btrfs/extent_io.c:3742)
>    btrfs_get_name (fs/btrfs/export.c:289)
>    reconnect_path (fs/exportfs/expfs.c:222)
>    exportfs_decode_fh_raw (fs/exportfs/expfs.c:473)
>    do_handle_open (fs/fhandle.c:230)
>    do_syscall_64 (arch/x86/entry/syscall_64.c:94)
>   Kernel panic - not syncing: stack-protector: Kernel stack is corrupted
> 
> Reject any name_len greater than BTRFS_NAME_LEN before the copy. Such a
> name is never valid on disk, so this only rejects corrupted leaves and
> leaves valid names unchanged.
> 
> Fixes: 2ede0daf0154 ("Btrfs: handle NFS lookups properly")
> Reported-by: Xiang Mei <xmei5@asu.edu>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> ---
>   fs/btrfs/export.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
> index c403117ac..a54c6e8b3 100644
> --- a/fs/btrfs/export.c
> +++ b/fs/btrfs/export.c
> @@ -285,6 +285,16 @@ static int btrfs_get_name(struct dentry *parent, char *name,
>   		name_len = btrfs_inode_ref_name_len(leaf, iref);
>   	}
>   
> +	/* The caller's buffer is only NAME_MAX + 1 bytes. */
> +	if (name_len > BTRFS_NAME_LEN) {

We do not play the whac-a-mole game by add random checks ad-hoc.

Do the proper ROOT_REF_KEY and INODE_REF_KEY verification inside 
tree-checker.

> +		btrfs_err(fs_info,
> +			  "corrupt name length %d for inode %llu in root %llu, max %d",
> +			  name_len, btrfs_ino(BTRFS_I(inode)),
> +			  btrfs_root_id(BTRFS_I(inode)->root), BTRFS_NAME_LEN);
> +		btrfs_free_path(path);
> +		return -EUCLEAN;
> +	}
> +
>   	read_extent_buffer(leaf, name, name_ptr, name_len);
>   	btrfs_free_path(path);
>   

