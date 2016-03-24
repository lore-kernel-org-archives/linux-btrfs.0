Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:38496 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbcCXXMm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 19:12:42 -0400
Received: by mail-ig0-f180.google.com with SMTP id ig19so2992219igb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Mar 2016 16:12:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC7HdqmM75xq+qrczEGrs5FXPn65VfKx6tKzqL7woNstQkTuOA@mail.gmail.com>
References: <CAC7HdqknOJAK+FcE53xO38G__gc42GR0GQW+chbGbDxXBt7HFA@mail.gmail.com>
	<CAJCQCtQ=_iE3m6P-jH1VjzycBXXRv5QZUS2SPNeH7ZJ_ukWM-A@mail.gmail.com>
	<CAC7HdqmzhHwJFgpDAjwF9gjL_+vEm7A8sBBsGwQEmTE_BGoeqQ@mail.gmail.com>
	<CAJCQCtTnGyMBwGwDowm7+4DFN89YtEJx=hmi_K4gpogx3gFanQ@mail.gmail.com>
	<CAC7HdqkBiH5Tx_Prj6R-W_PepTEA+N_+nKiqumHJS5kQ+s1p6A@mail.gmail.com>
	<CAJCQCtQtdXXJa0AJszkoB4KR36ph2LZZ7BftNv1Qk1ksqbbKvQ@mail.gmail.com>
	<CAC7HdqmM75xq+qrczEGrs5FXPn65VfKx6tKzqL7woNstQkTuOA@mail.gmail.com>
Date: Thu, 24 Mar 2016 17:12:41 -0600
Message-ID: <CAJCQCtS2oVSgbmtvSE+anz8x0q0H17LwUiixenn-N-nEhcH5CQ@mail.gmail.com>
Subject: Re: moving btrfs subvolumes to new disk
From: Chris Murphy <lists@colorremedies.com>
To: Ryan Erato <rerato@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 23, 2016 at 8:08 PM, Ryan Erato <rerato@gmail.com> wrote:
> Success! Using the same ISO you previously linked to, I ran 'btrfs
> check --repair', did another check which actually revealed many new
> issues, ran a repair again and after that successive checks showed no
> signs of other issues. I was able to successfully send my 'home'
> subvolume to the SSD and wow, huge difference with otherwise little
> effort.
>
> Thanks to you and everybody else for helping me resolve this issue.

Yay, good news!


-- 
Chris Murphy
