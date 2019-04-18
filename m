Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13FB5C10F0E
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 10:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D19C0217D7
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 10:44:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GeETOI+n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388379AbfDRKoV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 06:44:21 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:42602 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388369AbfDRKoV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 06:44:21 -0400
Received: by mail-ua1-f68.google.com with SMTP id h4so603687uaj.9
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Apr 2019 03:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=j/effP+5iohMRocuBbn+wU3ZjTEdFsXMtMXgMIyP5mQ=;
        b=GeETOI+nF6LsuhqqtpSuoChbWH/UskTP93w2FqBAJ8suHcg5eru1GG26pM34rRqRIv
         B8WSV1vIoO/1nGhFp6RzC7tRx+dg46QqHS/n6VfCLXfkss6Wl+7f6WCCoYzQtCpy+Av9
         pK71SoS6mO5cCMQXP104i5sSYKE6Geh5ETamcgF6x60B8GK8filcjyPyvI1JHUkVFbsp
         MRDJlfZlESNOiFomQ0iE/paycPL/z00zxILDRgJ6z1hxx7TvFI07lkZ5PWG4KQ2p+24S
         lvWoZBjFQXQxvOE/FjegXCDh94aPaBSMmWJHMZZRUS76gPsOv6u8DX3QMmM3Wley22js
         9giQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=j/effP+5iohMRocuBbn+wU3ZjTEdFsXMtMXgMIyP5mQ=;
        b=CoWv+0Ov3UW4p5OAGk+ENiBBYODqbGLR5Sj8FGPx423niEpc6XnUke8gP6D+kCi43t
         bBp4FCX6DVPXT0AJeqKXAXoDfglqp4BMMqkkZLhbDV5QuCIhgceN2fpdEA/AJRFcgr8W
         G9s45qvheWSD378UObEjayIblEVMRbC9z7oIlD+O4lTnMhNstQ0hi4GUnBpUPqIe4E5h
         RjtHB2y2m7Cd3PMqoyFBM2ZlRYJ19q347Dum2zlZRvgmM2fWkzmwQhc5qlDwlMbheCfL
         8Dfgo2NGf96RkDlpjrwKOsLs/a86VcJ5kh6PX5BTW+NnQY6JwPc/G+/Xrc4LVC7d6fkq
         WZ5g==
X-Gm-Message-State: APjAAAVVkYialpJRsYrtwFyKnsU/LS8OB8guX9A9w3RemKm8gSTQ2Yog
        qRPpWpLrMx5WHkX2S2Th5QRL+Hwy7/H8VNYQvv4P1Q==
X-Google-Smtp-Source: APXvYqwaHpp8DFAXY794irwZcMMDgalNDbI2Y+3MtD4mgFCui2zslWAkxHIQQmiBGvEI1Mqv5l7PN3Bzezpz5W4/g08=
X-Received: by 2002:ab0:44e:: with SMTP id 72mr49531989uav.110.1555584260078;
 Thu, 18 Apr 2019 03:44:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190418084119.056416939@linutronix.de> <20190418084254.361284697@linutronix.de>
In-Reply-To: <20190418084254.361284697@linutronix.de>
From:   Alexander Potapenko <glider@google.com>
Date:   Thu, 18 Apr 2019 12:44:08 +0200
Message-ID: <CAG_fn=WP9+bVv9hedoaTzWK+xBzedxaGJGVOPnF0o115s-oWvg@mail.gmail.com>
Subject: Re: [patch V2 14/29] dm bufio: Simplify stack trace retrieval
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, dm-devel@redhat.com,
        Mike Snitzer <snitzer@redhat.com>,
        Alasdair Kergon <agk@redhat.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        David Rientjes <rientjes@google.com>,
        Christoph Lameter <cl@linux.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        kasan-dev <kasan-dev@googlegroups.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        iommu@lists.linux-foundation.org,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 18, 2019 at 11:06 AM Thomas Gleixner <tglx@linutronix.de> wrote=
:
>
> Replace the indirection through struct stack_trace with an invocation of
> the storage array based interface.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: dm-devel@redhat.com
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Alasdair Kergon <agk@redhat.com>
> ---
>  drivers/md/dm-bufio.c |   15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
>
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -150,7 +150,7 @@ struct dm_buffer {
>         void (*end_io)(struct dm_buffer *, blk_status_t);
>  #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
>  #define MAX_STACK 10
> -       struct stack_trace stack_trace;
> +       unsigned int stack_len;
>         unsigned long stack_entries[MAX_STACK];
>  #endif
>  };
> @@ -232,11 +232,7 @@ static DEFINE_MUTEX(dm_bufio_clients_loc
>  #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
>  static void buffer_record_stack(struct dm_buffer *b)
>  {
> -       b->stack_trace.nr_entries =3D 0;
> -       b->stack_trace.max_entries =3D MAX_STACK;
> -       b->stack_trace.entries =3D b->stack_entries;
> -       b->stack_trace.skip =3D 2;
> -       save_stack_trace(&b->stack_trace);
> +       b->stack_len =3D stack_trace_save(b->stack_entries, MAX_STACK, 2)=
;
As noted in one of similar patches before, can we have an inline
comment to indicate what does this "2" stand for?
>  }
>  #endif
>
> @@ -438,7 +434,7 @@ static struct dm_buffer *alloc_buffer(st
>         adjust_total_allocated(b->data_mode, (long)c->block_size);
>
>  #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
> -       memset(&b->stack_trace, 0, sizeof(b->stack_trace));
> +       b->stack_len =3D 0;
>  #endif
>         return b;
>  }
> @@ -1520,8 +1516,9 @@ static void drop_buffers(struct dm_bufio
>                         DMERR("leaked buffer %llx, hold count %u, list %d=
",
>                               (unsigned long long)b->block, b->hold_count=
, i);
>  #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
> -                       print_stack_trace(&b->stack_trace, 1);
> -                       b->hold_count =3D 0; /* mark unclaimed to avoid B=
UG_ON below */
> +                       stack_trace_print(b->stack_entries, b->stack_len,=
 1);
> +                       /* mark unclaimed to avoid BUG_ON below */
> +                       b->hold_count =3D 0;
>  #endif
>                 }
>
>
>


--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
