Return-Path: <SRS0=M5aM=SM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0659EC10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 13:47:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C606C20830
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 13:47:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F9QaUd7n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731910AbfDJNrj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 09:47:39 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:35317 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730167AbfDJNrj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 09:47:39 -0400
Received: by mail-ua1-f67.google.com with SMTP id a46so794583uae.2
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Apr 2019 06:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zQQOrgESGDCkEyrIM71xSzHfX8ZEuYbZibrK3lIv7i8=;
        b=F9QaUd7neKHbxseTkVzKegwJs/tU/hugwDn1aiLgnXVphYCY+GceIM4ZyYNceOouUs
         5Gmaz/0gRqFKLhDS4Ev0TEinnFid9qVy44F9flqMTliwsnaQeVuvIGFoDeGvvfG3C4P2
         zexc4jy6oQU3UWkgEwfg9/pNKw4fdtsnoYMtqpIymusA6FHd/q12inlwsVDb6RGBZfIL
         caF0O93WMNDKZqoAUe/Q5JZvP5OPUGjiZaqOlI/FtJA4qbHZg5BRrY+5MVt0iLDiPTp7
         5LmfruLcknIkWjWRw4BrR6Erx62ECjL+uVCQGeR4GChxI6Uua3eDzFWMWM8kUzksra71
         SrAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zQQOrgESGDCkEyrIM71xSzHfX8ZEuYbZibrK3lIv7i8=;
        b=Cw16roiaBTG8IadkEJiD2PJNo4zPAikyTmh+iCJDs6a6YXA+2MgS76RIYCqc55yry1
         Xkk+AG8yGczTrKgN0zEpq9RMpTjSIA0o925+aPNhqjQl0ISHVQZX5hNKVCExt0jJnvYZ
         3SphueEFUoBD8TCmIBHcYVNktEBBpRM3MbGLGDk6//OfUhA/T7Kh1qYeu3Bp3BkaXBC1
         7UgF3UhPYqc2d+8QCYVBU9MS98u9tmv6slOK7TFsB9f2DELLOd9kMAX/XvrsjFMz/Qol
         rUQ4+biVIRaiBii9n9xhjy+bQ5p8jAFD7b7MIfqmo+oyZ/cwhZjdqJdz0vpXdyN2tb/u
         7Q3Q==
X-Gm-Message-State: APjAAAVOr45SD+s6cbthkqcCoZz1p0l2FiQPyYt7zOh1v8aq2mau6AXM
        0x3BmAIc+U6wvuK40QODlrpAkP0JHFqkpynrazMg2w==
X-Google-Smtp-Source: APXvYqx6rmKTlAdG3lUDpiRVJ7to6JQCFZkxpN4lSbXlHXBDJbFOqkcG5pK/Sz08ZMkiqv1PM0ws2nJeIMhqJE6UHOc=
X-Received: by 2002:ab0:1d82:: with SMTP id l2mr23247938uak.120.1554904058043;
 Wed, 10 Apr 2019 06:47:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190410102754.387743324@linutronix.de> <20190410103646.221275815@linutronix.de>
In-Reply-To: <20190410103646.221275815@linutronix.de>
From:   Alexander Potapenko <glider@google.com>
Date:   Wed, 10 Apr 2019 15:47:26 +0200
Message-ID: <CAG_fn=WaiTn9J6wS=1XsJWuorbRCg18Oe0PMAiHx9heb04v=ig@mail.gmail.com>
Subject: Re: [RFC patch 29/41] btrfs: ref-verify: Simplify stack trace retrieval
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexander Potapenko <glider@google.com>,
        David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 10, 2019 at 1:06 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Replace the indirection through struct stack_trace with an invocation of
> the storage array based interface.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: David Sterba <dsterba@suse.com>
> Cc: Chris Mason <clm@fb.com>
> Cc: Josef Bacik <josef@toxicpanda.com>
> Cc: linux-btrfs@vger.kernel.org
> ---
>  fs/btrfs/ref-verify.c |   15 ++-------------
>  1 file changed, 2 insertions(+), 13 deletions(-)
>
> --- a/fs/btrfs/ref-verify.c
> +++ b/fs/btrfs/ref-verify.c
> @@ -205,28 +205,17 @@ static struct root_entry *lookup_root_en
>  #ifdef CONFIG_STACKTRACE
>  static void __save_stack_trace(struct ref_action *ra)
>  {
> -       struct stack_trace stack_trace;
> -
> -       stack_trace.max_entries =3D MAX_TRACE;
> -       stack_trace.nr_entries =3D 0;
> -       stack_trace.entries =3D ra->trace;
> -       stack_trace.skip =3D 2;
> -       save_stack_trace(&stack_trace);
> -       ra->trace_len =3D stack_trace.nr_entries;
> +       ra->trace_len =3D stack_trace_save(ra->trace, MAX_TRACE, 2);
Now that stack_trace.skip is gone, it's unclear what this "2" stands for.
Maybe add an inline comment saying it's skipnr?
(This is probably valid for all other stack_trace_save() callsites)
>  }
>
>  static void __print_stack_trace(struct btrfs_fs_info *fs_info,
>                                 struct ref_action *ra)
>  {
> -       struct stack_trace trace;
> -
>         if (ra->trace_len =3D=3D 0) {
>                 btrfs_err(fs_info, "  ref-verify: no stacktrace");
>                 return;
>         }
> -       trace.nr_entries =3D ra->trace_len;
> -       trace.entries =3D ra->trace;
> -       print_stack_trace(&trace, 2);
> +       stack_trace_print(ra->trace, ra->trace_len, 2);
>  }
>  #else
>  static void inline __save_stack_trace(struct ref_action *ra)
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
