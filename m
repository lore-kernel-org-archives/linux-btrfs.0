Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EE03CE0A1
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 10:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780653960; cv=none; b=eS1rml4CuuX9hOGakMSE8kAtxaNHsH1ZwdLveq5L6bTA/n6A1qMjuDj0Agy65sqwDrdeCcinT9jXsrqJNur3Mf6HHye+TgSBKblBTMTRcYY1G3RFa/bDfhfd00PBMt4adVixchC/VfUsn0Cc4dHW2hK8KsCVIkUryLR2ZIG3t54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780653960; c=relaxed/simple;
	bh=T30Ka6CadywIZHSeSjE/eNPEVU/Pg+LZa815+DeiL8k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rk29EAq8am6wNx3Wpmh7y86UzF0YqO8wKPsgiGLHfpp1SeX/ovDm94F/k5bEnR+HeTd5ll8W27YiYk5XNKou0UkNVR+mNNxnW/IvUC7CQowi8QCxDdN1gNmzoHA4nm8pxMGHJkIP2Kob1Nlout5h6xyoVolAD1irHCus2CunBfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YD2Koi/P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YD2Koi/P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2D31F00898
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 10:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780653959;
	bh=uxc8ryYqpPtyH3Ys0W3HLSlIQ94zCes60/9kmHOQQEE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YD2Koi/PGPkuLZQRdY/pBjGvBEziOEJmhHNoZalKkYeuX/1f24OpkuB3Ox9ETs6sy
	 FEFeFFgm5AWCnHljtnGVYNxztXCBS5KiR0/qtgMGOVrhfNWdExK9B9dulVpBxVM2z4
	 UgeemyqJg8C2SdgzkkIC5Jfluk6WW6kwH9dHdiqraTWPtpV5ge6nzqw+JUiMIEhLdK
	 9oqoxIEklLguHPOYyx/k7VtDDqJaCNeSCP6InsyIKRrhRRke3R1Rh8FyUokgm8vc91
	 wlICHPQDDuRG1TtJj7AxvvUIXs2N0cCamGtuJW+R6DSz9iWNgU4yD96fdMzTBTCIWr
	 bhJP+CX9uLPCA==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-beeba001887so227547766b.3
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Jun 2026 03:05:58 -0700 (PDT)
X-Gm-Message-State: AOJu0YwnY+GuAXITY9RN+90EP3SbLT7bydtxCL7e3ezPRDTxEWRJclf+
	hHAWGMUwDDIM/jG80z5MBOozn3MtmiaZI8xLTZmMUBH2psqSN392OnDe/uMwCnmI2yudFSamw8q
	S0c6cbeaCghP+VXs/2TrK3jKxHidqHWE=
X-Received: by 2002:a17:907:608b:b0:bec:9f90:629d with SMTP id
 a640c23a62f3a-bf3743ea8d5mr159147766b.39.1780653957557; Fri, 05 Jun 2026
 03:05:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1780645090.git.wqu@suse.com> <9e638119748a83f475861e69388b4dda9715b660.1780645090.git.wqu@suse.com>
In-Reply-To: <9e638119748a83f475861e69388b4dda9715b660.1780645090.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 5 Jun 2026 11:05:19 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4dEGHd=LmmW5PVVnaxY=qFq31ZSb1qE24wPGU-bKv39g@mail.gmail.com>
X-Gm-Features: AVHnY4LgPB6yYm7FHrTccsCItXHx2EjqDOrwvPd3SK6ELYbB3ikbYsxDmhzJXH4
Message-ID: <CAL3q7H4dEGHd=LmmW5PVVnaxY=qFq31ZSb1qE24wPGU-bKv39g@mail.gmail.com>
Subject: Re: [PATCH 1/4] btrfs: return the written number if there is any
 progress for dio
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 5, 2026 at 10:10=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> Currently btrfs_direct_write() will return error even if there is some
> progress made.
>
> E.g. a NOWAIT direct write has submitted 16KiB data, but later
> failed due to -EFAULT.
>
> In that case we can not fallback to buffered IO either, as it's an
> NOWAIT operation, so we set @ret to -EAGAIN.
>
> In that case, we should not return -EAGAIN but 16K to indicate that we
> have already submitted 16KiB data.

No, this will cause partial writes, resulting in unexpected behaviour
for applications.

For NOWAIT writes, if we perform a partial write we must return
EAGAIN, so that the remainder is attempted again in a blocking
context.
If we return what we were able to write, there's no retry in a
blocking context and the application gets a partial write.

We've had such bugs and reports of unexpected reads and writes in the
past, at least
with MariaDB.



>
> Fix it by doing a check on @written first, only if @written is 0 then
> return @ret.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/direct-io.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> index 460326d34143..c97396ca476d 100644
> --- a/fs/btrfs/direct-io.c
> +++ b/fs/btrfs/direct-io.c
> @@ -1046,7 +1046,14 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, str=
uct iov_iter *from)
>         invalidate_mapping_pages(file->f_mapping, pos >> PAGE_SHIFT,
>                                  endbyte >> PAGE_SHIFT);
>  out:
> -       return ret < 0 ? ret : written;
> +       /*
> +        * Always check if we have some bytes written, even if we hit
> +        * an error later we must report the correct number of written
> +        * bytes.
> +        */
> +       if (written)
> +               return written;
> +       return ret;
>  }
>
>  static int check_direct_read(struct btrfs_fs_info *fs_info,
> --
> 2.54.0
>
>
