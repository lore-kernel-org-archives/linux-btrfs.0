Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8DB239567
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2026 06:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782455938; cv=none; b=lxbTvpsjcTkWdpqFJt3s2njkmVWA5137rrQKigF2NL4+wgQizSZG6olKKv4WhQwXIthZgGaXB4lVskOsRUy+8e9uKJ33cwcVsJIS7OXZB4zzd8bCvL3E3VS/7Z5uBbY6wjfuIKCqytrRYJjuePQiFwPOiOdlo23CRE9jQDPLds8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782455938; c=relaxed/simple;
	bh=3DgS81XM3KGEPln5NNDKIXx5YyOcLR807aD4Vz2SnR0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VS580i1/EN8vRIDGW0l68w0UdVE5ZMsLXnXWz1etiyO+CLzwj3KOugMqiHsNOjCxifZvW10qNWIIL5PE9XNSTGRdW5QttAXtepTu+epEtDkfC+KihEo2XAfv9Ls2r7QXAZGluKHUkQkRDGOjsi0PiHNf3+3FbynY99LMzw7M9nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IhSCmpCW; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IhSCmpCW"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-490b64c8311so6734165e9.3
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 23:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782455935; x=1783060735; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=MlZjyuLh3+FM/+5q3QBAkx4Y28rvsXbke3N1Fwrq2mI=;
        b=IhSCmpCWgdKV5q3kujkCSJaOKrvoQ5D4Bc7q34H/gH2jNwmDNQaMhU+OdhbXliGW29
         17XyP2yeCMuKY6FEHxqjrsgNc04E+bs8Xs2IxS3cqAXwY9O50PscQOvDjiHt2UcFxWru
         fJV22RFZ/OtpIaGYLAfIuWrSpKzk0kW/mxvYlxkWq2V2D6k90uSafDmpZa1M3wlffh4P
         LS6xpHVTPy1LsMl4rgGYRsfrdlJ9KmwCMRocEOkaQkbxunFDUhuu6ZBF6MJXrUINZfaC
         b/8aBO0P1bGiwUaXswkTaVHce5XxztHn5MBPTRO+Bqb5H8vyIj5fdCVA7XOYYPdL3S5Z
         d0mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782455935; x=1783060735;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MlZjyuLh3+FM/+5q3QBAkx4Y28rvsXbke3N1Fwrq2mI=;
        b=kXzEu4VAXUikcG+v3u/jvKxUIgPEQ/LNDkg3y7fh9FTlWWcU9VozhqbXDnNg640Mm+
         A7GUUcr2jmg2qtJYteK3KB0uz8XRiJVYz6XLtwfHMtrUzYmpd9OwcjlCAIsUuRwc8xkK
         NHkSJafqruX2c8O9QqewjWJilTzSExAMuEEGXW+TJPN4oidckV6MhPQv5Msm/i7iJpp3
         6b3iQop5TVlzELKz6S9CQePr4IO85qW+wzaciFFdXWtR4DtwboxHxJaIsMfeSv0dUIGH
         0kJ3zftKlLLSPwuvbQhmRDckGtFp5tTEJVpNP/kGHW1Q5LXHSgCbZZj6eWPEsXMRnnvd
         eouA==
X-Forwarded-Encrypted: i=1; AFNElJ/r1QyAtDTa+6wxBRhD/huktmtvZ9R2zAZMab/jdhNH/2fSJkJYrTpoAQlQwLkTUtUHFIqFfkCzx9n3tA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxLAU8Ap7R8XZI/3EcODAJgprW4vpetIgumm+/mSgC1zWiSrCwk
	BYjAbpXUafxCrHjxcm9ITEkJBZlJZmm5g74oSnaA8MIua0FFV5nyCsi9vSRWM5znzJ8=
X-Gm-Gg: AfdE7ckAmL/EKulDiAgrNBC6b/PFcLJQronYnlnpIEGNkAmhSX10x+FWSvexHr7mJSV
	SA3BVBYQnYrcdRi5kmhSbTKd0xSiGiyYBkATLzLEjcCsDcRsIXNYilUPrC8UCDRAQiV7TWqoJ3M
	XWTfFrQv39ge87r75QGrVDZBg5MqrXA9bhyZAJ0Ay52hYxLzCDG2mnWjcYLanLy96CD17hKCj3T
	lF9snTa5U3iIvnKubnUUG0rWpb8fVnt3V6CIBwWj5/Z/gsIfSiWd4BiL+GcieeCisZjoD5lhxbe
	K0Rq8UDMz3GJRIYTNzEpbo5T6HLak0Izccyre6cVMYuLaS4OhnDnwZgaW90YbTnxHfIV+n/31yK
	5Zx46lUY2pusmeRj5Ob9oD/v9nr7PTpLZGuX6gjZnUM6ZEYA1YvBLZp2qnRsd6CU6+4NYZb32Vs
	uTvch8b6Gq6zcmT98Wuft5ZuTxSWhMZ2FNCBVHtgfJ
X-Received: by 2002:a05:600c:a111:b0:492:68bc:3237 with SMTP id 5b1f17b1804b1-49268bc34e3mr35713465e9.32.1782455935144;
        Thu, 25 Jun 2026 23:38:55 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7f65088cesm32603075ad.80.2026.06.25.23.38.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 23:38:54 -0700 (PDT)
Message-ID: <bbeac2f6-685d-4ace-b689-10d64c4e3ce5@suse.com>
Date: Fri, 26 Jun 2026 16:08:47 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] fs: btrfs: implement opendir(), readdir() and
 closedir()
To: Alexey Charkov <alchark@flipper.net>, linux-btrfs@vger.kernel.org,
 u-boot@lists.denx.de
Cc: =?UTF-8?Q?Marek_Beh=C3=BAn?= <kabel@kernel.org>,
 Tom Rini <trini@konsulko.com>, Simon Glass <sjg@chromium.org>,
 =?UTF-8?Q?Timo_tp_Prei=C3=9Fl?= <t.preissl@proton.me>,
 Peng Fan <peng.fan@nxp.com>, Patrice Chotard <patrice.chotard@foss.st.com>,
 Yao Zi <me@ziyao.cc>
References: <20260625-btrfs-readdir-v1-0-dd781a2b3965@flipper.net>
 <20260625-btrfs-readdir-v1-1-dd781a2b3965@flipper.net>
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
In-Reply-To: <20260625-btrfs-readdir-v1-1-dd781a2b3965@flipper.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/26 02:54, Alexey Charkov 写道:
> Add support for generic directory iteration with opendir(), readdir() and
> closedir() in the btrfs filesystem driver, following the ext4fs
> implementation for opendir()/closedir() and the btrfs_iter_dir() function
> for readdir().
> 
> Signed-off-by: Alexey Charkov <alchark@flipper.net>
> ---
>   fs/btrfs/btrfs.c    | 92 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>   fs/btrfs/ctree.h    |  2 ++
>   fs/btrfs/dir-item.c | 91 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>   fs/fs.c             |  4 ++-
>   include/btrfs.h     |  5 +++
>   5 files changed, 193 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/btrfs.c b/fs/btrfs/btrfs.c
> index f3087f690fa4..c647c8dedf4e 100644
> --- a/fs/btrfs/btrfs.c
> +++ b/fs/btrfs/btrfs.c
> @@ -9,6 +9,7 @@
>   #include <malloc.h>
>   #include <u-boot/uuid.h>
>   #include <linux/time.h>
> +#include <fs.h>
>   #include "btrfs.h"
>   #include "crypto/hash.h"
>   #include "disk-io.h"
> @@ -159,6 +160,97 @@ int btrfs_ls(const char *path)
>   	return 0;
>   }
>   
> +struct btrfs_dir_stream {
> +	struct fs_dir_stream parent;
> +	struct fs_dirent dirent;
> +	char *dirname;
> +	u64 offset;

This doesn't look correct to me, for an opened dir, we should have at 
least the root id or pointer, and an inode number.

Not just an @dirname and re-do the path resolution again and again.

In fact, I do not even think we should save @dirname here.


> +};
> +
> +int btrfs_opendir(const char *dirname, struct fs_dir_stream **dirsp)
> +{
> +	struct btrfs_fs_info *fs_info = current_fs_info;
> +	struct btrfs_dir_stream *dirs;
> +	struct btrfs_root *root;
> +	u64 ino;
> +	u8 type;
> +	int ret;
> +
> +	*dirsp = NULL;
> +	ASSERT(fs_info);
> +
> +	ret = btrfs_lookup_path(fs_info->fs_root, BTRFS_FIRST_FREE_OBJECTID,
> +				dirname, &root, &ino, &type, 40);

You just discard the most important @root and @ino.

So what is the point here?
> +	if (ret < 0)
> +		return ret;
> +	if (type != BTRFS_FT_DIR)
> +		return -ENOTDIR;
> +
> +	dirs = calloc(1, sizeof(*dirs));
> +	if (!dirs)
> +		return -ENOMEM;
> +	dirs->dirname = strdup(dirname);
> +	if (!dirs->dirname) {
> +		free(dirs);
> +		return -ENOMEM;
> +	}
> +
> +	*dirsp = (struct fs_dir_stream *)dirs;
> +	return 0;
> +}
> +
> +int btrfs_readdir(struct fs_dir_stream *fs_dirs, struct fs_dirent **dentp)
> +{
> +	struct btrfs_dir_stream *dirs = (struct btrfs_dir_stream *)fs_dirs;
> +	struct btrfs_fs_info *fs_info = current_fs_info;
> +	struct fs_dirent *dent = &dirs->dirent;
> +	struct btrfs_root *root;
> +	u64 ino;
> +	u8 type;
> +	int ret;
> +
> +	*dentp = NULL;
> +	ASSERT(fs_info);
> +
> +	ret = btrfs_lookup_path(fs_info->fs_root, BTRFS_FIRST_FREE_OBJECTID,
> +				dirs->dirname, &root, &ino, &type, 40);

No, doing the same path resolution again and again is not sane.
> +	if (ret < 0)
> +		return ret;
> +	if (type != BTRFS_FT_DIR)
> +		return -ENOTDIR;
> +
> +	memset(dent, 0, sizeof(*dent));
> +	ret = btrfs_next_dir_entry(root, ino, &dirs->offset, dent->name,
> +				   sizeof(dent->name), &type);
> +	if (ret < 0)
> +		return ret;
> +	if (ret > 0)
> +		return -ENOENT;
> +
> +	switch (type) {
> +	case BTRFS_FT_DIR:
> +		dent->type = FS_DT_DIR;
> +		break;
> +	case BTRFS_FT_SYMLINK:
> +		dent->type = FS_DT_LNK;
> +		break;
> +	default:
> +		dent->type = FS_DT_REG;
> +		break;

So it looks like u-boot only supports the above 3 types, and unlike 
linux kernel the values doesn't match the btrfs internal ones.

In that case, I'd still prefer a proper convertor function.

[...]
> +
> +		*offset = key.offset + 1;
> +		type = btrfs_dir_type(path.nodes[0], di);
> +
> +		/* XATTRs share the key space but are not directory entries. */
> +		if (type == BTRFS_FT_XATTR) {

This doesn't looks correct again.

XATTR has their own keys, they should not show up among DIR_INDEX keys.

Thanks,
Qu
