Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1084338936
	for <linux-btrfs@vger.kernel.org>; Sun, 12 Jul 2026 15:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783868799; cv=none; b=QojFkGOLDgqh1LgTV54NXvKA0q3ITZsxBfuKsH2MDnvfE7IreJ1YjA7QdAI3q6yWx6eeAUrySqnF11cJk43+w/Tm7f5q2RRwdZbEH0cBsD7rRGZQOJV3XCrLdIiYde9GdmATnWEkzExkzGqZ8w06p5brxFWIiOBaikxDWgGFGsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783868799; c=relaxed/simple;
	bh=8gIGndJDRf7JgPXBED6EmrFm9hh9tKjJ1kOV2dL0NT4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZmVeYs6AY31TDhp/1Pyn1pXofJhyHaZ/D/wEmJgXqH0Wsvl5g+iC+H/+en6aRPboiVrUsfeNyAiFZaVLrZZ98TWKDSdKogx97UudZmJRrDZf7xv+xvyQiEncUDjs01hZMnFyUph63pHZZ6InRfSao6C8+i2uB5GUhvpqVFH59xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-448479e0eb6so1358469fac.2
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jul 2026 08:06:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783868797; x=1784473597;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=88hvktTu0KZHeu02mXoEzw2BIFJy4M/j3xm/aWChyjQ=;
        b=U+y9t/8sUY4gyDCu8dx7OQRS/feziNydetjwAfH4NzsLnkq46KWhuVShaENMUWoT+D
         k7w/Qca8E2m+S0NDxvNYMidXwv1Mp1tjWEN8sNtnj4DsM+kKYOE6hBdrYpE/b1u2rFVv
         maLgaWQdhgEI2598eoL+x5Xl+gmKvtFSjwatYN5XZxfSYc7ujH66Nnz2+6aWO6CxaJxy
         zTkVz0ag80R6ou7yIUbI+PVLpBb7BKJDCHvd67T9equFH9HrR1wXeIVuIiJdAdmxf2OK
         fAlzik4WwWEFeVwGbehyDJKOHHvDjW6YEw2/THt954ME6HskbSPzQrk8mhQs2S5VzW7O
         c/uQ==
X-Forwarded-Encrypted: i=1; AHgh+RpyBRlVmYqs2o3FVWnhqR2K3ZQdILfSKtMkzaTlh7Ex7earxMm/ogg6lAMbTpFv+NRefb+rNXh9wL7G9g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzRRAZM4qLBlwhw6MMuSouSyOyICe02JLhUm5Xal1d2zYlOOlEp
	JLlMu8kfHnwyeYJ/RZMcjjLWS+LaYOQgxv7xN6WQrIh+6UslgqvGjIsHxMkhLw==
X-Gm-Gg: AfdE7ck743FZBfGZtd0fRAKLYFzFLY+rQTWTeXKybjcJzyXU0de/ifGpGLLId70D/gZ
	o3cEYNz3e4FXNApOaPaSYLZXOMfJymH53/rNt2XMCeJp1uSXwrOjQixswYpBYnvlvHNOEQ9vs82
	N9l+iNWsUpSmsiMDP6RbqkD/R4pzzn2CYBjr8h+00tK7WNHxLRdtxnfWcyJOHMCi/raqazSWUGO
	5kwBjpNJDiiZkm/C1X5QLLAeMgvU4cs8ZzIwq3rd3UeAjQnEv6uZxQh/PoNF/wpRJVJg3n0rKwO
	OVfkwpkJytGoyoqx3HAReeUp+77hxeTc1VzM5375mvGQ9/2iTkdbUo0kXzPXiF8QaJ3mz7J9s62
	h8Z/Qz6flNbHAvAa9y3bPIe18zKmSDBUbo7ztjfPs0X6xYFK36wp91b5jP02BQJ7gvj27LMoASp
	HEFTuyCCKxWVOFMKUM+ec+nkUmW6PXPh3WU4VsnLoqCoHAEOCZmqCnju2ynYlTfHD87XvdeJbUc
	1Z+AU34DkuQw+a7UHBPLtrXqvQsAEnsNMzrsXnf5ZWdYYkaxMOR2hhutdENOt0=
X-Received: by 2002:a05:6870:168e:b0:446:eba3:a1ad with SMTP id 586e51a60fabf-451f1097b9dmr3376443fac.10.1783868796889;
        Sun, 12 Jul 2026 08:06:36 -0700 (PDT)
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com. [209.85.210.45])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4519d89f7desm9740323fac.7.2026.07.12.08.06.36
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jul 2026 08:06:36 -0700 (PDT)
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7eb5bdb50fcso1908205a34.1
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jul 2026 08:06:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9sluKCpLpCCKQ6NJaCqXRqKvxxadQcL4BzkvhR007URolqN1i/0OMxtrY5GZ0+KI6P8NjVtL3xzYZaOQ==@vger.kernel.org
X-Received: by 2002:a05:6830:81f3:b0:7e3:d199:3164 with SMTP id
 46e09a7af769-7ec096ee194mr3373053a34.11.1783868796457; Sun, 12 Jul 2026
 08:06:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260712-reflink-into-nodatasum-v1-0-9f27ef836073@amutable.com>
In-Reply-To: <20260712-reflink-into-nodatasum-v1-0-9f27ef836073@amutable.com>
From: Neal Gompa <neal@gompa.dev>
Date: Sun, 12 Jul 2026 11:06:00 -0400
X-Gmail-Original-Message-ID: <CAEg-Je86cbtNvESfK5MeVXVezZfMFE8qVdX900F3ayQsC+yQNg@mail.gmail.com>
X-Gm-Features: AVVi8Cd2-p1zTlGWQGpQGZf-1g42rHsDM1sB7d20uoAFfIyhS_ZBfMdr40Cq_aI
Message-ID: <CAEg-Je86cbtNvESfK5MeVXVezZfMFE8qVdX900F3ayQsC+yQNg@mail.gmail.com>
Subject: Re: [PATCH 0/2] btrfs: allow reflinks into NODATASUM files
To: daan@amutable.com
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 12, 2026 at 10:25=E2=80=AFAM Daan De Meyer via B4 Relay
<devnull+daan.amutable.com@kernel.org> wrote:
>
> The primary use case for this series is building a NOCOW VM image from
> individual partition images that are COW and checksummed. Today those
> partitions cannot be cloned into the NODATACOW and NODATASUM destination,
> so tools fall back to a full copy. This makes provisioning slower and
> duplicates all of the image data up front.
>
> Allow cloning and deduplication from a checksummed file into a NODATASUM
> file. The VM image can then share extents with the partition images.
> Existing checksummed extents are COWed once when modified, protecting the
> source checksums, while newly allocated extents use the destination's
> normal NOCOW behavior.
>
> The reverse direction remains rejected because the destination would
> expect checksums that do not exist.
>
> Patch 1 prevents swap activation from bypassing the COW protection when a
> NODATASUM file references checksummed extents. Patch 2 relaxes the reflin=
k
> restriction in the safe direction.
>
> The xfstests branch is available at:
> https://github.com/kdave/xfstests/pull/6
>
> Signed-off-by: Daan De Meyer <daan@amutable.com>
> ---
> Daan De Meyer (2):
>       btrfs: reject swapfile activation if any extent has checksums
>       btrfs: allow reflinking from checksummed files into nodatasum files
>
>  fs/btrfs/inode.c   | 29 +++++++++++++++++++++++++++++
>  fs/btrfs/reflink.c | 18 ++++++++++++++----
>  2 files changed, 43 insertions(+), 4 deletions(-)
> ---
> base-commit: cab9e339cfbc1a4e075e53e281dfb00391e1a6bb
> change-id: 20260712-reflink-into-nodatasum-aff962f3794e
>

The patch series looks good to me.

Reviewed-by: Neal Gompa <neal@gompa.dev>

That said, I have a question: Is there no reason we couldn't reflink
into a checksummed area and generate *new* checksums for that purpose?
That would be useful for staging for regular backup.

I can foresee that being useful for archiving OS trees or VM images as
snapshots by creating checksums for the newly created snapshots...



--
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
