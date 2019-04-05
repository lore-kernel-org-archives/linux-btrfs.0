Return-Path: <SRS0=fkam=SH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 704C7C282CE
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 20:00:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3836020855
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 20:00:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J3FdQy6l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731695AbfDETyk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 15:54:40 -0400
Received: from mail-it1-f177.google.com ([209.85.166.177]:54051 "EHLO
        mail-it1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731611AbfDETyj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2019 15:54:39 -0400
Received: by mail-it1-f177.google.com with SMTP id y204so11411442itf.3
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Apr 2019 12:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=vSimYTuLgjd5F08SP0q5PaOcUXUMn2wOBBWQo3hphC8=;
        b=J3FdQy6lkURoKxPd5qgD22cSwoZzxcO28F3WrH1s7I+rIFIrHQV0k86b5Z5M2sZpjO
         oBLNzxRAjfXEjAFf9/EbGVdT+gFFJ01zB9fArV7WP0PpV4Q9PpmTP+3HhR7Q8PyPAG4H
         fHdfe23JE9ujLKi2gjHOqTBcm4qInAlH5nJ0qBFFd8VgT5b8F0nkarOji6fV07slGyVz
         OlKXr5u06va7Eh0ZLtrNoo+rQYtOGQ5Os4Dno1YxQSmHLjBEg4xcnpmomQ4KVRSkY9tM
         HUr8CKorbb3Q1EDttEZc2SzRBqMK+p8nUgzu1eOeKTzDqQ5W7WyodX6TXjf2iOhHzxqM
         p5Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=vSimYTuLgjd5F08SP0q5PaOcUXUMn2wOBBWQo3hphC8=;
        b=qMQ2Wqt+oy8lfsYtws3tH1hx51HC1CNgmewARGR+srE1CMKnftkX3NtcEL37WqMtEW
         158rH3fami3UbMhqo7rF2b8DcyU04go4Jw3psUpXPqlqsV1Nfrp/W4jpKpXZhJaEVtga
         C5Cu1qG/RrNnaA/7ufIxhXzEz14wY57B+yO9mjdzZE3pATn8tYQvEYLPruZu7DutyhOG
         5mh9X0lHOeRabvEBGMuUmca3H5m+PKyECDfC7mkcAijMcW2qZ81FHDKtpAYw0fLVX5pz
         /ySi6nnuNlC8VEaD6jJixVBl+aXt3o+1A+5cRHsfV4tzHSa5q1VFSfbvy0b6w28BwS6t
         w8xg==
X-Gm-Message-State: APjAAAUWL/6lyArGvUd0B55JJ7Qt8+UwLBLv/agrilr71WD7hNEzrG/+
        B7S24ix/DHSxFp5Vh99vlr6Vu5AP6TD7zQWgi8UkVvml
X-Google-Smtp-Source: APXvYqz3Xlhe0fjqaggZk79EzkiHPaHP5m445Q72LVixHlVgVE2UvHnete/KSSZVYGZ0TE167K/x3095IwRTxo8I5pw=
X-Received: by 2002:a24:8097:: with SMTP id g145mr11154675itd.31.1554494078563;
 Fri, 05 Apr 2019 12:54:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190404114547.GA1084@carfax.org.uk>
In-Reply-To: <20190404114547.GA1084@carfax.org.uk>
From:   Aleksandr Levchuk <alevchuk@gmail.com>
Date:   Fri, 5 Apr 2019 12:54:27 -0700
Message-ID: <CAK9PHfYcW+UQg3sPqgSukPe03g2Fvw6F-o4wqkFNZioi4uAbsQ@mail.gmail.com>
Subject: Re: IRC logs
To:     Btrfs mailing list <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

unsubscribe

On Thu, Apr 4, 2019 at 4:49 AM Hugo Mills <hugo@carfax.org.uk> wrote:
>
>    For some time, I've been running a log bot on the #btrfs IRC
> channel, and hosting the resulting logs. I'm currently re-assessing
> the collection of things I host and manage. Baudot, the "official"
> #btrfs log bot, has never really been stable, and is very sensitive to
> being disconnected from the IRC server (apparently not fixable with
> the IRC library in question). I think it's time to retire that
> particular codebase and let someone else run something more reliable
> for logging #btrfs.
>
>    Is anyone willing to take over running a log bot and hosting the
> logs? I can hand over the existing dataset if you want historical
> continuity.
>
>    Hugo.
>
> --
> Hugo Mills             | UDP jokes: It's OK if no-one gets them.
> hugo@... carfax.org.uk |
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |
