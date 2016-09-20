Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35875 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754694AbcITRyi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 13:54:38 -0400
Received: by mail-oi0-f66.google.com with SMTP id i193so2003676oib.3
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Sep 2016 10:54:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b880821f-bfb5-5265-53a4-213b22487ddb@gmail.com>
References: <1634818f-ff1d-722c-6d73-747ed7203a13@gmail.com>
 <CAJCQCtQHBkx8kjcAdSbmgYcHCo_w3VPj8jvgby3cE-S6rLAPdw@mail.gmail.com>
 <ecac8c64-8ed4-7c8d-29ad-5b3687981a33@gmail.com> <CAJCQCtSupa8LT+RK3=w3t7+T_nDcgUzzjSdfEi16DpiQxbm0hQ@mail.gmail.com>
 <760be1b7-79b2-a25d-7c60-04ceac1b6e40@gmail.com> <CAJCQCtR2t+3w6ovo88L0_2GqnVWveK5DNJ-vWdw18y+Sng4chQ@mail.gmail.com>
 <3460a1ac-7e66-cf6f-b229-06a0825401a5@gmail.com> <b880821f-bfb5-5265-53a4-213b22487ddb@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 20 Sep 2016 11:54:37 -0600
Message-ID: <CAJCQCtRYpvnGurLSbxu2N0ELuvVKrM5w=jBkAneecaEog213dQ@mail.gmail.com>
Subject: Re: multi-device btrfs with single data mode and disk failure
To: Alexandre Poux <pums974@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 20, 2016 at 11:03 AM, Alexandre Poux <pums974@gmail.com> wrote:

> If I wanted to try to edit my partitions with an hex editor, where would
> I find infos on how to do that ?
> I really don't want to go this way, but if this is relatively simple, it
> may be worth to try.

Simple is relative. First you'd need
https://btrfs.wiki.kernel.org/index.php/On-disk_Format to get some
understanding of where things are to edit, and then btrfs-map-logical
to convert btrfs logical addresses to physical device and sector to
know what to edit.

I'd call it distinctly non-trivial and very tedious.

-- 
Chris Murphy
