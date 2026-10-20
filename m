Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792500431;
	b=ytkxTtDo9+sFPyvc1XAmnMZjp3ibc3EC8gEBbFmb9gIcrPzB/cWzVNMRY7kPQaVVjzDi
	 KOZNSroD1rZpi4yMdXTwSnL49OpqIQk6y3CHKTIEE0W2WU2sErZBpxLP0/x4QAQuAIDn5
	 YiAyQ+BIaw171mVrO5NPYqvg0RE6I3H9cBCp3zXUKjo3pOwzBGmnSNA76k+P2blOTrsMW
	 q94IqOhEiH5H3oSV1qAK6UyXaIMBUrkuwRxF4sn4HIiN/EXI/F+qRx5s++Kcwg7OIIluh
	 LHbcaJdn0B2pLBoagp0Xr4avZQ8Shc4P+i5p+nEgcoRAJL8iy07W0+VrigCGQlgyHjQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792500431;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=lLItL1YHdAnoj6YQScoDi10VM8ecS2PSwGfi+Gc5X0o=;
	b=FDXIdpYf1Z4rS5/j/+KBVYni3sXaDhEnG67z/xxwnEVgMDI4e1JArTKuTqiVKNCjVa2c
	 pt5j2tYmUQSx+msigB2SKKPTmo+7/wRFeGO/UdhGtaMgzXo71Wu4xXkuMYEvwspdpLfvm
	 1lE8CrGc9woptts2//veHsHL9fgwT2/5hnHHZQd60qVwsA6DMdsJTHC649ZCdWNE9afEV
	 MBmwWcVbH8iK/a0KqfHo3UdtedHYAIZ6UHgL6a7kYvPzFwoLK+6VouqbjlQSWOsn4nBmt
	 MXrb+OgXhQS7M9/fyJ+XTdZMvHraZfvOCqEbwHa0UXZkEb2fwFiZiUed+FnqHe6tntg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=FMntUCIb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22A6606A31F
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2026 12:47:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C22A6606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=FMntUCIb
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48e011d370dso2612364f8f.0
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2026 05:47:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792500429; cv=none;
        d=google.com; s=arc-20260327;
        b=GyMONDY+Nwm/quQa2kLscJUjqA6uN9Vn5BjQB0PV4OlPatGQHBowk4b8tg/lgsN018
         rJS77BGsPDK3YQK0fRCdBDinzicm0ugyGFKNH2IymzCt/Aj1NhBac6GK4ncDkEFtCj8F
         HzURHkymP/8LF4Wdvj6GUGzGIfn1EZGKCe2FbiKOEAS+KOzRbeGI/Pddyi2hxsmkgNeY
         azFxPdZTXlxZemwT2QDL6rGfwo3BPJu35WnEL8KC3IP40tWukte16w2H8ACd2zCTfosa
         aQpWjhdIaux9m4NNH+9XqMEmu8mZDqtjtdffECFdBaukP+Ow+QblpihFk/oIoBxDNs0l
         m9Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=lLItL1YHdAnoj6YQScoDi10VM8ecS2PSwGfi+Gc5X0o=;
        fh=DNhRoUogv4njemsTPAOB4Tb4wfg3Mu7IYlLDA9H4+4Y=;
        b=q6U3D9sr2PNf+hS/6liOEGNA+tL0PNAY9n432+c+ZW+sGnjw1zDQv+Jn0bkOAWAjOD
         3xs2/LH1gyc1ilPr8le/6gIRzqdBAzKOvQi/jdxa4rBuh135D38YS7x4kjlN6XYziLpJ
         1bGAiIa157qCwGdbuOMQA51Qy+vR06JnOEipJc8fWmOFoCi9gUErJptrNeQKiDlM2YYO
         /d74rBB1M4+QHnqMNZ1ZTn5pWAhHQY4ad59gV3LirQqw1DeAwzgduaFCBTBJBFT8Zsi6
         EJArQlgdIHD9QzclFYU6X68u2+7LR48O5uuHgTh0QLSr2gAGaQOtwgvt+QsR/nzc0mSL
         Y/7w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792500429; x=1793105229; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lLItL1YHdAnoj6YQScoDi10VM8ecS2PSwGfi+Gc5X0o=;
        b=FMntUCIbVvAicxY53DmF/Ld7QvBC4GCXkcTYxdVIiR1NJkRHChd+/l9z/MNOdWpIGL
         EuVw7G89ifYqKDhJLrGsVgsUfQJO4Edeen2OV7inYELKva1HcKYjeYmtgjAX5QWzjLQv
         /a90z7TyqTo8hczm7Ojz/aBRsfyWisJzNb7GnDbJKpn7Zh578HZv7atlITXMRZe6+ky0
         jfaVSTvF3nLvdmAP7hrb2txDskjEZwRQRmML3/XeUZLBQB1u+eGwrXtR4G7eGYMD+k6M
         xBIT5cWISgVVa6TIdtr9zczRO2N3ljqVaTHPYNnu354rqRlWLFmfFmp/eY0OSIUkVAKI
         tSVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792500429; x=1793105229;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=lLItL1YHdAnoj6YQScoDi10VM8ecS2PSwGfi+Gc5X0o=;
        b=ZyiPFDG8voRbPqVh27LcHSXkJ47+mq0tDY1VdxFZzhebQayfrYp6ipk9ey42rG8T0a
         pRed8WSzgWnla7eicayGYwqlTIRTiW43jpnkLpTaq8waRYxZACMOKjvrRiJVXlxolV5H
         8q4veAMOqUZtQQ451RpOnvuwZ/sDnAskPeZbWwyivZeQrui5cNvUuLYcpej74L6LUIpb
         Vvuz9323dY77MuMm3TYx5hdIjWsuYeYNlCw9o7AgM9xBCMqQpxIiX2LO9rZZ48ctrtEX
         q0n2VEEM9QMfXAtR0fB4u6Uj1N2iKZbRpDxEI4ya7fCdmZdI8UQJP8WPxszyGE6EYpV+
         JnJQ==
X-Gm-Message-State: AFq9FYIvBu+98CNBChFMLLa1Pex/M4awr8bXR9mh797aAXlEp/tOsDTq
	aup0OkgikRkvNi2XqBDAyoSr2unBcuQ0m7988r4lPge0a5UdSu2DlfLYgNA+QUyCk0Q9LBgLobn
	Jhgtu+ZuxvY2ktfsipNHQeW8UBwSEmQcUp9ZUGFVZ5A==
X-Gm-Gg: AYBFou3/ri8J0vBVY0ELoxZOVQTGUchDsoZ2GkL+BOyVT9FHtsKl6Cgn1EVal67WM9T
	5uKeBopSt+fQmxUyzgk2z74wuo0IKA/jAuoEnoxnXnLiTlRAT0NvvpFgw86PO8w0m87xTnBcxUQ
	Szdva4GKZ9xfJ6jXEgRKkiUa6Dt6y5/KUdCFoBY5vR4G8YARL8q6J2sZ6TpoegHPRdjh63X3ZAd
	q/z8TuTTAXhI2UBFKq12vLUZ3JMpeh5GG+JxTQ9wESei6lXnncf31Nj98Mcp7vlJIsZtVDRUYN6
	DHogGLtX7MymxSqP/J2CLbnerGmmAR0ts11Wgn34lHA+twCS8cWC7t28dVc3SoQ3NlfA+LmMH6X
	hwICPF2g7HkBPnCc6Da+LO0tiNJ2TMzIz736zlrZ7LymSw942/TqGHA==
X-Received: by 2002:a5d:5e87:0:b0:48e:1fb5:eac2 with SMTP id
 ffacd0b85a97d-48e1fb5eae1mr4051888f8f.12.1792500429063; Tue, 20 Oct 2026
 05:47:09 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261002073715.2191177-1-johannes.thumshirn@wdc.com> <20261002073715.2191177-3-johannes.thumshirn@wdc.com>
In-Reply-To: <20261002073715.2191177-3-johannes.thumshirn@wdc.com>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 20 Oct 2026 14:46:58 +0200
X-Gm-Features: AclHuK_OTA415HtzJB64-EBhSQxHPATsNdQJde9SMwkGJdrWYpRkhUqX29JwqGY
Message-ID: <CAPjX3Ff0XK+aKepiaxKLq3A6J6v3=wfsVn2xfGWV43N7sS9oaQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] btrfs: zoned: fix possible UAF in wait_eb_writebacks
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 2 Oct 2026 at 09:38, Johannes Thumshirn
<johannes.thumshirn@wdc.com> wrote:
> wait_eb_writebacks() iterates the fs_info->buffer_tree xarray and waits
> for the writeback of these extent-buffers. Waiting for writeback needs
> to be done without the rcu_read_lock() held (because it can sleep) and
> thus the loop drops the rcu_read_lock() before calling into
> wait_on_extent_buffer_writeback(). But extent_buffers are freed through
> RCU, so if btrfs_release_extent_buffer_rcu() is scheduled while we're
> still waiting on the writeback, the extent_buffer will be freed causing
> a use-after-free.
>
> Similar to what is done in find_extent_buffer_nolock(), get a reference
> to the extent_buffer before calling into
> wait_on_extent_buffer_writeback() so a sucessfull writeback does not
> free the extent_buffer while we still have a reference to it.
>
> Fixes: 2dd7e7bc0282 ("btrfs: zoned: wait for extent buffer IOs before finishing a zone")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

LGTM

Reviewed-by: Daniel Vacek <neelx@suse.com>

> ---
>  fs/btrfs/zoned.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index d68b91008e76..261e7991c1d1 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -2513,8 +2513,16 @@ static void wait_eb_writebacks(struct btrfs_block_group *block_group)
>                         continue;
>                 if (eb->start >= end)
>                         break;
> +               /*
> +                * Skip if we can't get the refcount for the extent buffer,
> +                * i.e. because it was already written back. Otherwise an eb
> +                * disappering underneath us can cause a use-after-free.
> +                */
> +               if (!refcount_inc_not_zero(&eb->refs))
> +                       continue;
>                 rcu_read_unlock();
>                 wait_on_extent_buffer_writeback(eb);
> +               free_extent_buffer(eb);
>                 rcu_read_lock();
>         }
>         rcu_read_unlock();
> --
> 2.55.0
>
>
