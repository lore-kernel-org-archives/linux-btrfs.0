Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EB8EC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 13:58:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0EBD20661
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 13:58:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="BZHRu3Dj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730392AbfB0N6a (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 08:58:30 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:32928 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730114AbfB0N6a (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 08:58:30 -0500
Received: by mail-yw1-f66.google.com with SMTP id i204so5628753ywb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2019 05:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/nZm3oN9jZBP2WpnfWbRwyzNRZlq/f4dhq8z87GLfX4=;
        b=BZHRu3DjvWuAKhOvxniZHOg6h1gAX/BGOvMEI45eb1opAq+Os8YAfZzTHzwtPoOjhZ
         afibbkHpX31idddhrC5jHzTbaDB/d5hLyetao2SnhMcl+fDK35aCKOVUF4evdiKlf0f/
         96zhX0T9lla+T/ktU0Y+5TZTrnwjJlAIqygFMdtv/M68cwXQiX9f5T/LPL6+ZX6JGECa
         D0/PdRfiINmazH/XH7y0bXX8ZcKMk141IahGQ697tr+rKAmwx3exIISR+MSyrp1BYLNg
         Cnpw7DoNJa+mqUvaEcI4V5DYj1YZU+eGAkumfFNGOmVr2bohX03a4p8OWbIK8v3uIRvt
         lP7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/nZm3oN9jZBP2WpnfWbRwyzNRZlq/f4dhq8z87GLfX4=;
        b=Cmxs8ubj/db6oDJlaw3jDoPED19XNvKdPfV+f0Jg4uIFE1zHCXzSuXhSzAcMIua7u1
         aDKiIh0CVgMLnvqiB0hmtfnw8zMAxnMRJ0CN18qYTAR0QVGXcbRL3HAhv+8hC9jxZRJS
         EWQwwnQKC2wlMnnF6O5LAlYTuu8rzT/mitjzs1eN/VjEjj4cvOTEqdJGRynJhZFf+cxu
         gso6qe2tI4IjiEql2aWNbjEeTiB9Rjn0AlSRILr2UT/BPz+IIro7WLlmk52//dvJdUTJ
         9Jt0hqmPPmDCwU4vvBrh7A9OF4SaMIBs8ZuExGwg8tUCtGmTHmL+hSST85xoyzW7Ucis
         bniQ==
X-Gm-Message-State: AHQUAuYPVtY9GjnF89KyhSNZyaDkzj6sYQyDq7pDwowYebQtK/LPHVQn
        ktHpdO7iSE7q8hyHWjeUCGJMXXNEyvkndcoqqfI=
X-Google-Smtp-Source: AHgI3IYe+3byZ3iiCZhMAv+z1PSGFmwAZgA9CChy8aS3HGsms+S1oZ3UxxLtB/aRBnSpRCCSrutxVvHQe+qhXYN7gTo=
X-Received: by 2002:a81:6841:: with SMTP id d62mr1187823ywc.507.1551275909352;
 Wed, 27 Feb 2019 05:58:29 -0800 (PST)
MIME-Version: 1.0
References: <20190227051602.28987-1-wqu@suse.com> <CAMU1PDi9GD9TC6B8kN4iGbeddOxkPH7B+UxeiVbC_KOwJvxnzQ@mail.gmail.com>
 <62c5272f-6e30-4ea2-dff0-853bad22fb14@gmx.com> <20190227114359.GA28913@hello-penguin.com>
In-Reply-To: <20190227114359.GA28913@hello-penguin.com>
From:   Mike Fleetwood <mike.fleetwood@googlemail.com>
Date:   Wed, 27 Feb 2019 13:58:18 +0000
Message-ID: <CAMU1PDh=Q0uyOOmg63UNs597DY01+AmAkDayDKRsa1HrsBPFTQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: gitignore: Ignore hidden files
To:     Stefan Traby <stefan@hello-penguin.com>
Cc:     Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, 27 Feb 2019 at 11:44, Stefan Traby <stefan@hello-penguin.com> wrote=
:
>
> On Wed, Feb 27, 2019 at 07:29:13PM +0800, Qu Wenruo wrote:
> > On 2019/2/27 =E4=B8=8B=E5=8D=887:22, Mike Fleetwood wrote:
> > > On Wed, 27 Feb 2019 at 05:16, Qu Wenruo <wqu@suse.com> wrote:
> > >>
> > >> A lot of editor/IDE related config files are hidden files, like .vim=
rc
> > >> or .clang_complete.
> > >>
> > >> Instead of adding gitignore entry for each editor/IDE, just ignore a=
ll
> > >> hidden files like what kernel does.
> > > I think you mean:
> > > files starting with ".", like ls does by default without the -a flag.
> >
> > When I punched the words "linux hidden file" into google, I got quite a
> > lot of pages showing 'In the Linux operating system, a hidden file is
> > any file that begins with a "."'
> >
> > So I think the words "hidden files" should be more or less OK?

My main point was that you said "hidden files like what kernel does"
which is not true.

>
> I think the word "dotfiles" is ok.

Shortening to "just ignore all dotfiles" would be a good choice.
