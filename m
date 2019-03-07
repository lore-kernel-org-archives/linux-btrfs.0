Return-Path: <SRS0=nVQC=RK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B62BAC43381
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 17:58:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 858A720840
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 17:58:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EoYi74SU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfCGR60 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Mar 2019 12:58:26 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33597 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbfCGR60 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Mar 2019 12:58:26 -0500
Received: by mail-pf1-f194.google.com with SMTP id i19so12020816pfd.0
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Mar 2019 09:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=8VsHJfo8YdLm1sjO4eMpCNwfZOE+M1UOmaF2z5vJeTU=;
        b=EoYi74SUw9dJ9NWfgJcKveZOlAIfxdfUCPyS9Lq+Co04l/ck/Ua6tiaWiE5n5r8621
         tAiZJm5z4uaYkkeAmsGWLpVXHeGJ3pDcXc0SdUvu6eko1wgPHV0l5NVzsszAi4BWR51C
         G+B3Hu3nQIDpdbo9E50t3E27yXw+1ccvPHeMEIKs+3aStXfVscF/bTbmy+lLwtCnXJ1B
         zY9v0Nx+HBFa6fBMqG+IA072WYTMMBVjnf3lTkw2kjVGRFdyPJGYZFehPS4jAGQ9A0ah
         nVdzz5+U6jJ1PuPY5kHUX0zjENUlsM/2GDLpXvQ6xnU/0/ZyeOP+RtwOd2kIQGX0qlrg
         pBRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=8VsHJfo8YdLm1sjO4eMpCNwfZOE+M1UOmaF2z5vJeTU=;
        b=YDcquADv9BSegwg9QcJUPXxUpnU8fnZSdN8YBKyNQbSQ62lm6cDA5yNSjPRz8eu7Ma
         ARfcVp2JfNKOWp3kwhyyJwHMMb/eGeqrJsSyr4hGYJPUgPis+3DCklb1pBK9EPNmMLkd
         rOboujolJM9zyxft5X5IkxNRxkc9dN1yhYKU6ytgUfkBFE37HIm0tARjWimvVvGX+VCN
         ArrOmj/fPpJRp0KAG1VGYGx6Afi9gr181cFonJpoUsHSjDtlFOLysuyB2ubD+nxW73Ym
         uGusOS6TmVffCYqsbVNuUjJ3JmrrzA2uGXpKgVoiedRZEmJtHTBQfr8BxpNncAiZa2yi
         fVGQ==
X-Gm-Message-State: APjAAAXUkgRRpc8zgTKrUvuzfKuRA2C2MwOTQULHoIvK9qHT6nbUtEUT
        BVDMIILmTAUX6DfNgrtNFqzvOLbxnx5z5swVXyub/g==
X-Google-Smtp-Source: APXvYqzhv3AuMyTkWnLFl4VFxzOfI/H3TxwX8+aD+FLiJM3ERLnoOGCBXxiLuX3Wa90peo3iO2A6ETSPJDCO3rSxj7E=
X-Received: by 2002:a62:f20d:: with SMTP id m13mr13818724pfh.174.1551981505308;
 Thu, 07 Mar 2019 09:58:25 -0800 (PST)
MIME-Version: 1.0
References: <20190307163515.2168-1-natechancellor@gmail.com> <20190307175550.GO31119@twin.jikos.cz>
In-Reply-To: <20190307175550.GO31119@twin.jikos.cz>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 7 Mar 2019 09:58:14 -0800
Message-ID: <CAKwvOd=SY7wOD0UTXcqcY7ugprOMgbbb8y0Z-rTGQpBqRJ8YaQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: Turn an 'else if' into an 'else' in btrfs_uuid_tree_add
To:     dsterba@suse.cz, Nathan Chancellor <natechancellor@gmail.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 7, 2019 at 9:54 AM David Sterba <dsterba@suse.cz> wrote:
>
> On Thu, Mar 07, 2019 at 09:35:15AM -0700, Nathan Chancellor wrote:
> > When building with -Wsometimes-uninitialized, Clang warns:
> >
> > fs/btrfs/uuid-tree.c:129:13: warning: variable 'eb' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
> > fs/btrfs/uuid-tree.c:129:13: warning: variable 'offset' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
> >
> > Clang can't tell that all cases are covered with this final else if.
>
> The chain of conditions is
>
> if (ret >= 0)
> else if (ret == -EEXIST)
> else if (ret < 0)

In the few cases we looked at, it seemed that the compiler's heuristic
for coverage doesn't try very hard.  I assume once you start having
more complicated expressions is gets quite difficult to prove.

Thanks for the patch Nathan!
-- 
Thanks,
~Nick Desaulniers
