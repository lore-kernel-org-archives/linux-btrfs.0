Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B0DAECDE46
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 16:21:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDF6A207DD
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 16:21:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ee+/8k7R"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDF6A207DD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbeJYAuF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 20:50:05 -0400
Received: from mail-lj1-f174.google.com ([209.85.208.174]:34365 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbeJYAuF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 20:50:05 -0400
Received: by mail-lj1-f174.google.com with SMTP id j17-v6so5358151lja.1
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2018 09:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DptqEy+nciugpvcVHLeYgvMSwp5WzQ5f/6btEMV4eHA=;
        b=ee+/8k7RVjsl6mU8FyU5knAK/EJ1e9w1tLXbZo02aYNJBKl55aTp0gV07BJG1fhDeS
         MKn5rJK4+jzywcxG3SlgoB445XSsS9MaT2vVCnW40DMzYcGRO76QA0lXHNoK46m1Mtki
         wHQpQqkQ8vbgeLFQ8Ay3OjFw2ArFOQWuMHBN4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DptqEy+nciugpvcVHLeYgvMSwp5WzQ5f/6btEMV4eHA=;
        b=WLMkXAAd8LcOQq7yzVwhdxe7fK5eQvNnUV8gLmfUY5aV1d8L3k2y7rhA6zODhFxuNM
         EtHd+fTqJ0vIyn6B1e/oWv2GNk2480fiOBP2Tu9cykQXQCvg7wAZ04Hq7MqglRZkxphY
         IwVJAYhOPlRLBj+E9l0ceqLCP7Uqw0G35IslYK7ggtMvGbxm5eI9ftYSdejnm87vESqs
         M9wkVJv1UzubQA6cYiU36eiCziIk4V5ogP5A7RhaABqRWXhEAomJVGyQ2FD6+WbPWoj1
         RJF2JeTkychiJdNWLcrsKUN09bGqPrc4iZk9NMAPjABGmNzzI9g7vJgLTDOznJYirLEq
         qaSQ==
X-Gm-Message-State: AGRZ1gLj8CIRT+x6Z4rb9b6r3rZ4os70Zp8KKvsYxS0FAq6fHHz303gN
        0Sw+L8qAQrSnTMTpSnypytDzLU8wnYAvPIJT
X-Google-Smtp-Source: AJdET5cvxGGOypHzDGf5M0P5V+qL1O/q7ydQ2pKYUUa861BFyHfsRsDmVDC7tpCt9hkvo+WUJIkPIw==
X-Received: by 2002:a2e:3e0b:: with SMTP id l11-v6mr2465696lja.16.1540398080880;
        Wed, 24 Oct 2018 09:21:20 -0700 (PDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id i143-v6sm776282lfi.57.2018.10.24.09.21.19
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Oct 2018 09:21:20 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id q6-v6so3709861lfh.9
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2018 09:21:19 -0700 (PDT)
X-Received: by 2002:a19:1cc3:: with SMTP id c186-v6mr14579756lfc.16.1540398079344;
 Wed, 24 Oct 2018 09:21:19 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1540227161.git.dsterba@suse.com>
In-Reply-To: <cover.1540227161.git.dsterba@suse.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 24 Oct 2018 17:21:02 +0100
X-Gmail-Original-Message-ID: <CAHk-=whSRV1vtR5TbOPW0TH0-y7ZKQ3kdew1AwtKLXztR8004g@mail.gmail.com>
Message-ID: <CAHk-=whSRV1vtR5TbOPW0TH0-y7ZKQ3kdew1AwtKLXztR8004g@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs updates for 4.20, part 1
To:     dsterba@suse.com
Cc:     Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 22, 2018 at 6:22 PM David Sterba <dsterba@suse.com> wrote:
>
> this is the first batch with fixes and some nice performance improvements.

Pulled (at 30,000 ft, somewhere between Ireland and Iceland),

              Linus
