Return-Path: <SRS0=b0aI=NP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D91C32789
	for <linux-btrfs@archiver.kernel.org>; Sun,  4 Nov 2018 16:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A04D2082E
	for <linux-btrfs@archiver.kernel.org>; Sun,  4 Nov 2018 16:09:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LWzBc2LQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A04D2082E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730791AbeKEBZH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 4 Nov 2018 20:25:07 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43668 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730078AbeKEBZH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Nov 2018 20:25:07 -0500
Received: by mail-pf1-f195.google.com with SMTP id g7-v6so946138pfo.10;
        Sun, 04 Nov 2018 08:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pJH1UJ1UUiZqA2H1nvzPglXtxbwZj5EyROaISkJw4F4=;
        b=LWzBc2LQTWnbcvJrInkd3YdlttbNw7WYGCIsBGK7L4Q5kqPYOzKYheAMlfFjHY7PWT
         tEmQ/8nlTe4zC2J6F6WcgPMx0Pe4YzS5eHnxTJFQyHhNwOYOIwb4JQReMAz5R98cFyUT
         8u7mZINUHKAlmj968CCjgwMRmN57Tu4Mk99qLywT6JZP38iIkqrTi5OsGipA/PNi4+fy
         6VmsAhCdqZFl7oHe365oQiPYrQPBb+uiiLGhWi035LPHliX+x+xrNip35EBNfRr5ezNX
         X22UzApYGS3BwA/NGXARhgPSfIi5hV+dk+/6p3fISMJTWdegt1b5mY+PWAvgDBAAEOSw
         TVgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pJH1UJ1UUiZqA2H1nvzPglXtxbwZj5EyROaISkJw4F4=;
        b=m70uPTUmfCcSOcPcPyP5t7XKlMSkA2Q6k4Q59zaZjz5EqSe54J7uEE2T09mRWJFZW+
         8gd9dqwtcQWdyz7ygpg1s6TS+l/jvg1XWRWb0oO4pVNUI5Ln44BTc6jF5LuZtxQlFC7m
         i2VvF66/t2VBW5jgYIz3eu2MpJRw/8fSuWMnNm5J4r/6uaM2wZM3WJBB6+aiJkkL8YFB
         /ah4+ZFRkUsh32x+pDVBp0HlMMuliLnoKl+eJJzx5isLd9TME4oWrvT5/m+H9iSetieH
         aTMzEl1lcYzjUD8MCwfuSqvNllv96EbjEys6wkI4U+xJFdAz7vjYkGup4SVnREeBp3YI
         MwUw==
X-Gm-Message-State: AGRZ1gJXeOD+6J/hqN3rzqZaLxq1VZCh+RbYbBwLZWyRQbOP4NkAWqsA
        RXr0Z3CxGHmaNQwlN+VZWsY/uffHpR88Lg==
X-Google-Smtp-Source: AJdET5fS+K/0Y9NAR2EJ31/Tlqu5pNYP7gXQy2dtk7uAkqeSK3BrlKpKwkEG4BExYgN0C1b/Dl32Gw==
X-Received: by 2002:a63:a112:: with SMTP id b18mr17368006pgf.440.1541347778158;
        Sun, 04 Nov 2018 08:09:38 -0800 (PST)
Received: from localhost ([128.199.137.77])
        by smtp.gmail.com with ESMTPSA id b69-v6sm34691583pfc.150.2018.11.04.08.09.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 04 Nov 2018 08:09:37 -0800 (PST)
Date:   Mon, 5 Nov 2018 00:09:31 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     fstests@vger.kernel.org, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/7] fstests: test Btrfs swapfile support
Message-ID: <20181104160931.GE12788@desktop>
References: <cover.1541193856.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1541193856.git.osandov@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 02, 2018 at 02:29:35PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> This series fixes a couple of generic swapfile tests and adds some
> Btrfs-specific swapfile tests. Btrfs swapfile support is scheduled for
> 4.21 [1].
> 
> 1: https://www.spinics.net/lists/linux-btrfs/msg83454.html
> 
> Thanks!

Thanks for the fixes and new tests!

> 
> Omar Sandoval (7):
>   generic/{472,496,497}: fix $seeqres typo
>   generic/{472,496}: fix swap file creation on Btrfs

I've merged above two patches, they're two obvious bug fixes.

>   btrfs: test swap file activation restrictions
>   btrfs: test invalid operations on a swap file
>   btrfs: test swap files on multiple devices
>   btrfs: test device add/remove/replace with an active swap file
>   btrfs: test balance and resize with an active swap file

These tests look fine to me, but it'd be really great if btrfs folks
could help review above tests and provide Reviewed-by tags.

And perhaps we could add test 17[56] to 'volume' group, as they do
device operations. And similarly, add the last test to 'balance' group.

Thanks,
Eryu

> 
>  tests/btrfs/173     | 55 ++++++++++++++++++++++++++++++
>  tests/btrfs/173.out |  5 +++
>  tests/btrfs/174     | 66 ++++++++++++++++++++++++++++++++++++
>  tests/btrfs/174.out | 10 ++++++
>  tests/btrfs/175     | 73 ++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/175.out |  8 +++++
>  tests/btrfs/176     | 82 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/176.out |  5 +++
>  tests/btrfs/177     | 64 +++++++++++++++++++++++++++++++++++
>  tests/btrfs/177.out |  6 ++++
>  tests/btrfs/group   |  5 +++
>  tests/generic/472   | 16 ++++-----
>  tests/generic/496   |  8 ++---
>  tests/generic/497   |  2 +-
>  14 files changed, 391 insertions(+), 14 deletions(-)
>  create mode 100755 tests/btrfs/173
>  create mode 100644 tests/btrfs/173.out
>  create mode 100755 tests/btrfs/174
>  create mode 100644 tests/btrfs/174.out
>  create mode 100755 tests/btrfs/175
>  create mode 100644 tests/btrfs/175.out
>  create mode 100755 tests/btrfs/176
>  create mode 100644 tests/btrfs/176.out
>  create mode 100755 tests/btrfs/177
>  create mode 100644 tests/btrfs/177.out
> 
> -- 
> 2.19.1
> 
