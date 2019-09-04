Return-Path: <SRS0=9QTO=W7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1886C3A5A2
	for <linux-btrfs@archiver.kernel.org>; Wed,  4 Sep 2019 01:13:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D5DF208E4
	for <linux-btrfs@archiver.kernel.org>; Wed,  4 Sep 2019 01:13:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="Pm01+vJH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbfIDBNJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 3 Sep 2019 21:13:09 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:42956 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727348AbfIDBNJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Sep 2019 21:13:09 -0400
Received: by mail-wr1-f50.google.com with SMTP id b16so19334343wrq.9
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Sep 2019 18:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D0Gheb0iN9D89VJzzrF1EBfAJgeJ5DNCY3BVsl1yujE=;
        b=Pm01+vJHgJRPBkk2eR0UoWSUAYjwFMKhYswTLOwvd7TGMq17BTWimH7J+z9P+t3sgm
         3Lg/3nkUujDJGLLUAWYgXhpIqr52rCD8Dr+JTEhdQM+6RprWHfkcT8wnM7AjUl7o7I8X
         wAFEvH9vwN1+b2nd8f6gLWbVdLOBmwlHpOn6SG/kmHRgrhjAjPK6kam4ifSFhOPtP8xh
         eQjaHf90c+h7CqKnbadQCp3aLyqhUtIDoBzN+qQTeDrXG6/4IFbUhPfOyku87Mc21C6A
         CmUBKmVVKvLPeHbrperEq3jaDs5/x1qfDhwcvVi4Mv3jnNNR07jDB3aerqySlP5YzX2F
         o8xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D0Gheb0iN9D89VJzzrF1EBfAJgeJ5DNCY3BVsl1yujE=;
        b=kQfAwCdhPCMzfpNStqiI3eoiur8odqf5DbS2343FIZhS8rUL3IWZzP6SJx+YDmo7Fx
         A1LRGUKLbO8wrkrpeGxr+Qy3UYBDTtVpsRA+A1b9R4AwHVb+GdhyXpg58bdsLHwkdGdP
         oe/C8MXjYWOzDkmCW4Ajc48eJSgFOFLc6G+vtDTGQIu4KrbAdmaf+FGqRlUohpvAiZ6R
         G1IXBWAO4rfvuIhqTwm/j2WYNalQyKf3PhsGHwjN09HlA2fTDDMgfhdnvbuVaJAQjsPv
         nA+hL8esv6kCWNqS/35RzHeBwsN8eoB4tz9OwzlqQ21jBJ6nRaFBVNZQIb7SSsqcPL0S
         GOnw==
X-Gm-Message-State: APjAAAXgN4og4KJWmIsYE3teWqOLwnAXxEGmJeUk4NODV8xbxUbhz7ID
        k1KxbLHnMMDV6rnqvv7Yy+BoPzNwTLmKaW1EKzrKY8AMkpr5ig==
X-Google-Smtp-Source: APXvYqz3UBSqecW0WJSk4VYy+GrfYAPx0kmXZTT/LtnIowdFqM44B6mRYO4Wm/zNewlQZdMnU75PcbUaIuE5lbdQI7I=
X-Received: by 2002:a5d:46cb:: with SMTP id g11mr14466wrs.268.1567559587221;
 Tue, 03 Sep 2019 18:13:07 -0700 (PDT)
MIME-Version: 1.0
References: <204b3c8c-2f29-2319-b69e-37426cf5c792@dirtcellar.net> <CAJCQCtR=6nw9Oin8b7ELfz41yPadFwwqFQQT_4pc36ykVTbmEw@mail.gmail.com>
In-Reply-To: <CAJCQCtR=6nw9Oin8b7ELfz41yPadFwwqFQQT_4pc36ykVTbmEw@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Tue, 3 Sep 2019 19:12:56 -0600
Message-ID: <CAJCQCtTg-+8uE+uge36qSPC9A7zY7K_o1UZAPDu1SramxAd9-w@mail.gmail.com>
Subject: Re: BTRFS state on kernel 5.2
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

raid56 status grid says Unstable, but the body text below says
"Feature marked as mostly OK for now."

Both might be true. The feature with this version of the feature flag
might be mostly OK, with the write hole. But if an intent log will be
needed to fix it, and if it suggests a new feature flag, it could mean
it's unstable in terms of future incompatible change is expected.


--
Chris Murphy
