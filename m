Received: from mail-qt1-f194.google.com (mail-qt1-f194.google.com [209.85.160.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332E431B824
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2026 12:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.194
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781699054; cv=pass; b=L63bzGN70CkyTdc+ds5JBnJVwVHSo5Qn+C1w4pwQvEEl1FZZhZ9hXHuofcM7obeOhEV5injE4Lut2sJBHSjBpj7fcuvBwhILbFMuclphBECYrcpUA1UNl655SCs6tjtQmR32D475nuDzChtyX5lPXoL5B5p8Yr/TX3CMaiRKy/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781699054; c=relaxed/simple;
	bh=QQfarc7P2g/vPJjZH2/y9vH76Qyhi5laphRiXVt5Dbk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AlByUYtlglvbxBkFcQpBi7ViZc3ax1kJBC3x8KW6yTY7hDXrD/jc/RfMzN9FhVwNNktSutQUCeGbbiasheU9Y0DUMamGORrOrCt8cxQV6dY1pQAxaVtRmyhMPBXJvJFdNL5IAqw8MF5senS9zpuY4zvMv+QnYumrly/PK577hQ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SEpbGddh; arc=pass smtp.client-ip=209.85.160.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SEpbGddh"
Received: by mail-qt1-f194.google.com with SMTP id d75a77b69052e-5198999b8edso1414071cf.0
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2026 05:24:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781699052; cv=none;
        d=google.com; s=arc-20240605;
        b=fSa/csmeJpf+A5eJ3dX5P6w2V74EjiHdTWrbW9sp1lFsOv0zoYgOE/cEJaCWk8hDtG
         Zf8zyDXXswVCUwmTUG4pLV7hplDQuKFL2tJpngh9unZMaG/rP2UxvzJ7w9cy5elSP6Dk
         uD0qzXRZOrHIwQCEYi8HG2DgMfHnsQDNFuE2jGmaD2BkS5gtVa9eQRi6tHqgzbfNvvWT
         bQBdmHx5k6v0BeuzYaw29nZdNOW+5ycAQZ3ibksbfF4KN9SQ1PKJhDPAr0L5pCps/yjD
         KEsUu5ll9Ql1fI4E/E1CJs7UzsVlIzEzcIbkNgJ5JoJ2I5o7ytuNwEQhwmz1xnAmB2vE
         UkTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=QuM3vlDwKyV8f4I8Y55JvZD9AqzONd7Rgr/QrfyVRO0=;
        fh=vqBe7sbvD6d2BlnP+ONjbWN50+ZRsDKItc/2QOYFgYw=;
        b=hiAt/zPsxAhrDq0O97Sii37TWVzA00os7fs2nk3kLcX6qTJReZKpDUElujjZldyFLW
         XDxQyGtT7fDAgSZLN+KJXU/+8w4clzbizLt1uSJm7LKRnskPwPvtC8UZ2DEj1Elg1lxi
         V1WXfGrdAtJ1SVBvlhkkqsQXUBpdZMW7CWMvT+651HK1zrGWk5uLaJcEoLHxpZJOQsfk
         XEHMRKEJ8M9vKlWBXup/0arBO/w5XaBsHw1j/CwXund6ja2HnFsC3MLEx6NwkNDioZt5
         74WRQqODfC3SwVX9HIOukqqhc8S8VNHZLyJkehJhJ6Ry5BJJdXuls+IEihaTbDli6sct
         NkIw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781699052; x=1782303852; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QuM3vlDwKyV8f4I8Y55JvZD9AqzONd7Rgr/QrfyVRO0=;
        b=SEpbGddhqCsBE++61BvlkQrz7bWroAJXM+0piv7JRnMVMkP0FVXzkIsnw+npW6COf/
         ObS1bGhUgBAU2T5uf3TzMf9utM6a8KlSnTXB/+vynu0+1c8aP7fUMTE+f/KQgoFlZpG7
         lVFLhY/2Ywy9pJRN4cL4x78hSpKqd8y735DxnhL05pEi0oiVRrdEvc/1FXEumZiMv2he
         rsdjW4MVz6JtrAOBqA5+jqCfB2ukVYFOa2IYNGhBLZ1wcppDraABwymqTCu+lxWxoZaZ
         Pp8x6c5gejl6b5+afdYEqCaibtXz698kaZtI44vNaLSzdes/UItYh5VBLKV07rcXK6Ds
         ow8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781699052; x=1782303852;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QuM3vlDwKyV8f4I8Y55JvZD9AqzONd7Rgr/QrfyVRO0=;
        b=EH6kVOg9WAFJL3/wvjgUD3Ala7FdBzj6w91Nt019v9lpsnc64Bwbcbbit3NHZca9yz
         BflgHlmP8Yrq6xBKOrEeYXM4jQX3dL3iYOYKdoZXgFq2rNNCfPmLDM8nh+b1d85vEK4b
         5WsYjntz77LJWKwwv317Z5EDSCGEC28MQQQ2W6ocrZLzZcXJRBnDbhgaF9BuuZzhugw9
         QdFJpop11tDy26VCPNaoGWkYnpRSplOSviDbHjccGKN2dg5oek0FOlptwVGtWrH1WFa7
         Y7h7v6N3F9OeK7a5uu+H60rE9Ll/mk78GwbaETq/EuClOlFB8OpM7qTiQ0KY8tigqZq8
         39NQ==
X-Forwarded-Encrypted: i=1; AFNElJ9l0P6K03Ipi8Qp1koKPCQ+cR1SjNoMtaPOQYinbiGwaiyqSDVkQawDWxWlmKyFqaHj5aNdNjB8g33WUw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxtg1lW2xbe9aEyCZcGNuv/BYS0CZS+gAwchR8BysmPFv51UQkW
	7mCerdUmMHNMdKMO3fQzd6fRnw9419pqKNGdbhEdJb7xRP4l20hXrCva9Y0Ke5Vm4CQ4uyYrsLK
	K5qm9UkZH9qE1g65SrfY2zcoaqb6SQd7TO3eC4gEAYKi8
X-Gm-Gg: Acq92OFdLjIdIuRoFUruaUEw+QoHQMXyMIxhlNeBjbqLBbTuBbVbbwYK0i6qa1QhamP
	O0gZ8nkATh23GEoobpI3NJAO/8L8wGu6Bd5q6kSePlpahZfSqhhNCJx7JhsKc2Ng/3yzPpzhGQL
	WKcz9EocTxejqq+UL5tKvS7kITAmDDXV+vXpJHWjoUjEy6f5PCNjiZ9MKk1r3Z7Gh0t9hoY0030
	9ZAvKRQcT9a5B2qPvurBFChn+YDCVjeuVrdbTt2kgKJq8hxXmlqe6e6l1+sp8qJqDLVCbGi97yE
	JDpg74lkfkxIIC4jwuX2XRud5uSQ2KQv/q93TUse
X-Received: by 2002:a05:622a:164a:b0:517:5e32:f3ac with SMTP id
 d75a77b69052e-519a895fe67mr34487981cf.0.1781699051985; Wed, 17 Jun 2026
 05:24:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260617120431.381916-1-johannes.thumshirn@wdc.com>
In-Reply-To: <20260617120431.381916-1-johannes.thumshirn@wdc.com>
From: sun k <sunk67188@gmail.com>
Date: Wed, 17 Jun 2026 20:24:00 +0800
X-Gm-Features: AVVi8CfVBOh_UygOt5aj3JpvLhQ1raQpbPUa9Q93BpUCRTpHOoW05av6JogljKU
Message-ID: <CAAuSuOrRF897omi1SFm+wUUs87hiHN3cz6NZm2L3J1-hRkcSDA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix RAID stripe-tree lookup across leaf boundaries
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>, Qu Wenruo <wqu@suse.com>
Content-Type: text/plain; charset="UTF-8"

On 2026/6/17 20:04, Johannes Thumshirn wrote:
> btrfs_get_raid_extent_offset() resolves the stripe extent containing a
> logical address by searching for that address and, when there is no exact
> match, stepping back to the preceding item - the containing extent begins
> at or before logical. That step-back never crossed a leaf boundary: when
> the search landed on the first slot of a leaf, the containing extent (the
> last item of the previous leaf) was never examined and a perfectly valid
> address returned -ENODATA, failing the read.
>
> The problem stays unnoticed when lookups are stripe-aligned and the stripe
> tree fits in a single leaf. A non-stripe-aligned read against a multi-leaf
> stripe tree whose covering extent happens to be the last item of a leaf
> hits it.

No. It's not happens to be. IMO we'll never hit slot 0 as search_slot
result when there's an item with smaller key than the search key exists
in the tree. We'll always get to the previous leaf's last item instead.
Current tree search logic ensures this, and IIRC many other codes rely
on this.

The only case that we hit slot 0 is that we are searching the smallest
key in the tree, in which case it makes no sense to get the previous item.


> Step back with btrfs_previous_item() instead, which crosses into the
> previous leaf correctly. If there is no previous item, re-search so the
> forward scan starts at the item beginning at logical.
>
> Fixes: 10e27980f2ff ("btrfs: lookup physical address from stripe extent")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>   fs/btrfs/raid-stripe-tree.c | 23 ++++++++++++++++++++---
>   1 file changed, 20 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
> index 454a95bf542a..192bcad8282f 100644
> --- a/fs/btrfs/raid-stripe-tree.c
> +++ b/fs/btrfs/raid-stripe-tree.c
> @@ -430,9 +430,26 @@ int btrfs_get_raid_extent_offset(struct btrfs_fs_info *fs_info,
>       ret = btrfs_search_slot(NULL, stripe_root, &stripe_key, path, 0, 0);
>       if (ret < 0)
>               return ret;
> -     if (ret) {
> -             if (path->slots[0] != 0)
> -                     path->slots[0]--;
> +     if (ret > 0) {
> +             /*
> +              * The exact key is not present, so the stripe extent that may
> +              * contain @logical is the previous item.
> +              *
> +              * If there is no previous item, the covering extent (if any) is
> +              * the one we landed on (its objectid == logical), so re-search
> +              * to position there for the forward scan below.
> +              */
> +             ret = btrfs_previous_item(stripe_root, path, 0,
> +                                       BTRFS_RAID_STRIPE_KEY);
> +             if (ret < 0)
> +                     return ret;
> +             if (ret > 0) {
> +                     btrfs_release_path(path);
> +                     ret = btrfs_search_slot(NULL, stripe_root, &stripe_key,
> +                                             path, 0, 0);
> +                     if (ret < 0)
> +                             return ret;
> +             }
>       }
>
>       while (1) {
