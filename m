Received: from mail-yx1-f68.google.com (mail-yx1-f68.google.com [74.125.224.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40EC3002CF
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 23:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774393525; cv=none; b=qlJyhJJqbYv1vMnwYD2ztoxcXhzYzhoW6tSW5RyIBPN+DFSwOGKAOYr87qm7NveAJJ50LxFiXZ7MnPMJ2tsAnl1hAEbgw2MCXFu+hEztplvGO/RoFul7tSgnnELqLVMYm/VT22uMlW2f9JF3BauKqUBidfwrzZ6CGHo5SaZnIA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774393525; c=relaxed/simple;
	bh=/Q01G4eBht287KbEP8W6eJ3ydTeBP9QoA/LsZqJZnWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PKd/8oDVKWg5Q0AF+iaDbPCX9tJzwbq9brnBBOndbdtnhg1Y+FssXkS9g0pAeRJBtQTAV2uYoBjPOqFq4uLXh1juGyyqEB/ORQsktua0B+WGs3c4LOttFyVM+oO2ovErq+U6WaQmDNXDBgglgZTUGANa4YN0uo88CmcyFPYj3nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T+JF0h9A; arc=none smtp.client-ip=74.125.224.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T+JF0h9A"
Received: by mail-yx1-f68.google.com with SMTP id 956f58d0204a3-64e87a81639so2061432d50.0
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 16:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774393523; x=1774998323; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DO9+/YMBpO/xqN3fJ7Y1G2cb/OrCCby14Pr8bjlk1h4=;
        b=T+JF0h9AyZVg7zR2MAt1Qmkepk+huFKu74m0NdbdjnsuE610cJ5A7IUiD+mygSyUuf
         97V16ssoga9CUmqmRCLmC0VblcG/mKrI1ZpuWEp2jytKjTRBZ9jdkZsJcSgSA5BpKAC3
         WzKK+SQD9jvOt4MCOOdw9NqnLHrjYRFZ2XuTeMCiBgKqLF4qs/kud6uIztR1EPb1DLvS
         slfI6Xdv3fbdPpgJkCYREJbW7Ld5uXuqagTCPavaUkczU6aJARwu1fos57P6K0jmUox1
         Z4CihbxHkpFdoTmeHtXKftaKqoa9xadYgGv4EP+Epd23UVJSBtqZ/GY5cdA10Cx8HxUY
         GCIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774393523; x=1774998323;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DO9+/YMBpO/xqN3fJ7Y1G2cb/OrCCby14Pr8bjlk1h4=;
        b=VLmivUkQRUHsyuI4+zB9tzHkwPRY82NZ0tBaL1JSd+GYjm+9QwZxLc1/6kEtyoZh2a
         47ELLzSi4BbbmNtopjkpL2o79zyPOc3yx8VGx172dx9ptmWHe/cwN54GpccJYOMFBcO6
         16dNvPawgxbnG+6yJy8I+AymsGgYLm0N3wpbJRHVTCYn7dmrgXaEKamTnEEnEwfkI/Hd
         VeHFVSVohZ3I2ENVfMNkX5JW4G8bTdfhOsPmrNluNeS40Jrbl1xTxy4OsNGaUjtT4SN5
         A67iycwYZp9lGw3lLemS5oY0AcoUwLNdTW/nSTKYhTE4JdwcbH2vD6UJ4zpl8dslkI0B
         iDCg==
X-Gm-Message-State: AOJu0YzqUSA3NBqxajNMmuz6rcA003QdRUG7An7KrmwyMRJIKvKp/XzM
	h98SdJta8nDTLry0ja+WPWaINw2d/mQ//iFHUYLbzjFTAIyXO2zTwAT3
X-Gm-Gg: ATEYQzzaMUMbgu5QG8Hd/ALIeAMsYcqkKzAnx9eZ/Clpq4Lo+WjzowjPMRiFo2BmWEP
	Eh/vpO+H7aleYQtqtA7DWPrRdLcBra/K6DjBSFx79MpsvB0j5JH1dRHcGGlqadiOVBJMktmXlo4
	+i8l8/o3D8cfwsoyX2WwGlH4WGNHv86ZxOcBhNZDRN9ciiTQCYtPkEJIsztlRUAVrR3Es78pfTx
	yQvDZKzmAE48DQylfFBAOOcDczY3dlK6qPLgjjRntzS6dhFbtgwruP/fWE4IKILu7cm4cdHYI+B
	Tkm1aV7/ugsB92ZAxv2r5kqBgPayDTJWQCMlZfxKudoJzyeemzPLolx/BPihtFm2Qa3QS7yOiv5
	tk2qYtlMP//9eQuaJ10tJ3FJR19Enj//GyBBdoDQKlb+Q/3VU2Psvr61xk6mEerGt0D2pvP9iva
	q67drEsWywmZQCvyueWw==
X-Received: by 2002:a05:690e:1517:b0:64d:29ca:45f6 with SMTP id 956f58d0204a3-64ee6082fd8mr1284054d50.12.1774393522666;
        Tue, 24 Mar 2026 16:05:22 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:45::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64eabd8314bsm8556538d50.8.2026.03.24.16.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 16:05:22 -0700 (PDT)
From: Leo Martins <loemra.dev@gmail.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: Re: [PATCH] btrfs-progs: check: recognize verity item keys in original mode
Date: Tue, 24 Mar 2026 16:05:16 -0700
Message-ID: <20260324230519.57167-1-loemra.dev@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <298ed1b9-72e3-45ac-9d3c-41cb3cf50029@gmx.com>
References: 
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, 25 Mar 2026 09:19:00 +1030 Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:

> 
> 
> 在 2026/3/25 05:22, Leo Martins 写道:
> > Commit 4e88bb6e ("btrfs-progs: enhance detection on unknown inode keys")
> > added stricter validation for inode keys in the original mode checker,
> > flagging unknown key types as errors. However, it did not add cases for
> > BTRFS_VERITY_DESC_ITEM_KEY (36) and BTRFS_VERITY_MERKLE_ITEM_KEY (37),
> > causing any filesystem with fs-verity enabled files to fail the check
> > with:
> > 
> >    ERROR: unknown key (257 36 0) found in leaf 30621696
> > 
> > Add the missing switch cases so that verity metadata items are
> > recognized and silently skipped during the check, matching the behavior
> > of lowmem mode which already handles them.
> 
> Unfortunately I noticed that, lowmem mode doesn't have such handling either.
> 
> As I created a test case with verity items, and CI failed due to false 
> alerts from CI.
> 
> I'll send out a small fix for the lowmem mode, along with the test case.
> 
> Thanks,
> Qu

Good catch, not sure how I missed that, thanks!

> 
> > 
> > Signed-off-by: Leo Martins <loemra.dev@gmail.com>
> > ---
> >   check/main.c | 3 +++
> >   1 file changed, 3 insertions(+)
> > 
> > diff --git a/check/main.c b/check/main.c
> > index c96969fd..4fdd8867 100644
> > --- a/check/main.c
> > +++ b/check/main.c
> > @@ -1895,6 +1895,9 @@ static int process_one_leaf(struct btrfs_root *root, struct extent_buffer *eb,
> >   		case BTRFS_XATTR_ITEM_KEY:
> >   			ret = process_xattr_item(eb, i, &key, active_node);
> >   			break;
> > +		case BTRFS_VERITY_DESC_ITEM_KEY:
> > +		case BTRFS_VERITY_MERKLE_ITEM_KEY:
> > +			break;
> >   		default:
> >   			error("unknown key (%llu %u %llu) found in leaf %llu",
> >   			      key.objectid, key.type, key.offset, eb->start);
