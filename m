Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4202E5B02
	for <linux-btrfs@vger.kernel.org>; Thu,  1 Oct 2026 11:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790854092; cv=pass; b=cvC+tyTOq5G1Kae883n4jyA6I/KNL5Lj8tF3UR8xm8EwDXI8vr3A3tdA3+ZaL1D/7PFbPFuOJ/xANArsgHJ9sIMOytURHBRhoVClh2gmt7i1dHpf8q0SLNgh8o1qVLlAFWODgMLz41JkSWTFsNj/LiA2ri9v5MhYyqrx2Uz5CtU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790854092; c=relaxed/simple;
	bh=kOilubovPAGInISVMJtR1ZHplxPG8nAHmsESfzDQF/w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zp1paYW1SzC4s1eK50bS0XN+MC8vAJ4N784PHJ+ciMmLzmRsIpoX0vGwFa50R1Z3W/zD8LNUqfh0vju3aOg+xFzY0yOX4EMIdKYtcQTfqOII4k7EpKiU+peyscX+3wnnoCxHbUP9+HXQvQo+e5eKUYdDO6jj+VPQJZwaT0yVPU0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=geBep+SX; arc=pass smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="geBep+SX"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4834977ae75so3942539f8f.3
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Oct 2026 04:28:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790854086; cv=none;
        d=google.com; s=arc-20260327;
        b=q+Z6jHfs5+yVHfKGc2bzh4BmIMm0a5HmNBLHUfXYEK5u7hcyxMxFN0sBVufZ+hBHpx
         uul53m+4hUoxyF837Rnr82O+qBTLJXW3PlVYwlpd4Q/q7dVOrXAEq1lZRCmLhW26BMga
         Y1PLZu8nJus5TsZESWFOHE4kBy5wbKJ3OmXCKo3wA9obwk+Hc31E6p/ViabI/YQwYphR
         Ly9Km6sJStkj7ZwxaJirT46rCpVB3Lr+ZLcO+7V2QgYhue7OoMWtsDyEmO0QGojV+38q
         eMklyfic/pG54cFZVbQ2FgDeNSCV7J2lbXyyS39ZM9m6JlWfRYvL7B1a7EH6zFNn5yvN
         ybjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=kpuy5v07olr/kuhunTZ5ALwbN0QerYamg+QGoc7AZAo=;
        fh=RhFuKwp73/x8KksFPnzjZEYxDQ9t3rFtnoJ8q5GIsWE=;
        b=V1pEOpXokL+6nYFqnxKy/kRMfw3UUUNqErn9mLbsRtSwJurOVItyCQMyIZyEgPPNNz
         thdiMKZ47SP80kPb9i6rQiQrb1zKDibZPos3sZyIvrP/ZUqcLFGwmJFo2Q9GK9px5spd
         DT6vP84Lyu3GPs66MM1dwH2PVmiF3FqA8svaBsE1ckYObBnKW+gzQVUPKlcAOZfTMEjU
         TqFrg5kMNiLPeks1FAIV4FL64+PgDK/3pu2qi4C/3/zIaFfMd9YgLn89wu73Ie8AsDjP
         pF2mQ9i9mQGbjAgWP0Ao77Swnz1olYAFJ+eKnhkTTne9HWxOLNSdHZ1nUjoB8J4KOvKS
         s95g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790854086; x=1791458886; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kpuy5v07olr/kuhunTZ5ALwbN0QerYamg+QGoc7AZAo=;
        b=geBep+SXki69N0xJ65uSnvygA0MvCBYKV3oAE/z7H9I+9xLv8xzzJTwenykNKbP+nH
         qZqgfdR5MDUc6zYgKTfuMhD4A1xwALelc33FqSEmUos6FMlZhzxfHZGSiUAVPBAcyUOz
         VO1s2lmZFpGNjIuCx+EUZkYb3TowfgnKXNPm6hKQnnX7qXCQcEsqMl+ox/Cl+m2TyF1+
         yjeY6VhDMzKQAKd6/UyvjlWEznLWtxalEjsBHJNRpO6dxtrlGPvsN/dxJlwH4IZ+h4JJ
         kax3i3buq4hbljID/R6+oEodAgTS1McZctmINcK2VZzB/TPineVutu9gY1Qjr6iaGKZb
         DWyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790854086; x=1791458886;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=kpuy5v07olr/kuhunTZ5ALwbN0QerYamg+QGoc7AZAo=;
        b=fcO+9lbLDAM3LwUI5LOutL6/fQe/JELF7vFfpAHMCOB1yZxVO6DbuSIsBoDEg99L18
         b73S5MvTZUXSTB0e4wM5F/OzRvTK7qJsXW/ZBOEGaF3oApBBT0xHwgRdySDIJqgxlXHz
         Ht56gATBGWDmA993xgKxc0U6n1JCc2cTYRNyAOEkx0U+/ewF3V5lhsVqhJW0dLv7D+Hv
         RodjqyvG7k85s/3WDUSJrfnNlZFR3v3Uzjlt1pKIPYSXbqgNHmGvBg0CTxD6KRzff1Us
         Tg/2kRVFJkcNJ8Wz0nYz9Gr+P1FMGAnj77hRnxdwz1Q9HgCAf2sK705ZmDKno64krf4O
         D8kg==
X-Gm-Message-State: AFq9FYIqt/eovz4vbllH1dSUiVDTl6v/4Z/oWOYjMYMCCNQU40BaFFyU
	AOFQAH+aJOzqU/FZXI4+3rusL2KNG+f7gYJ53vZyCSmGIipoTyTzhc8yrh9nSowYfZ5t0wlGd9D
	YEc6HidrGPfSp/20cQtGy3lwVR9yAgki0F5pm4v9wTQ==
X-Gm-Gg: AYBFou0aEd/hwnQTW66C2mwXFFmjwp/g0H+9E3OJZk0IMStnKDrnfUBr9P286x4o6wR
	F4JIGdKWolGz7h5x8P4LEIYxpcCfJAEsGbIAtg+IiQQ+bAK7rpjDLOVQ0pYSfY91GOhyUeECPXP
	D3FmNXVpR1tCoqv4MesHKqT/akqnp7iwr2/KRiCFm72DqcKLgcqX2qJRzrR1SaU5vz9VDIQZvPA
	HzhSPrMb2UcO2Gt4O/AU05hG78mzBHRpioCKy6YvwC6644QBZnyz1TJrI/WZZ5hEECIAb/7hBxs
	sxEs1tdrcNR94JVLQi4qsC+iAEAQSgkYlp0+jBTJi6B76Uv3ZR5v/f2pel//srG/GRkD09CKDFA
	xSSqCddkR5u1vZ8wkiOkonv31ToA2dZANB7euARgTSsZNhy/Z+ffa
X-Received: by 2002:a5d:5d0e:0:b0:487:27f6:a4d3 with SMTP id
 ffacd0b85a97d-48b02512ddamr10084777f8f.35.1790854086511; Thu, 01 Oct 2026
 04:28:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0be3914031faf9bf34dd86daf884e42f7352d848.1790785074.git.fdmanana@suse.com>
In-Reply-To: <0be3914031faf9bf34dd86daf884e42f7352d848.1790785074.git.fdmanana@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Thu, 1 Oct 2026 13:27:54 +0200
X-Gm-Features: AclHuK9r9MtlaiA_OP9XgH3mDRVvO3QPu8a4vEdV1C2-vn2X4uyFkcCwWH1mHJg
Message-ID: <CAPjX3FcDhD8NxJ0dB9=rLWMFTqo2Qu8E9Xnf-mUApBf3g0k2rA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: remove unnecessary forward struct declarations in volumes.h
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 30 Sept 2026 at 18:30, <fdmanana@kernel.org> wrote:
> From: Filipe Manana <fdmanana@suse.com>
>
> There is no need to forward declare the structures as their definitions
> are brought in by the include of the linux/blkdev.h and fs.h files.
>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Daniel Vacek <neelx@suse.com>

> ---
>  fs/btrfs/volumes.h | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 337d7007d9e2..6eddda239221 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -24,9 +24,6 @@
>  #include "extent-io-tree.h"
>  #include "fs.h"
>
> -struct block_device;
> -struct bdev_handle;
> -struct btrfs_fs_info;
>  struct btrfs_block_group;
>  struct btrfs_trans_handle;
>  struct btrfs_transaction;
> --
> 2.47.2
>
>
