Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793092705;
	b=L2aK8eq4RsC+eNC3ENszWy1lFpFXMkbErXnutJco1GPP72Ta34qBYajD6jgZWXi44Rzn
	 42XdPcg/UPS/1/QLbMGTqUWJgAz0GGyaLUR63pGBlY5tPh7wTsVhN5DoGamqlGaZiU0CT
	 fB3G1aSZyduwSuushzx1HUcbReOY3vlA3Lvr8VCctnRJVOOsk43kQ36kWhTH49W/Ol3hY
	 zGu0fGa5XWOjTokcu8ZEtbDvRhBknZ78YiwCFGg0/9BoZ4d4T4KXeujqtred1213LIW4F
	 pXDJzyahTvG1GhHT3fg2h8B1m69UEKRMr7lRRpuqOY/aPvqlAvOojhJ0PjGfbEs20LQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793092705;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=vZPeidYaAVFsNG1Vq76ZziwTvgXOeD3Vz/83HIn1SAM=;
	b=2pT+EHbrW5JxRG8/lBhkmFdqFHVnaUlzWkMl4S9/G8r2u/oVmNgwsDI4PQsYfusZfG3z
	 M5Im56xaJDo4VG6wGMHTvp0cCB+2j6HHWx2t+45Wng/6ETRO7ZE0nf2fnQrLBuDWIngfM
	 BHFO34wFoDOOHy6kkdI7RkDILipr4JWG/T/WqWGy2fkNAh8YMUAK12YwwIkZgIRBFPP0s
	 2/qu/LVgsCugnV+2ZEkrMcrRHrl46HwKEOcwh+6KQQ+1dSiZsJqXVUjJ89Ko7SSbEHPdO
	 E4HpgRQC6veIsRL3v5OCgKTD2YNsJX61MLZVwdb4v6IDzAus+fFqS8F01dCa1py2uaQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Spr+jpvY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A16606A31D
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 09:18:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02A16606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Spr+jpvY
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a208d93758so44603735e9.3
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 02:18:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793092703; cv=none;
        d=google.com; s=arc-20260327;
        b=W9BzZJC4Olwf6qjgKBlUxD8tPohmotf6AHXiFZXJNvmOctcanXVfddf4fqat73hafR
         rsCrQAQHJupKP7sh865nodSBEkga29GurIUzk9+4dw42qTJURTcn1WZ63hsJXmA840EZ
         i2gICsMHA+wyG9Qo7S2paH82Ee9B48KSiWCaZf1v+DZ/S6DVJztuZtQ17aQOQFZYDI8P
         G3U5MVRrIlofK2qZMZPAidG5K8fbDTlRcPuNyJi1wI8Gjrd/zXD3u0ZOVy1qx3jemxdP
         zcqIqViuYbN/oSQ6RMAE0iKYe9qwBeHljm0YlkZyzlMnAAsRyvqCKPCdyFPhfHCo/VOL
         bm5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=vZPeidYaAVFsNG1Vq76ZziwTvgXOeD3Vz/83HIn1SAM=;
        fh=gccavu6KskZuhdxKZGGZqKbRpE8AZv+Jw1v9OVMw784=;
        b=kPIgjPomsi9Zp2JHjZAu4yUbCiRSMPmmardSud6O5exXKYago5R+L/t3cyGzQtpLES
         at6Po1mN3nFYce2L4QCNWuqvzmT2LiyqQmSDGtpadJ2g0b9K1crya6vBlvvskY8myUmb
         6x5kyXvexbhkr8HEr4IUkJyEuAASWlqEADaOWEUVYgTLBKCu+wZjyBUnFQAqgZ3fwAv3
         IQTFk8GyPMScWhVYc7qnk79tZLTJrq92gJGf+Ps0dwDMPGLFTN1paRvNNFVVQwLsp2JE
         xbrr/h3hFN9pYuRMRLaZyrnLQRtdZIXfB2EAb8sbPNgadgBZE7aIl3Ss0Ty/k4gyxHkE
         5u1w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793092703; x=1793697503; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vZPeidYaAVFsNG1Vq76ZziwTvgXOeD3Vz/83HIn1SAM=;
        b=Spr+jpvYBHP+JcvaAztF+AIqA9gD5RZms5pm/Q0kaGhHTR0ihG1LxKTTrJ6STQkUr+
         3SYOTIY4bJCN8ZvCq2+5A75Rq4cA7c1674mOAyjHLW06B82YtzbP4s4uWmU6hQ1QnrlU
         x33x1YRVb21KJMtJniZP+i8scIOnWGApZL/DwLtBDvrh399Fj2Ye1sdL/o1+bs13jQ6i
         zgszy2Agn7CdUthcKWBzbNonmyWgzBvw1WeX23B9R21iAjhHVx3lXuKdTQGYAM0L0H2Y
         /wD+FgI8xQ+jDkpOtHRH5wbGY6kvA51u/MU9E+R4yTlXaXrVcDrLpdmJtwU7g2xQyEIQ
         4aRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793092703; x=1793697503;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vZPeidYaAVFsNG1Vq76ZziwTvgXOeD3Vz/83HIn1SAM=;
        b=eA33vgNOVpdjMRaWCUkshNhvsIdY6Ed5j8WcrwFWRE44ZA+/ELx9yZguhqEWSRjNqc
         eTu5TypKOFi33H9WTss2RxdMe/V03fZ9EDzM0XBhc6MfG80aTXO36VMoz27+L8tepxbN
         mfZGTAhbo8MiVc9u1scH4/38/gOz93K3Q0EOj24swfcCeJuhf/FRKHmXJPyh5ReR9sxC
         3Y5FoTj3msmRLN66wV3Pk8tKKElFVvkjZfJO97/QoIWPZFrAd6YyXww17NyorXa1QPWi
         MvEiuWUarWbppQqeb7lS6nlXfivZUqC5aWmH/GpDBRtWxSyfjGVBkCq6ueGJwmanyP7X
         i+fw==
X-Gm-Message-State: AFq9FYLLqbuH0Nz42SuCVOu4GqosPzsWMIa0WfWXF/rJa9aCP1uNknus
	3qwYDGcJe4WgiurzwaQVHSzuFmgoi0PHWezKQGhAyB5l02PsZeSXPHxp/BJCecUjsl8MD2gP5Ho
	h06AKtbwFGDKx9+rodpjbTAxLIJ8QxogOtm+IPMrPC4hCz+3/1GKT//0=
X-Gm-Gg: AYBFou3AO2PZX4JqYsDmD83vuhCgYjbk/qcuGT2zNgv+gz9MU7ohEE2bzk/04MGu6Ly
	av9tvy+rGAP/pGbawj4OS6EpSBzvbEkqw1OR95tlqZL8RHGBV9h9wxwtWoFZNHDI/yea1b12yo/
	T+kLp6Oy1nd/cXSGeiornTdYeKQBrwFMZlEnX9ar8HiHlfNI1yrPpaqPXdeDgKBVXbJSpk+X/Fl
	C0mF633ErQ59CYGVRpS6MCclG3tQtAHEd9sYe4ylAePFLlFjwQDi4EpZhu0bnPuFGIfdIrirnuY
	zBOgL08yypJIaTfdKBa0Zyc5C+sboY949WpgdkA5NrUYQXbz/fvQbLTyqN/Fk+9kPRkblN/KJfP
	pgboQTn1ro1UYPif/GI3nXpwE3bNmMP4fOwBp0b27d10yTxchZR77wgy6hk5U6FJgbMB5UhzzaW
	hq0ZAA/W9C5r5wd1QC3mplJgXRjIue6Re+lOBAr5YGvK38RCH4DI1OW8cb
X-Received: by 2002:a05:600c:4746:b0:4a0:1c10:1372 with SMTP id
 5b1f17b1804b1-4a35acafcbemr160359635e9.27.1793092703395; Tue, 27 Oct 2026
 02:18:23 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1793090084.git.wqu@suse.com> <c6f4910af35bae312954f65abe096b08f2e09a41.1793090084.git.wqu@suse.com>
In-Reply-To: <c6f4910af35bae312954f65abe096b08f2e09a41.1793090084.git.wqu@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 27 Oct 2026 10:18:12 +0100
X-Gm-Features: AclHuK_hmJQhRT-3CkPaK-1p97qC4w9NK3f8jD-nlnThWpl3WRaBMrXwBInqqDM
Message-ID: <CAPjX3Fceg_mLAnyvZaHLYQ5y+3Xjm2MnHVTq7r-gnEWgEm7AAg@mail.gmail.com>
Subject: Re: [PATCH 1/2] btrfs-progs: remove set but unused variables
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 27 Oct 2026 at 09:36, Qu Wenruo <wqu@suse.com> wrote:
> If using clang to compile btrfs-progs, two warnings will be reported:
>
>  cmds/rescue-fix-data-checksum.c:73:12: warning: variable 'global_repair_mode' set but not used [-Wunused-but-set-global]
>     73 | static int global_repair_mode;
>        |            ^
>  1 warning generated.
>  cmds/inspect-tree-stats.c:43:12: warning: variable 'verbose' set but not used [-Wunused-but-set-global]
>     43 | static int verbose = 0;
>        |            ^
>  1 warning generated.
>
> Both are correct reports, so just remove them.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

LGTM.

Reviewed-by: Daniel Vacek <neelx@suse.com>

Thanks

> ---
>  cmds/inspect-tree-stats.c       | 3 ---
>  cmds/rescue-fix-data-checksum.c | 2 --
>  2 files changed, 5 deletions(-)
>
> diff --git a/cmds/inspect-tree-stats.c b/cmds/inspect-tree-stats.c
> index c6907bb0cd78..b45416fd16b7 100644
> --- a/cmds/inspect-tree-stats.c
> +++ b/cmds/inspect-tree-stats.c
> @@ -40,8 +40,6 @@
>  #include "common/units.h"
>  #include "cmds/commands.h"
>
> -static int verbose = 0;
> -
>  struct seek {
>         u64 distance;
>         u64 count;
> @@ -462,7 +460,6 @@ static int cmd_inspect_tree_stats(const struct cmd_struct *cmd,
>         while ((opt = getopt(argc, argv, "vbt:")) != -1) {
>                 switch (opt) {
>                 case 'v':
> -                       verbose++;
>                         break;
>                 case 'b':
>                         unit_mode = UNITS_RAW;
> diff --git a/cmds/rescue-fix-data-checksum.c b/cmds/rescue-fix-data-checksum.c
> index 3925d5170627..121fb0b46ca8 100644
> --- a/cmds/rescue-fix-data-checksum.c
> +++ b/cmds/rescue-fix-data-checksum.c
> @@ -70,7 +70,6 @@ static const struct fix_data_checksum_action {
>         },
>  };
>
> -static int global_repair_mode;
>  LIST_HEAD(corrupted_blocks);
>
>  static int add_corrupted_block(struct btrfs_fs_info *fs_info, u64 logical,
> @@ -486,7 +485,6 @@ int btrfs_recover_fix_data_checksum(const char *path, enum btrfs_fix_data_checks
>                 return -EBUSY;
>         }
>
> -       global_repair_mode = mode;
>         oca.filename = path;
>         oca.flags = OPEN_CTREE_WRITES;
>         fs_info = open_ctree_fs_info(&oca);
> --
> 2.56.0
>
>
