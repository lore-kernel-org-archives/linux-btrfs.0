Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF92935C68B
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2026 20:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787861132; cv=pass; b=KoE01Wb+jJJ1KSMiX18L4v2u+PD3qMnLSq6SkS723BcMuRgBQCxGjT2eWnq7eg8V1yKgEHHCzmwLm0ifAwQAd2VOL39f77ApOlV9pwkegjTEGfwmvX496BDY4kGB7roh/KyVV5c2/gc78yURMSrE06aUAm8tH/l4FmBkiRvz8IU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787861132; c=relaxed/simple;
	bh=Amq2Nq7g4Rvhi+A8MmnZy28GeuV84bebu12tbajvslg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WVwEMWcZ5eIFDpSUSwxQBBkbGz8c6DR0JEBOcIrllLDqy5poXxSp09esFRLgJrUw3/HwxdnXGwxjye9vQxZckmJiDBaGXWfxSQYC2BCkh8MDYZwPUHDGYhk6G+UCIutF6+wadd43Uz7LMn87OWAVCpWVqVFPTAoyUxWoA2D4vGM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jBTcaEmd; arc=pass smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jBTcaEmd"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4995b0343c1so1178035e9.3
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2026 13:05:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787861128; cv=none;
        d=google.com; s=arc-20260327;
        b=gd/LBZmh3DlcKfZax2kdml8JhrlC/7+gSRbF1mnVqDyTvNjOnmBb9v6eUcItOo4wzA
         MqwbhCFwqbagMdiW3Hfa7JW5OCVEB37/cnsg2h08htn6NfSkFfXljLlDmVVkQa0ckEJI
         +njxChyxkAgxg2A+7hk3nBpMG5X6LtHn2V4+b60GRtL2edNW3yMq0WcJm8QuF+/oHSwN
         fvXkjB7NOl/EGEi2zxegViRAGtXD9GczdPHQ72hXw7CQwr2SV1W6KJJyWtLvqL8BmL60
         RH6B/GiPDEorXLDNBPIVKpJPGJQYKOAXeuOU93h5lTujXNzYYy7iXTIZZIIvSiKDPcje
         lFVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BIsnd6xgeWrgcQT3jCCMdd8DVWxNR+Gr3QkvZG2o5wQ=;
        fh=klMTvCj/pBN+Ke4S+x9OnNvZYakx+QGgTabU/QGYVBE=;
        b=rPliUTmdbcIagI21i83Q1iDADflYmX8q9MCLJouawYpEkMiklzVepQlGUX6DZnprdZ
         sho+JqqI8fyYTH4MTCCUjmZ5jOZRAy6+elMXtJhfqTJSh3rPZoDCwqZIcenS8zdqhMeG
         Mvg6sOz+TCwD/migwS2lgamWwgDe1z6efbEQ3jCssaUX5BCyzkT4K+QOH7OIWlesKAZy
         KWvBTqPPhJGNng8wSLI3HHeRIewlp5ixVGeuFIkhqZ0sz4Fp1xAtzj74YVZgVf+5GKVU
         7+phIUNI3r/uwEG4snVlMzwN9b6lvbW28veeBvKU4AQBIxw+DZPAzHaBSi/njGOAnX7G
         USFw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787861128; x=1788465928; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BIsnd6xgeWrgcQT3jCCMdd8DVWxNR+Gr3QkvZG2o5wQ=;
        b=jBTcaEmdwdW1DRedprV3w9bCe6/SEJs/DHjsy+D+PHot4C/PbHh5tD3BM6AzYCRCi6
         pWnhe7FihJi7qfBJNS+BVYisD9dMsX12faXTjzTw/9IRGDEtAaH35EU+ihqp2Uu33ynq
         uhZIwC3LG35wBKRoLsXUPWgEl4QAOtGU46rOl9i566IVSK9phMB5SNzdSqaXtnnPIoqQ
         H9sy42ymjOdy+f63Je0waSafi6q1BeCdb6uW23+Y+Sv6XzOv32pHLYs+qlaK6knAMBza
         CkfyYJEVtbS/VyPG1h9ao2I1/CL4JxF13UInCu9/qA+jqeRjk3uNvG3ELapCPsDwbqta
         iJGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787861128; x=1788465928;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BIsnd6xgeWrgcQT3jCCMdd8DVWxNR+Gr3QkvZG2o5wQ=;
        b=N1iMJLd3kwPzxn65zXNbhV6ubqvneKKoiUnt5Hck2PE/p8ulV90bARsYp5+wNpvjkI
         JnbYzvoO5lqFAYYQTAEXS5zLBHTCgDINXHG9dF1JRrWj3DAghzaEjKCAGWVmkcoEQ+60
         0dOVLgxhgm5rVr8jeTnH95vczFq0NJ6BKYCl6RPDevvXiwTSyIdrF9f41lOC6LIU6n6R
         wpr2tyztdgEO4Y40jLf3I5srgXui3ywsd2T3+eXO/tdJPNCa68g6iFabZUM2eLRYbX7X
         soA/YRHR/C3XqzokWviuHAwoZpEKTHmS25r+wqmbkTWhD/QpCBI+XgODRQFTvyfB9EcY
         wb/w==
X-Forwarded-Encrypted: i=1; AHgh+Rqqlf9MWgIEJ9iK60uIZfkZQPGqNDUNoY/2uOptqRQ+UKyYddvbNUa8xCb68o8CwbzekiP3OlugqSKqwA==@vger.kernel.org
X-Gm-Message-State: AFuF++nLehDTTJglx2zQzjn4kyY92hJfDYWLe3SDNxodbk/NrNZ+dbj2
	8trs4GuoGkpfB+5cU11lmpXFVoeNOYNyhYDoN/dmAJCLf7nkLmP7SUbUuk9sc7MoB0d5KZTQ+8I
	fOve92BDzSCECmptw/6vJkXEEq3bmlQo=
X-Gm-Gg: AR+sD13mFvI92lSInnnFVEPVYP5yGoQCcz6KtCiKggCRsj+PO9OycDqrlPUvmTVg0lb
	rrhCubELwtYvP+C6yqamcKFCwNWC063a0FJuOIpp0sKn196x296fyI18zSQZztyZsG5MRaz97Qb
	a8CIJh/cIRHGrhVOik4dV6e6CLOd/HptvIMwlWbEW+moB5uiLV6ePrjyirB3LptrnT16AXZxBzn
	umIw6EQE9pP3BueyDlTHk0zaaXBYP4I9Zw071B2T8p1PRmBJpa+Nr0jW/RgSsKbM4BiAEZmNif6
	Ix82xBg+Tr7vCYYsgPJ4S12WrjZSpuhbR17mdHnZXEhJPiiYUTcIZWu2ExaxfuBtI+diIj1PNEC
	GVlVzNWVYdeXQ6zSEdAF++erxa4Y=
X-Received: by 2002:a05:600c:c4aa:b0:499:d513:e507 with SMTP id
 5b1f17b1804b1-49b91c17d72mr16962265e9.2.1787861127504; Thu, 27 Aug 2026
 13:05:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260827185722.3234622-1-csander@purestorage.com> <20260827185722.3234622-2-csander@purestorage.com>
In-Reply-To: <20260827185722.3234622-2-csander@purestorage.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 27 Aug 2026 13:05:15 -0700
X-Gm-Features: AcwNN1UExlY2vL2SpJh0tNQapsYMiZcr3z5sWaZZFYGrbWrJd63x35h50FR6wzE
Message-ID: <CAJnrk1YfTg-Lz+TmM+c=Asc8N4QGuY9_g8zUXtaNr4O7hG1Djw@mail.gmail.com>
Subject: Re: [PATCH 1/2] io_uring/cmd: split io_uring_cmd_set_res() from io_uring_cmd_done()
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Ming Lei <tom.leiming@gmail.com>, 
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Bernd Schubert <bernd@bsbernd.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, fuse-devel@lists.linux.dev, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Caleb,

On Thu, Aug 27, 2026 at 11:57=E2=80=AFAM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> In preparation for setting the io_uring NVMe passthru CQE results from
> the blk-mq request completion rather than the task work callback, split
> out functions io_uring_cmd_set_res{,32}() from io_uring_cmd_done{,32}().
> This allows io_uring_cmd_done{,32}() and __io_uring_cmd_done() to be
> consolidated into a single CQE-size-agnostic function with 3 fewer
> arguments than __io_uring_cmd_done().
>

The conversion looks logically correct to me but the interface feels a
bit annoying / fragile on the caller side.

Is there a way nvme can get what it needs without changing the other
callers? Would it work to just keep the existing
io_uring_cmd_done{,32}() as is and add a separate API for special
callers like nvme, eg:

  void io_uring_cmd_set_res32(struct io_uring_cmd *cmd, s32 ret, u64 res2);
  void __io_uring_cmd_done(struct io_uring_cmd *cmd, unsigned issue_flags);

where io_uring_cmd_done{,32} would then just be inline wrappers over
those? afaict, then only the nvme callsite would have to change and
fuse, btrfs, block, ublk, and scsi_bsg could just stay as is. Do you
think something like that makes sense to do?

Thanks,
Joanne
