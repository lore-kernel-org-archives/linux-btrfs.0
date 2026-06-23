Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA7C3D564B
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 12:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782216889; cv=pass; b=RukpIGQZQ7//fcwqfB5P0wAJpcvvLgNIq4kh03twxfKC+3gO9C7S8nnJ+OubEKuLaw/pQoD4gqqPy2DbpAe2zr62dhx2A+VVPEoEoP75+366aQ42zP6WAkmWtuA0HUDtTr+9y0GiaJALe+MB1Vo8MKMneLxGWAm0ymv4q5WTufw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782216889; c=relaxed/simple;
	bh=E7jUEQPxuBQhi0LCl6ae+iQYvTH+4cM4tZyutcnDG/s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d03gI03isPzlvth/yEKOck13ynu1jdfvuiTs8Q2GL4JH++J5TN41b8+Z4ONbB6+q4w984BpDW3TkL880dXK5svT6ThqsfF2yGFaWbMoBCjMQRhlq5G1F6zSa7pIcZQTg+VVWHgLP75fybYhWlvN8iPBVOYxdU4HXfEYMq+fUtqQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FkK+T2Wl; arc=pass smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FkK+T2Wl"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-462342ac290so6099153f8f.2
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 05:14:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782216886; cv=none;
        d=google.com; s=arc-20240605;
        b=FX2I0C/GAoevGtnynHD6F8oqffTp4NSX0/qoegPaqIAF0GPPR7S66QtR/jLgvqdwrb
         za4xhoLbhP1eUSQMaYBWQDJTF5zYtVXV9mI14w+be6BnSIA+34MehtE6h84neRLBBRlb
         KMsWQ2hRo0dp3sdq7ZHWq8ytEOZJfL76031OWhvFeP2UMzKtR9vy1o3hx5wYDhARenkM
         R/LfrrZWTQrJLBuVgDrGip3k8pZUXtViiTYbxo7h1WZhoKDlyUcToBAVxSKCT5ycMJpw
         hTFbMnwmoDTWI2uL+HuKpoPr4IQA++fsHpgeAMe6PIyLwQ3NMIVi3mi0MZaeZPiIJ6J/
         pmvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Mea0OYU7d6oUNW70YgMtjEvWHbmzuX3ju0XSXEtltXA=;
        fh=RhFuKwp73/x8KksFPnzjZEYxDQ9t3rFtnoJ8q5GIsWE=;
        b=hbT+pTtxyRAen6YaZvIG4oq+pfDcfdlDkuWaI0ijW6bALhyQxDTVTzneLFfq+ZEqWJ
         fixjxRX8YjK5AlrZYJUTube4TFr7xkYlSqhbabS1FRSzJaDzbkoZJWgf8modW8qMHh3N
         SyIDkt6qXNnj909I9oYbpNfr+JpJWwE9GwVS2btbJDqq56iVBl7CGfbS52ZruCrufJOf
         U/XS8v4gK66lS97vshAUhUFG/Rt3lRPHdxTnB6UbSRejodZD2T6hWak3cb97OAXLfZMZ
         gpci4tvV+9atvJqwlDrz7O7KlZ+ponpp10rQALR6YRL41NgKxUg47U+tCmBcjPfOg1w0
         U8tA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782216886; x=1782821686; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Mea0OYU7d6oUNW70YgMtjEvWHbmzuX3ju0XSXEtltXA=;
        b=FkK+T2Wl/glhx651kYWrYtczS/3+SFyy//5Mn5CyFuuaW29qoCLWC5qkMzYcc2thXD
         FqQ6m0IhLgk4vDKPhKHMYqek95tO5s/8QhHdXSSZYhbGDeFjXcUWrmP87vouIo0OCdeq
         axzCoJyjYFgoWC8YgyQKcjNfV0xFPhB4fFLU0nkBxYf3uBsStSj5C7GxrGOXvqrmx+hB
         Cak+wX6/4lW+DovsDm5p4P7n75bzTl+sYHccG/X/DlonF7OVft/WcdCsFSUZitFehHHR
         P41XYkC79elzzYRoXisVXOaTav+H2UNUGlVYjCAWzIo/rzVTY0UToY4KQ+x/qAf3oKNV
         6DPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782216886; x=1782821686;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mea0OYU7d6oUNW70YgMtjEvWHbmzuX3ju0XSXEtltXA=;
        b=BVf5pS81GyFSfuNWnTq6EtjepqJqaEIl7iOwG4OcMwFXPNK8OFstEVKfwTLw+qTGg9
         TIhptdy0oHZM6EPJxQXyP6V9vRZZSVcdwXd9yhGm3Sf0eENPBzdGNQCurbWuJ+WpMgpA
         /kl3IClMXkUsO399mkzbIoadDHsRMlFA8zpdSRe41KfdLts2lQLZegtlPtesqfMeVDTD
         XCuo3FnXxVHfwGNW+QuATWuOeoFu/XF4zd1wtK2Y0UpPWIvX7FwlihfQCai5esRbLwbv
         mNdCxyMmanuQHY5HjW9yF3c3FV/W1Q84BwrjbuHN8uxP5WlwlzPzfxFMWPJl9unp75YV
         Lhww==
X-Gm-Message-State: AOJu0Yyg51tP3DpMef8kqlwmq8XQBgyjRWFWso0U0KJF1cfAibCifK3w
	JlgPPaeS6AHo+FBDb80ctXNAm3DyurYgf9OZ9TctmQpjVN7HvnldsAbXEyFMVODq+YyqcASqQFR
	s1fRYTXkSUpARGYZNqV9bvyVhKd7hCHBH0qm6JCix9ovggsSSyJHwcfw=
X-Gm-Gg: AfdE7cmxylHgPslRMJ2qzpq4/mkNm+DALwWre72Yc3QejVmN7EsTV0v7Hs4j/owddPk
	5aedyOoqpnqUYe7LaiTMPb4RUpHDp4w5tyhxQeCVdz4RdFv02OhLoGz8K9xq7HVwwp548eETKom
	nEGLsbTeuLiFhI/DF0zrox9PH5Ez1APloAuyHddxSVqnFr5w25KraikbLOO+OrPGuLjCJfuudWQ
	Z4t5QHS3VKZy0eDllXXPYqLMeQZ+Ebq1+qh9Yiz5GvkDuK8HYYVmVS3bNL5CEBe1VVdayJZGaqB
	NyzjUKzAhjjr/9WAOBPAS+8iXH/V+ZJoeiWgn7nXGI01oLX29ze+WAfW/Yu2U8OfkuF5Bg==
X-Received: by 2002:a05:6000:2884:b0:45e:edcc:f6dc with SMTP id
 ffacd0b85a97d-46ad8c242c9mr3729901f8f.6.1782216886271; Tue, 23 Jun 2026
 05:14:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6b47f0a447d1997cea8ef6e5dd6009a3df99fd33.1781541886.git.fdmanana@suse.com>
In-Reply-To: <6b47f0a447d1997cea8ef6e5dd6009a3df99fd33.1781541886.git.fdmanana@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 23 Jun 2026 14:14:35 +0200
X-Gm-Features: AVVi8CfrwHMf2RNdsfUv46nrE-jtd7dVYknJcO6UmbmOt7lBjAcdGF_4ukva_hw
Message-ID: <CAPjX3FcsSntTuey2Btr5SOcrezux3qfmQfsBSjw6aC8JBxkGtA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: send: fix comment for SEND_MAX_DIR_UTIMES_CACHE_SIZE
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 15 Jun 2026 at 18:50, <fdmanana@kernel.org> wrote:
> From: Filipe Manana <fdmanana@suse.com>
>
> The comment is wrong, because it's not about storing the ID of new
> directories that were already created, instead it's about storing utimes
> values for directories (both new and existing). The comment is wrong
> because it was copy pasted from SEND_MAX_DIR_CREATED_CACHE_SIZE, but
> forgot to update it afterwards.
>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

LGTM

Reviewed-by: Daniel Vacek <neelx@suse.com>

> ---
>  fs/btrfs/send.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 3ae480c7474b..a3c8f2d889bb 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -130,10 +130,10 @@ static_assert(offsetof(struct backref_cache_entry, entry) == 0);
>  #define SEND_MAX_DIR_CREATED_CACHE_SIZE                        64
>
>  /*
> - * Max number of entries in the cache that stores directories that were already
> - * created. The cache uses raw struct btrfs_lru_cache_entry entries, so it uses
> - * at most 4096 bytes - sizeof(struct btrfs_lru_cache_entry) is 48 bytes, but
> - * the kmalloc-64 slab is used, so we get 4096 bytes (64 bytes * 64).
> + * Max number of entries in the cache that stores utimes values for directories.
> + * The cache uses raw struct btrfs_lru_cache_entry entries, so it uses at most
> + * 4096 bytes - sizeof(struct btrfs_lru_cache_entry) is 48 bytes, but the
> + * kmalloc-64 slab is used, so we get 4096 bytes (64 bytes * 64).
>   */
>  #define SEND_MAX_DIR_UTIMES_CACHE_SIZE                 64
>
> --
> 2.47.2
>
>
