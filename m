Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33873 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752930AbcHVVC7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Aug 2016 17:02:59 -0400
Received: by mail-oi0-f66.google.com with SMTP id t127so984053oie.1
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Aug 2016 14:02:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1471898393.23345.0.camel@gmail.com>
References: <1471023419.16857.9.camel@gmail.com> <CAJCQCtSwHCkW_nUNp4-R=S+ExZMk97i2qr6MwSuRU540c6xtfg@mail.gmail.com>
 <1471028417.16857.12.camel@gmail.com> <CAJCQCtTrEqR=UNpHp7ApbdBkwRRT6U5tiSHcs2y4N-P_G5u=Fw@mail.gmail.com>
 <CAJCQCtS51syrzxvpZXGzS=Ge=rW1iEfZDj6VrVmON39ww-Hmdg@mail.gmail.com>
 <CAKdnfRJeOXHmrumDkfxLTf-nU=KwZ0f7ybET-3o7kwwJDOZ2aw@mail.gmail.com>
 <CAJCQCtTrGTjOMaNNV7JKBybgbyn=_pYP=KvE1zc4AuPs=mo2=A@mail.gmail.com> <1471898393.23345.0.camel@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 22 Aug 2016 14:49:42 -0600
Message-ID: <CAJCQCtS7A+eWhg+agC3PJQn0g9Bgchb6C6LPt=NH1OF97xuhaw@mail.gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 22, 2016 at 2:39 PM, Ronan Arraes Jardim Chagas
<ronisbr@gmail.com> wrote:
> The same thing just happened again! And now it was also fixed
> automatically, but now I have:
>
> Metadata,DUP: Size:33.50GiB, Used:812.78MiB

This is really weird. I'm running 4.7.0 (Fedora) and I'm not
experiencing problems, let alone this. What is this kernel's
provenance? Is it a plain mainline 4.7.0 that you built? I'm not
really sure what to recommend except maybe going back to 4.5.7 or
4.6.7 as it's a production machine. Heck even 4.4.19 is OK for me in
this regard.

-- 
Chris Murphy
