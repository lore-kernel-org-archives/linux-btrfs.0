Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:33022 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbbEZTwc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 15:52:32 -0400
Received: by wgez8 with SMTP id z8so106761144wge.0
        for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2015 12:52:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQFyCEn3kdeYOrOyk_vqekNH_MiOyA=WSOxLCoQS6PV1w@mail.gmail.com>
References: <556457b8.e72b980a.ee08.ffffce60@mx.google.com> <CAJCQCtQFyCEn3kdeYOrOyk_vqekNH_MiOyA=WSOxLCoQS6PV1w@mail.gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Tue, 26 May 2015 22:51:49 +0300
Message-ID: <CAGqmi75OK8ofM7p0SqUsy8WhW3ZveQ_3NMtQCAchmHnUP7KoPg@mail.gmail.com>
Subject: Re: RAID1: system stability
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Oh, thanks for advice, i'll get and attach it.
i.e. as i understand behaviour like it, not expected, cool

2015-05-26 22:49 GMT+03:00 Chris Murphy <lists@colorremedies.com>:
> Without a complete dmesg it's hard to say what's going on. The call
> trace alone probably don't show the instigating factor so you may need
> to use remote ssh with journalctl -f, or use netconsole to
> continuously get kernel messages prior to the implosion.
>
> Chris Murphy



-- 
Have a nice day,
Timofey.
