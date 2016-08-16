Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:34535 "EHLO
	mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbcHPR4r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Aug 2016 13:56:47 -0400
Received: by mail-qt0-f174.google.com with SMTP id u25so38858056qtb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Aug 2016 10:56:05 -0700 (PDT)
Message-ID: <1471369777.12705.1.camel@gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
From: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Tue, 16 Aug 2016 14:49:37 -0300
In-Reply-To: <CAJCQCtTrGTjOMaNNV7JKBybgbyn=_pYP=KvE1zc4AuPs=mo2=A@mail.gmail.com>
References: <1471023419.16857.9.camel@gmail.com>
	 <CAJCQCtSwHCkW_nUNp4-R=S+ExZMk97i2qr6MwSuRU540c6xtfg@mail.gmail.com>
	 <1471028417.16857.12.camel@gmail.com>
	 <CAJCQCtTrEqR=UNpHp7ApbdBkwRRT6U5tiSHcs2y4N-P_G5u=Fw@mail.gmail.com>
	 <CAJCQCtS51syrzxvpZXGzS=Ge=rW1iEfZDj6VrVmON39ww-Hmdg@mail.gmail.com>
	 <CAKdnfRJeOXHmrumDkfxLTf-nU=KwZ0f7ybET-3o7kwwJDOZ2aw@mail.gmail.com>
	 <CAJCQCtTrGTjOMaNNV7JKBybgbyn=_pYP=KvE1zc4AuPs=mo2=A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Em Seg, 2016-08-15 às 17:24 -0600, Chris Murphy escreveu:
> On Mon, Aug 15, 2016 at 5:12 PM, Ronan Chagas <ronisbr@gmail.com>
> wrote:
> > 
> > Hi guys!
> > 
> > It happened again. The computer was completely unusable. The only
> > useful
> > message I saw was this one:
> > 
> > http://img.ctrlv.in/img/16/08/16/57b24b0bb2243.jpg
> > 
> > Does it help?
> > 
> > I decided to format and reinstall tomorrow. This is a production
> > machine and
> > I have to fix this ASAP.
> 
> Looks similar to this:
> https://lkml.org/lkml/2016/3/28/230
> 
> Can you describe the workload happening at the time?

I was copying my /home using rsyinc when this happened. Unfortunately I
needed to format this machine because it is a production system. If I
see any problems related to that, I will report to this mailing list.

Regards,
Ronan Arraes
