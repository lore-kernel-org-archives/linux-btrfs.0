Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3900FC10F0E
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 12:12:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AC502183E
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 12:12:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QYox3mHS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388939AbfDRML5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 08:11:57 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:45205 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388875AbfDRML4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 08:11:56 -0400
Received: by mail-vs1-f68.google.com with SMTP id o10so1003524vsp.12
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Apr 2019 05:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iSgCAvUEGOmkA7yqq7QK6OCH2CFcFcPt+JEh4ZctSK0=;
        b=QYox3mHSqW80j2A3IIiagUUBm09mZj02WRCKir6HBQx5T+b+hhAzGHQFOTwlONKbj+
         JJgyR/WQHwg8Cc7ukRkbYZ/f59+ReLAwpKS1zTzZMgMWjQjpa+NvSVrh8A8T3ceV7bLY
         uoXOMjV66AX9yM+yes+lXGolAtYtmsYKfcrPtWTFFr/7rqv9SEvseUou0t+cwv7s/iye
         TvT67Ae1wW9IHuwbcM5KGneuy8s3xRcKd0xOYCDyYWSzCvqtrVSm9//cPZFi/yYSzHlT
         1EQatPDgbrTsuxjhpE9ZcaOv8iSwAziw9Dkkkdizs+FhJMHfeZvWV03ILGIJlDd0RIEk
         lVyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iSgCAvUEGOmkA7yqq7QK6OCH2CFcFcPt+JEh4ZctSK0=;
        b=j4kXCGWdt/666N3Bwefm4tA8sQm7/nzIMb7tarbcyq6PtFD4DgILYRr/HwOt8SQwVN
         091BsddZukLnBMBVMdlbsXvJNVqY9fVNiEQ6AwcgmikqJjXzR8LLt76M5uDT3gxW8Oub
         m9938O3/aXBZS3DfVC1/F4SudDU8V+1RDFQ3ifT6kz9JG8g+Awamp4fTZYj+7PigAL6M
         cfX0GT8ptUbM4bqfLOGaxStMT3gbBf5DGiM56JK6sQ3bGXJmNLxRyUcPfPDtOdD6g8z2
         +VqPHZ/WAG+3YDwvrvL37qXoDuT4NEr8ZKu2re8C5uPitybfooEm9AgTMoz1ifY3FUZA
         g0HQ==
X-Gm-Message-State: APjAAAXBfDtneVTPtwW2sWH47sFOHZv4PEdm1CmckQWgaUcXi25TVzAf
        MJxGLMsVekYa5QouHEuN43kA0wkGZRh5dfEmCPYFYA==
X-Google-Smtp-Source: APXvYqwECAvEJzUlV7fzRl9b6wg7o0AisQ+1RCTx/KeiR4GaCwP9nHgwP4vp46KXwzB2ZT6/gaSoiXLGbekHjekrJKI=
X-Received: by 2002:a67:e30a:: with SMTP id j10mr51098919vsf.103.1555589515631;
 Thu, 18 Apr 2019 05:11:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190418084119.056416939@linutronix.de> <20190418084254.361284697@linutronix.de>
 <CAG_fn=WP9+bVv9hedoaTzWK+xBzedxaGJGVOPnF0o115s-oWvg@mail.gmail.com> <alpine.DEB.2.21.1904181353420.3174@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1904181353420.3174@nanos.tec.linutronix.de>
From:   Alexander Potapenko <glider@google.com>
Date:   Thu, 18 Apr 2019 14:11:44 +0200
Message-ID: <CAG_fn=WL0yLqavV_mhodT=B6KcAzJ+LS0hss1jqany9Cn92RHw@mail.gmail.com>
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

On Thu, Apr 18, 2019 at 1:54 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Thu, 18 Apr 2019, Alexander Potapenko wrote:
> > On Thu, Apr 18, 2019 at 11:06 AM Thomas Gleixner <tglx@linutronix.de> w=
rote:
> > > -       save_stack_trace(&b->stack_trace);
> > > +       b->stack_len =3D stack_trace_save(b->stack_entries, MAX_STACK=
, 2);
> > As noted in one of similar patches before, can we have an inline
> > comment to indicate what does this "2" stand for?
>
> Come on. We have gazillion of functions which take numerical constant
> arguments. Should we add comments to all of them?
Ok, sorry. I might not be familiar enough with the kernel style guide.
> Thanks,
>
>         tglx



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
