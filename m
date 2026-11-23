Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795438859;
	b=24D2O0zbnIbTIpK8BULCW5td3wOVZn7dZk+hl+ug36wsr5KP81Urr04NNm0avQ46HHdT
	 iCcRiZx6qDVgSCJQGERQyFLAqN410y0nBajMVDwUxzjdmp+a3/IF/Cau47lerxkdbyIhK
	 +wF7rpf3wamC9fqq8cPfjvLCqpX5JcOjtoo6JN/XINt+wWFpHBop+ogZap2IusdTiuQzq
	 qUN0M8oxGPzHM+12/mIBTpQNh32WlzveVllwkY+vhTXxmmTHkN7mMNML/Xy6IvrmUWxHD
	 pfT5xptNxAtMJLUf/ndSZ/uojR5YNp56nZce0cX+vm7CqLBo4RurM1WEhECx3q28yzw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795438859;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=AMCJ5wbvnIEodr6Bx3XwSyi7m8Nqsc1HfBhVMog/o3w=;
	b=p6isq9UWZ1+oF5j8iKEsSqNFA2/itIHs7GwTIgLWk3/8mS0MGaf6axkfqRPnUevGwHtZ
	 L5TBecNY4uqnWL0bE0sNOohUmBQcjasr8/98EKutTF+4jQ0tjbpHeGq6dk4J7ykhJiePL
	 PX8nNbZrkO/uK3YYi5aES3oe5i4vk7QsXXRi8ZXhLrfYUzkHDqTEDGybQ+QEVIqz2WQ8a
	 XpuhnToVeETf/JZYV7Ix8IgmrFXQ/vYbLu3kIa9G+j5RuuKlPaNXPIs+JKYvaAALy3rWk
	 sDVQM0MNS7RVVROIQj2ltenj9NVoDpQGQvG6wqJDdlYgC5TK4NV9nu6KlpHCYBIrfFg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kkson++k;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29AFD606A32C
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 13:00:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29AFD606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kkson++k
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b547d6c07bso4086258a12.1
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 05:00:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795438857; cv=none;
        d=google.com; s=arc-20260327;
        b=XNL7pePIapmN4b6Rnp5cgy4bAAoFanLdNv+ygPiCdp9mdRWjyoVZv1Qws0JkDbI2om
         pT8QI0ovaX7Wl1pzPGtABHhrG8GwqVmP80E+YXi9WnKn/dLm4Zp61fjArD8TRFL/JLHW
         5HjU2qK+lzTnebc5S6n0mVZKA8ZWR9m1G0wj8pSagr1Na3AuYfDsaXJ1ssLIOC1ImlFi
         0Ys7JYZycGYEOJTkGG6qD3bPZKFOJLwsxil05nyWrZun7MRpXMBB0CKmgeRGtSIXsFo6
         od2a43q1PWphEGCdsWqocBsPrckmrcZ1jaEGaGIN8UJZBVYZRvpiEYw4gh8j/yjehiL+
         KEDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AMCJ5wbvnIEodr6Bx3XwSyi7m8Nqsc1HfBhVMog/o3w=;
        fh=WTfpZKaxQmiYlC/dvaZj7XR2praS/732r/IUSYLWP0w=;
        b=DxLNVRcceyJ66d47ECVg/R1c0uLJ6lnYeAGPyOQhLBCareUexhubdfIcWMAvZapV3X
         R0JbWQ34EkhLId+extk60CkolsWIBCrYTMidKtOFOqAeMQbk8RCyOVzbY77SMvavF41s
         aH1tlBGcsMToGSJYOsSAVQgRALGGNfGOKbLntuLZlD0bwV/+nNrMJUxt53+PBHyH2S2O
         eLUj+nJwBxpFaZJ+YtJRqe7MpS36W30d0IxyzEmL8kcOcPzVjArlGVQvA/Ro1l9lVsRh
         NPSVSnaVTsB7eyGXlUgRp68KoarFSTsf0Th3dy1KAaOw5f4VvUaTAIKw8UXGtO0tuPG7
         JXcA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795438857; x=1796043657; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AMCJ5wbvnIEodr6Bx3XwSyi7m8Nqsc1HfBhVMog/o3w=;
        b=kkson++kiVuuq7GlVJEDUrQHu19KcH/nihH2BzgLa6gbrvy17AZmxY1D1w0dt2h46y
         /xXI9YCF3W8v6AnWEDT8Xid0rKVtto9xbQeFZkRGR+cb5Y8RIC0oMxupLBYaYJC4CQou
         6ZJgLzs7wocf6G/7L1QJdpNwS2lbDAistHwZiRuhKs46qZQI5UTzUa+r+vixCZl4Sxxv
         NpVQv5tq4rxjVYt/Ok4zCR0OsxODa6kreqGz8wEkn4nw5GUASkqE6hP4ExSDLRPowFf2
         0zimep72RFU7EbpYHdPGxIgrdpvUiN+7UnUUrPJ6dRIQHj227oDE5EmUxVXBkiebQasL
         M4cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795438857; x=1796043657;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AMCJ5wbvnIEodr6Bx3XwSyi7m8Nqsc1HfBhVMog/o3w=;
        b=jQbg26gnWESncbVvtzwifZJTF0+f9ltGONhhvPuAeY5U5lnkAzyxEJ0WklBEB5yy94
         a3Fg5L0Rxg/NDt0fz/+JKTvr1Ns5GlCqJRII1TI9n5YK5md0GW5IjeZdleLsIWykRqaQ
         AzmbCdTAbnmggu4S15aJcSd4/HEJo8kSW/oYRxjkMet+LfRLyn3Ojjoo9NPWeb/pzNdd
         WwnWjRedMcpffwlPxCcXiKcUHFdSwaU5B5VKZC3udrBboLzVIoRgaslF4N8zj/Kol/P4
         G/Fwy/sjJ4turn4OL9iHhUyNC/JK1bd7w0vjVutNn5AwdFq1aRHz2cq5w8a2Bov/HLcC
         qHzQ==
X-Forwarded-Encrypted: i=1; AL+hErENGOarSdwYE8cHz//qfAnvJIJxNRm+pTevlnSGGOrrFaJ/Ol0p5CRqTd6yJFiQZE4tNGxBfPIsO+L67A==@vger.kernel.org
X-Gm-Message-State: APuU4Z/ZZ/YL/o7J8j5l8PM7+3v0a2RZmI4ificWSRUlmYvFO/HiWqLG
	eWzUoBAWPkugGDIPwdx9cwAMzPExnv83fQ7ClmGfBvwmXJrEmXpRbKRVBx/9kKZo3Yi6ncqGeWd
	p6TKJv4NvoMLmdD6gYzoxapKt0W58d2I=
X-Gm-Gg: AZFdTZei7HcEaN9lN3QmgiI+mhbgg5kn4yMP62Mvca6/RgdN0/AWcpsjQbwHDWEm/xh
	EAqDAUGkKSfNaRLYBYM5rc8hQQ6SEgvZcbG1LXcJMrc5AlGGZJFjwWQMvgAA1pIb1l81y63Y6Tq
	NDHliFOidK7WYLkrTdjp7Vcc5e+cnJAQ1a6VfE6wjKOzR2YXsSjzR1mbfRMmhTjJfiK8toow7dk
	8hfW2vcEPH0QXZUj93oQ8cKZJn+TrvIOMwIgd57JmT9z1hC2EC0DTBhu5vpkwXkqHzDihOYmbIn
	VstbxQMXyDoVhV9Uxpt8hDQ4tvWfV8gn4mHYfJsQYpb+ccsak3muRntyUwRIinRj67B7nTVIMxk
	srH0rIaE8qpfspQt+EwgcQyXdRy2BOX7LyFQqTZuba/MK5VfbA6JPseALYy9yAtFhKu5vnw==
X-Received: by 2002:a05:6402:501d:b0:6ba:659c:8ca3 with SMTP id
 4fb4d7f45d1cf-6ba659c8fb1mr5474446a12.10.1795438857096; Mon, 23 Nov 2026
 05:00:57 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261122000856.536902-1-koray.fra@gmail.com> <20261122000856.536902-4-koray.fra@gmail.com>
In-Reply-To: <20261122000856.536902-4-koray.fra@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 23 Nov 2026 14:00:44 +0100
X-Gm-Features: Aa3M54oIZEz33KQbWl8M_WOYBLraeDplxcWm8_8Bl8KeH9NFv_L8S3OGX6_s9I0
Message-ID: <CAOQ4uxgc6pP+_xvJMbqj6wOdGzS75Vn6x6i_vUfCJDD46DAA_Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] ntfs: switch to the new xflags fileattr API
To: koraynilay <koray.fra@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Darrick J . Wong" <djwong@kernel.org>, Andrey Albershteyn <aalbersh@kernel.org>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	Lauri Gates <lauri.gates@gmail.com>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ntfs@lists.linux.dev, linux-nfs@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 22, 2026 at 1:09=E2=80=AFAM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> Switch ntfs_fileattr_[gs]et() from the legacy FS_*_FL flags to the
> modern xflags (FS_XFLAG_*) fileattr API with masks.
>
> Introduce FS_XFLAG_COMPR and FS_XFLAG_ENCRYPT and add them to
> FS_XFLAG_COMMON (and add FS_COMPR_FL and FS_ENCRYPT_FL to FS_COMMON_FL)
> to be used in this API switch.
>
> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.11
> Signed-off-by: koraynilay <koray.fra@gmail.com>
> ---
>  fs/file_attr.c           |  8 +++++
>  fs/ntfs/file.c           | 63 +++++++++++++++++++---------------------
>  include/linux/fileattr.h |  6 ++--
>  include/uapi/linux/fs.h  |  2 ++
>  4 files changed, 44 insertions(+), 35 deletions(-)
>
...

> diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
> index 50be49f4c913..fde6fb2fe39c 100644
> --- a/fs/ntfs/file.c
> +++ b/fs/ntfs/file.c
> @@ -155,31 +155,37 @@ int ntfs_file_release(struct inode *vi, struct file=
 *filp)
>   * @dentry: dentry to report the flags of
>   * @fa: filled in with the flags of @dentry
>   */
> +#define NTFS_RO_XFLAGS (FS_XFLAG_COMPR | FS_XFLAG_ENCRYPT | FS_XFLAG_CAS=
EFOLD)
> +#define NTFS_RW_XFLAGS (FS_XFLAG_IMMUTABLE | FS_XFLAG_APPEND | \
> +                       FS_XFLAG_NOATIME | FS_XFLAG_NODUMP)

Nit: checkpatch may allow 100 chars, but this due formatting is not
easy on the eyes
pls break to RO line and indent the broken lines below (


> diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
> index 4faa40febf11..219e7c8eb601 100644
> --- a/include/linux/fileattr.h
> +++ b/include/linux/fileattr.h
> @@ -7,12 +7,14 @@
>  #define FS_COMMON_FL \
>         (FS_SYNC_FL | FS_IMMUTABLE_FL | FS_APPEND_FL | \
>          FS_NODUMP_FL | FS_NOATIME_FL | FS_DAX_FL | \
> -        FS_PROJINHERIT_FL | FS_VERITY_FL)
> +        FS_PROJINHERIT_FL | FS_VERITY_FL | FS_COMPR_FL | \
> +        FS_ENCRYPT_FL)
>
>  #define FS_XFLAG_COMMON \
>         (FS_XFLAG_SYNC | FS_XFLAG_IMMUTABLE | FS_XFLAG_APPEND | \
>          FS_XFLAG_NODUMP | FS_XFLAG_NOATIME | FS_XFLAG_DAX | \
> -        FS_XFLAG_PROJINHERIT | FS_XFLAG_VERITY)
> +        FS_XFLAG_PROJINHERIT | FS_XFLAG_VERITY | FS_XFLAG_COMPR | \
> +        FS_XFLAG_ENCRYPT)


Rule:

You cannot add a flag to common without carefully auditing all
filesystems that support the legacy flag.

FS_XFLAG_ENCRYPT can go into common but must also
go to FS_XFLAG_RDONLY_MASK because it's read-only for
all existing fs.

COMPR is rw for some fs and ro for others.
As with CASEFOLD, you cannot make it COMMON before
converting all casefold fs to new API so that each can say
whether it wants RO or RW.

I think there may be a way to deal with this easily since
ntfs doesn't need to set either but not sure.

>
>  /* Read-only inode flags */
>  #define FS_XFLAG_RDONLY_MASK \
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index e40806b3a69c..09fc7e066485 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -275,6 +275,8 @@ struct file_attr {
>  #define FS_XFLAG_CASENONPRESERVING 0x00080000  /* case not preserved */
>
>  #define FS_XFLAG_PROJID                0x00100000      /* project ID */
> +#define FS_XFLAG_COMPR         0x00200000      /* Compress file */
> +#define FS_XFLAG_ENCRYPT       0x00400000      /* Encrypted file */

This is a mistake of patch 1. the newline should remain above HASATTR
which is allocated from the end.


>  #define FS_XFLAG_HASATTR       0x80000000      /* no DIFLAG for this   *=
/
>
>  /* the read-only stuff doesn't really belong here, but any other place i=
s

Thanks,
Amir.
>
