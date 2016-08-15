Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:35771 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbcHOXY2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Aug 2016 19:24:28 -0400
Received: by mail-oi0-f45.google.com with SMTP id 4so78806471oih.2
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Aug 2016 16:24:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKdnfRJeOXHmrumDkfxLTf-nU=KwZ0f7ybET-3o7kwwJDOZ2aw@mail.gmail.com>
References: <1471023419.16857.9.camel@gmail.com> <CAJCQCtSwHCkW_nUNp4-R=S+ExZMk97i2qr6MwSuRU540c6xtfg@mail.gmail.com>
 <1471028417.16857.12.camel@gmail.com> <CAJCQCtTrEqR=UNpHp7ApbdBkwRRT6U5tiSHcs2y4N-P_G5u=Fw@mail.gmail.com>
 <CAJCQCtS51syrzxvpZXGzS=Ge=rW1iEfZDj6VrVmON39ww-Hmdg@mail.gmail.com> <CAKdnfRJeOXHmrumDkfxLTf-nU=KwZ0f7ybET-3o7kwwJDOZ2aw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 15 Aug 2016 17:24:26 -0600
Message-ID: <CAJCQCtTrGTjOMaNNV7JKBybgbyn=_pYP=KvE1zc4AuPs=mo2=A@mail.gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: Ronan Chagas <ronisbr@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 15, 2016 at 5:12 PM, Ronan Chagas <ronisbr@gmail.com> wrote:
> Hi guys!
>
> It happened again. The computer was completely unusable. The only useful
> message I saw was this one:
>
> http://img.ctrlv.in/img/16/08/16/57b24b0bb2243.jpg
>
> Does it help?
>
> I decided to format and reinstall tomorrow. This is a production machine and
> I have to fix this ASAP.

Looks similar to this:
https://lkml.org/lkml/2016/3/28/230

Can you describe the workload happening at the time?


-- 
Chris Murphy
