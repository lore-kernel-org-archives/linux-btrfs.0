Return-Path: <SRS0=CP9i=S5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58414C43218
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Apr 2019 20:54:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 165A12077B
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Apr 2019 20:54:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="sL9pAZg7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbfD0UyU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 27 Apr 2019 16:54:20 -0400
Received: from mail-lf1-f42.google.com ([209.85.167.42]:44068 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfD0UyU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Apr 2019 16:54:20 -0400
Received: by mail-lf1-f42.google.com with SMTP id h18so4883641lfj.11
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Apr 2019 13:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WONkZ2Ibu39Dqe9xNGnvoWBaAt04ZqmAnyF4/NOoKHk=;
        b=sL9pAZg7YGSyB8wLqEUcEW9WWyh8dVXqpL2s7Fr+e2enhYKimsvXozvTtRMtf1MYym
         uw4+nAI71yuKZ41yz4/4z0GDV18Hm59esIoNE9xIW+u4/Bob8HpozMumqn9KU2nO/IjM
         iptVz10N6OS+UjUva946jSuKW+Xh+gTSm3OAxOdtBluos0YiTL96OGdVdREdQXu1MKMO
         LE+y7sBIIeyLmtMZB7eFFozNHFKIsGvyfHqathgVYRjHQseNhp0qH+2k3sPbx6hCcsZr
         Mz7LuZq8SoIl5UOaxZD6sWZLhkwxWZKX/aNvZL2CjHvDcB4AyfxM85rOfZXSdZty0mGh
         FaDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WONkZ2Ibu39Dqe9xNGnvoWBaAt04ZqmAnyF4/NOoKHk=;
        b=VyE/flNs6nWD9sDc9GueLfRTW9O875dH8aCUYUMHuaaE4Z6KgcPr6XJBhliuQWbw/O
         YaGQL4X/2edrLmCkAIQRlbI6hl6gsnHl3qhP1XUnDaxCcUHq+E9jSjhSu5xFQWUVLyHk
         vsPbk3zajnAWtSbR1Hf+2ex42F3x5D8hpBwoNJntqprDsfv019VuRr6+CHEDkyQEqxD/
         Rz836CpWPHb1p3mCf9jJV8t53RAWkfm8N/DXPxadgCSQJ4PPq1E1JQUhm79YKla/tCKI
         YTec2taFuMNkoYd5DySy7E9GV6IwrgZK8z1ercUxahDlYAH5C2S2cyJnKaf6N49V3pmK
         InAA==
X-Gm-Message-State: APjAAAUjHXGbzw/TbKggvnZbKa08OCzVbCVPnV0pBzlhRH3x9g8Tp5TU
        zXarVPGlsLlmFFVN+2bp6dK0Pdbf01zPGKR7SGTl+w==
X-Google-Smtp-Source: APXvYqzjns8D2bk6kwnAx06ijSrrk0jOmqunzKJ+kXD9fGdUMxj8qd3+Y6vA7uAtLTj7Bnfjg4pdelnL+uIlZfMw2J4=
X-Received: by 2002:a19:750e:: with SMTP id y14mr27662056lfe.74.1556398458691;
 Sat, 27 Apr 2019 13:54:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190425223457.5a7dfd20@hydrangea> <aa5623ca-e1c2-4499-75ee-be818acf3333@gmail.com>
 <20190426135027.62dcaa31@hydrangea> <efad3130-e13d-2649-556e-6e932e5a4dc6@gmail.com>
 <20190427031225.7f04d7bb@hydrangea> <8cdd6929-b768-795c-162f-cf41e8b94029@gmail.com>
In-Reply-To: <8cdd6929-b768-795c-162f-cf41e8b94029@gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sat, 27 Apr 2019 14:54:07 -0600
Message-ID: <CAJCQCtQG8Roa88-GPHLZZF8NRuTZPwvq=zeVo8=LGHsVCR44HA@mail.gmail.com>
Subject: Re: Some file lost when send back snapshot.
To:     Andrei Borzenkov <arvidjaar@gmail.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Apr 26, 2019 at 12:27 PM Andrei Borzenkov <arvidjaar@gmail.com> wrote:
>
> btrfs send/receive expects subvolumes to remain read-only. As soon as
> you start fiddling with read-only status you already lost. btrfs should
> have never allowed to change read-only into read-write in the first place.

I'm in agreement, and would like to see 'btrfs property set <> ro
false> removed. It's confusing. Once a subvolume is read-only, it
should remain read-only, and if the use case requires rw, then just
snapshot it (default rw).


-- 
Chris Murphy
