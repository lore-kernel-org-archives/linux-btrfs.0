Return-Path: <SRS0=zwl1=CC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08390C433E1
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Aug 2020 03:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7BF52078A
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Aug 2020 03:02:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="VLcuVKMF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgHXDC1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 23 Aug 2020 23:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbgHXDC0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 23 Aug 2020 23:02:26 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D5BC061573
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Aug 2020 20:02:26 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id x5so6902252wmi.2
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Aug 2020 20:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7IBmL+oYBth8PsmgIwZEUpYe3wdu+UpkB7zgP0tqrqE=;
        b=VLcuVKMFeLJ7VtP9LUBQRwiJgzhaMMuVG7yLFCAMpYw6pdBrfOpkPBLM5mxmwv+Jl/
         RJHXPfepMBFFqlKmhkiYVR8xDr62enITMyHj9h/RdCv8AIlTlwuCtk2a1CuQpaWZXH3I
         dy4vnbhbCN0CSoazOetkMCRIRLQgZ9HvI0+WYpHJk9UIZsQiokw5zscBBGjtB0zJ5ptb
         oEBlAXOx0QEmbX8wFCyMWc1RHk5eieNTRUQb0HHzD0hKyZoHrdgktQGyYaqbqtZsDvZu
         aGk+0mOfZhC7gUhzZ9iXioGnZaJ6YqHg3RbTzDg786e3O+B93Vk8RPo3tZjf/tDd4QU6
         1+Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7IBmL+oYBth8PsmgIwZEUpYe3wdu+UpkB7zgP0tqrqE=;
        b=fXnuZoKy01ZzwAudFFp3KXvS6WYXrCuJ7J7RNUa+5R8lwWAqOnF78h3CuPHVYOju5R
         UqaeIy8a+Oa60ccv+zNOuUXq1Ldm7IQbT0FbSTYkMsrbL60mBRQRLJZa9LT2GyozRr0W
         urdKN4TeNXr/CrXjYmqeL9iJiAACYFQ2u6T7HnSY403B01fg9ruPi6OEBVJ5YFIO6Ldl
         cyewfAdEMjVAwoRrNYXNvTeprfwbeLFBhHqfeJWdREVb6ow2VEXTrjfk/6VeSRadMLAN
         V5QM3p5wIyLMJA24xcnkoPzYY5hiGqHRwUszK1GqGsXHe80n40BCIXj/RFgyCDRumpXU
         mHSw==
X-Gm-Message-State: AOAM530RPdY4VMdKmUw9fXi+Wqa/lahrQ8C3U5a7QlNOXB11P38c8DMu
        suwpkJQWcObEW8i4ltZjjh2ZmXd8naHwKFYxsuqnvtyQ4yROJ3aW
X-Google-Smtp-Source: ABdhPJxejV2Q/RwXGuc6ld8Kw32Dao4+MY6tZh+Lp+GFIxQipjF2dDU8AtKG3UNB2IGwIczVHU1z5Cnk3Tkg6ZIFh+s=
X-Received: by 2002:a1c:5581:: with SMTP id j123mr3593326wmb.11.1598238144977;
 Sun, 23 Aug 2020 20:02:24 -0700 (PDT)
MIME-Version: 1.0
References: <bdJVxLiFr_PyQSXRUbZJfFW_jAjsGgoMetqPHJMbg-hdy54Xt_ZHhRetmnJ6cJ99eBlcX76wy-AvWwV715c3YndkxneSlod11P1hlaADx0s=@protonmail.com>
 <20200823153746.GB1093@savella.carfax.org.uk> <251eb1e3-0fcd-eb22-72b9-8ab2f2a5e962@gmail.com>
 <uE-fvxC5rW1snQPXRetWASSP8a8cJVSTiDa1WNLmtVANT-M_cd6NUZxUlUtLBID2-EBEEJjP0yK7-Knt9-vjWob1dU6H9FE2Dhg0Y1XFOx4=@protonmail.com>
 <db0c267c-5b8f-067b-673c-8f59002ee48e@gmail.com> <3xjSaoCYmgmmVfKzqhR5ooUYdWPlI4R8fjh_4E0UuVCYRP9lPzoPszrseqXvxd6pAZY4xdmIBRuX_KLcn5U19G3VwVlK59FydVvDGulRvKY=@protonmail.com>
In-Reply-To: <3xjSaoCYmgmmVfKzqhR5ooUYdWPlI4R8fjh_4E0UuVCYRP9lPzoPszrseqXvxd6pAZY4xdmIBRuX_KLcn5U19G3VwVlK59FydVvDGulRvKY=@protonmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sun, 23 Aug 2020 21:01:43 -0600
Message-ID: <CAJCQCtTyXW1DUMd8gr+LFxz23ALUh6y_4=zvDhdGU05-NxSo_Q@mail.gmail.com>
Subject: Re: [Help] Can't login to my systemd-homed user account due to
 fallocate failure
To:     Andrii Zymohliad <azymohliad@protonmail.com>
Cc:     Andrei Borzenkov <arvidjaar@gmail.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Aug 23, 2020 at 12:49 PM Andrii Zymohliad
<azymohliad@protonmail.com> wrote:
>
> > Output of "btrfs fi us /" before and after fallocate would probably give
> > more information. Also "btrfs sub li /" and "btrfs qgroup show -re /"
> > would be interesting. And "btrfs fi du /home/azymohliad.home".
>
> Collected the outputs of all those commands here (in order of execution): https://gitlab.com/-/snippets/2007189
>
[pasted from above snippets url]
>># btrfs fi du /home/azymohliad.home
>>
>>    Total   Exclusive  Set shared  Filename
>>    256.64GiB   234.46GiB    22.18GiB  /home/azymohliad.home

When you manually mount this luks file, what do you get for 'btrfs fi
us /home/azymohliad' ?

Because if that file system is 403G, and sd-homed is trying to
fallocate a 256G file to be 403G, that's +147. And also in your
snippets from '/' btfs fi us

>>Free (estimated): 176.17GiB (min: 176.17GiB)

The fallocate should work. Has this home file been snapshot or reflink
copied or deduped?

filefrag -v /home/azymohliad.home | grep shared

Here's the thing. /home/azymohliad.home, the file, should be the same
size as the Btrfs on that file. Unless it's been subject to discards,
and is thus sparse already for some reason.

Is it possible the file is being trimmed then fallocated then trimmed
then fallocated? This could be new behavior in sd-246.

-- 
Chris Murphy
