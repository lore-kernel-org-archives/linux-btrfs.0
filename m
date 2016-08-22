Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:33021 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755855AbcHVVEV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Aug 2016 17:04:21 -0400
Received: by mail-qk0-f182.google.com with SMTP id z190so92139878qkc.0
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Aug 2016 14:04:21 -0700 (PDT)
Message-ID: <1471899855.14025.2.camel@gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
From: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Mon, 22 Aug 2016 18:04:15 -0300
In-Reply-To: <CAJCQCtS7A+eWhg+agC3PJQn0g9Bgchb6C6LPt=NH1OF97xuhaw@mail.gmail.com>
References: <1471023419.16857.9.camel@gmail.com>
         <CAJCQCtSwHCkW_nUNp4-R=S+ExZMk97i2qr6MwSuRU540c6xtfg@mail.gmail.com>
         <1471028417.16857.12.camel@gmail.com>
         <CAJCQCtTrEqR=UNpHp7ApbdBkwRRT6U5tiSHcs2y4N-P_G5u=Fw@mail.gmail.com>
         <CAJCQCtS51syrzxvpZXGzS=Ge=rW1iEfZDj6VrVmON39ww-Hmdg@mail.gmail.com>
         <CAKdnfRJeOXHmrumDkfxLTf-nU=KwZ0f7ybET-3o7kwwJDOZ2aw@mail.gmail.com>
         <CAJCQCtTrGTjOMaNNV7JKBybgbyn=_pYP=KvE1zc4AuPs=mo2=A@mail.gmail.com>
         <1471898393.23345.0.camel@gmail.com>
         <CAJCQCtS7A+eWhg+agC3PJQn0g9Bgchb6C6LPt=NH1OF97xuhaw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Em Seg, 2016-08-22 às 14:49 -0600, Chris Murphy escreveu:
> This is really weird. I'm running 4.7.0 (Fedora) and I'm not
> experiencing problems, let alone this. What is this kernel's
> provenance? Is it a plain mainline 4.7.0 that you built? I'm not
> really sure what to recommend except maybe going back to 4.5.7 or
> 4.6.7 as it's a production machine. Heck even 4.4.19 is OK for me in
> this regard.
> 

Well, I'm using the default openSUSE kernel here. And I have been seen
this errors for sometimes. When I reported it, I was using v4.6.1.
Hence, I think the version of btrfs-progs is not the problem.
