Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FC136E48D
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2026 21:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787867072; cv=pass; b=VukEpa8MLmkjUtKmuFu0xcYBSHalQaXQ+ocrYGZ2ATy0WaNUps/JCOUgZa4n44BY1QZaMv9p32FoYVLmo8bjVJ0wuoP3pJlmc/6HzLisUa4OLscVJZj/J7Qk5C1OC9ipZcGWoZkWpN+evKr1bRCJzWqGwA8Qh9E7ED1aDebt4bc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787867072; c=relaxed/simple;
	bh=0sBuqucNWMJ3PQ7mkm0GStLfwt7hAbIgMaO5tBFyaUk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E23NQOYbajELZfTsc0EzNWutOHGqDiRfOPoO8W/6XuJw0lRL8/Jm/k1ID2eQA+ksKgixrWCYBj8TSlO72yN9wvhgBKGlWLfaKddtaxS5M1+v5dLEKdI+giIsv+klgGaHkqS1eKu25/NUH/wLo6n5yGCLxBc8LzMcp6HG9WsGcT4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ZTrSBDI+; arc=pass smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ZTrSBDI+"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-45ef92f7cdeso121490fac.0
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2026 14:44:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787867069; cv=none;
        d=google.com; s=arc-20260327;
        b=ElKGahA0ccYSczowumYObGEjo32YNeFfvOp3fvN4HkyU7F/WKztwaDDcHFprNPtS17
         VGA8zPwR87t7sanZJOBsJfj3fUFiHxQjVfCvmKPgui4h013SSPhLMpNpYHYz9SIDfZ3n
         +YuMiFop4/W6G7aCG84HoKdCQIxbAYKhX1QZ+t5LZ4vysaIdg8VgoZXnbZZM6GQNTFW1
         Br5bYzlUJj7ra9YBETGag86zomF+qRE2GkP2sz7+CEiALTgEGgM+gX6zKkY08wp5bQ4u
         mazhR1JZkSR/hHwSCSt2dcsaLOX19//S3nLQwEVuB0EX74BNAodVRu70OTkyu7yx529p
         pYOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kqBamkmhnxpQu01OYVCgjjVqjgGXsL5/W693jooZv34=;
        fh=VS2yZw4zD08lNSqNgLOupBxqP16AESEIWd0x09iHDIY=;
        b=fXFZgTulqDX9mhfXGAMGJbNJVcmsAB6BMqMTEnE57bbIACk+/a/4gPYl2AVquEYpNY
         u566j4ET2QfHWSqZ4mc2Uxb9zMJofEYqMFHkfKc/U1r0oa6j/F37lDHR5HvduHoBd4F7
         02MGHfOHY0VVAWpZVaK+4TG0zrwyjvFI+Fjg2ThuF/iTqF+jHbQGuwcJNiwkq6odxS0u
         zfUGtA2PaFYb5tTxlOP+SKXjKa5YUTdAlv2XuVpLBtXm+NBpC8ZhcojyrYAFFrTR1i36
         nMv3D/y3nHQXp6lryb++3TNSFUrftJZ1Zu6D/O1GliMuV6NWuuDmd3EZbiy1ZwCZ7Irg
         6KCA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1787867069; x=1788471869; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kqBamkmhnxpQu01OYVCgjjVqjgGXsL5/W693jooZv34=;
        b=ZTrSBDI+mPv6N+9HPOoOcSbhmUkUBhPzXdGsbf4IcAnGI0Glqh1gi6UK5sJn1/UOuI
         5WmYrDNdNGftOFB6sL0MsoG/GkrMAQOqk/tokMVid4ixJn1zODd/o8mkwRCF+4s5Mx7n
         hzC5Rcnw9GFjAl5mx4JAznYgPZlfoPtUtQefmpUgYVySl+64X0J9WDaZpDg1K40kLxFw
         dRzkW1d/qKFjpgUkbllKjyQtj5tGs943l6r+mg6H+DoHnElbM1F3AcDi9+ZLC8pX+3hg
         PbdqhPbq9qlvZ9qS4MO7t8+5PpUTFYv7xwC7k48XRi0qLhUD2tMajDDlzIUqlsjJ9Bdx
         NVJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787867069; x=1788471869;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kqBamkmhnxpQu01OYVCgjjVqjgGXsL5/W693jooZv34=;
        b=slW2hFP39/x6o/amoLGEMxCzp1M5h99c+NwcKa9JZixe5HTNLZgS5ehn+7vpmXVO5W
         1YQKOGeSJ0Brc4Y55cVuDGL0zX1qXSh5tULkCxNFyOKmIUh8AQpPV7cuxCL+ymufBB4E
         2Lth4U+j1mQphnpMBdnx1CxhQFNRo7uL28mQ52XhGzH08Xm60rg1gWGskoU9eDH3Qsht
         opk97i7B/AVRK7XDmzyYn75tD5iAzhVtdA/nQW1Quf4T3z+Wi2fY/cj+333IjdjyP3DR
         B8XYZtrSvdw+sn+puF166/86g3VWG0ccfQj8GHp3FMjvu+gKwlCgtHaE9XbpCgcxVSMU
         fpnQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro14SFIjq5BNEQ7gnfhlJEYDEu7n9rOlmP+GJkFwvPSVRCAE5FEiKvyssVIfouDonbYsSOv0zLzNNdssQ==@vger.kernel.org
X-Gm-Message-State: AFuF++l5V7lde7BqZ/Qz6HbhPHNMmEKesrg2eonw8vCyl8llYx/FGq8U
	n1MH2nR5ItNq0Oob1BOq/2NNQKBJRNHiXg1zb3msYHiDJxLa5xfYapzQNdl6zurpEUlysAIKlXX
	PqKyXWaEnZkd/Y33vGDcgQCiKBoCV0CmL4rbaev8tkA==
X-Gm-Gg: AR+sD13fDhS/rZtBzHoIbNigFuBudlLhvNhBsNeWfDbqJ0WfK4UDBzRoZQtWcN4xkuV
	fXhbkJVhS7T9oaKCyUTGV5vZO+lo0XcLzn8lfyMi4JxTDudf8ObhLUh9WjNFC28pUcp5ZAEFQqX
	KO7/t+AO+FJsM7Tbx9pU2P/Wg6c3/vtsIgJ/fQCDXmbmD3KFaKqKtC2DGfYQ/IUufaOJJ7Y92XT
	ohv6GmLiOoyvc0F96jD42GuZNI79J+8D6VUoGY2ThyrESNSOWHH7Dnc11taz7KZt6Zv9zM4gpBR
	JUmXFz9ZLvfhLUcz1SUkafOk8sFB/6vHpfJrQcL5qAtRJw==
X-Received: by 2002:a05:6870:45a0:b0:42e:7e04:e9ce with SMTP id
 586e51a60fabf-468328882d8mr1702119fac.0.1787867069273; Thu, 27 Aug 2026
 14:44:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260827185722.3234622-1-csander@purestorage.com>
 <20260827185722.3234622-2-csander@purestorage.com> <CAJnrk1YfTg-Lz+TmM+c=Asc8N4QGuY9_g8zUXtaNr4O7hG1Djw@mail.gmail.com>
In-Reply-To: <CAJnrk1YfTg-Lz+TmM+c=Asc8N4QGuY9_g8zUXtaNr4O7hG1Djw@mail.gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 27 Aug 2026 14:44:18 -0700
X-Gm-Features: AcwNN1UylVUquZ8opNqZqu3tNIHriO6d1S55vB3s5Iygu5DbEGaADAEUlDBXhJo
Message-ID: <CADUfDZoEosgMMQ47BDWBskTOZrYZpg6VUT5c4kwczDLRLXYk=Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] io_uring/cmd: split io_uring_cmd_set_res() from io_uring_cmd_done()
To: Joanne Koong <joannelkoong@gmail.com>
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

On Thu, Aug 27, 2026 at 1:05=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> Hi Caleb,
>
> On Thu, Aug 27, 2026 at 11:57=E2=80=AFAM Caleb Sander Mateos
> <csander@purestorage.com> wrote:
> >
> > In preparation for setting the io_uring NVMe passthru CQE results from
> > the blk-mq request completion rather than the task work callback, split
> > out functions io_uring_cmd_set_res{,32}() from io_uring_cmd_done{,32}()=
.
> > This allows io_uring_cmd_done{,32}() and __io_uring_cmd_done() to be
> > consolidated into a single CQE-size-agnostic function with 3 fewer
> > arguments than __io_uring_cmd_done().
> >
>
> The conversion looks logically correct to me but the interface feels a
> bit annoying / fragile on the caller side.
>
> Is there a way nvme can get what it needs without changing the other
> callers? Would it work to just keep the existing
> io_uring_cmd_done{,32}() as is and add a separate API for special
> callers like nvme, eg:
>
>   void io_uring_cmd_set_res32(struct io_uring_cmd *cmd, s32 ret, u64 res2=
);
>   void __io_uring_cmd_done(struct io_uring_cmd *cmd, unsigned issue_flags=
);
>
> where io_uring_cmd_done{,32} would then just be inline wrappers over
> those? afaict, then only the nvme callsite would have to change and
> fuse, btrfs, block, ublk, and scsi_bsg could just stay as is. Do you
> think something like that makes sense to do?

Sure, sounds fine to me. Thanks for taking a look.

Best,
Caleb
