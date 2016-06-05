Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:35621 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbcFEKpf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jun 2016 06:45:35 -0400
Received: by mail-wm0-f53.google.com with SMTP id c74so7137322wme.0
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Jun 2016 03:45:34 -0700 (PDT)
Subject: Re: Recommended why to use btrfs for production?
To: Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
References: <CAGQ70Yc=HHxJspMCKFBpEURRu=53pZW3k3rVDVO3QPGP_b9Tkw@mail.gmail.com>
 <aeade1fe-825c-6fc2-7f6d-85f4c5400b38@gmail.com>
 <CAJCQCtQ4i0PWisxi708EmrTuPHH7hNEkKfY28GjTG2s4Sk3DYQ@mail.gmail.com>
Cc: Martin <rc6encrypted@gmail.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Mladen Milinkovic <maxrd2@smoothware.net>
Message-ID: <73123a36-6502-d735-c813-fce43b620e5a@smoothware.net>
Date: Sun, 5 Jun 2016 12:45:31 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ4i0PWisxi708EmrTuPHH7hNEkKfY28GjTG2s4Sk3DYQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/03/2016 04:05 PM, Chris Murphy wrote:
> Make certain the kernel command timer value is greater than the driver
> error recovery timeout. The former is found in sysfs, per block
> device, the latter can be get and set with smartctl. Wrong
> configuration is common (it's actually the default) when using
> consumer drives, and inevitably leads to problems, even the loss of
> the entire array. It really is a terrible default.

Since it's first time i've heard of this I did some googling.

Here's some nice article about these timeouts:
http://strugglers.net/~andy/blog/2015/11/09/linux-software-raid-and-drive-timeouts/comment-page-1/

And some udev rules that should apply this automatically:
http://comments.gmane.org/gmane.linux.raid/48193

Cheers

-- 
Mladen Milinkovic
GPG: EF9D9B26

