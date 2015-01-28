Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:35773 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761699AbbA2CYG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Jan 2015 21:24:06 -0500
Received: by mail-oi0-f51.google.com with SMTP id x69so22419768oia.10
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Jan 2015 18:24:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150128034636.GA13452@hungrycats.org>
References: <CANXojczR_jeVU0XNQGzatmDaaCv7CdWanis8NiSe2F75cuz_9g@mail.gmail.com>
	<CAJCQCtRyv+m0kxBL6LW=xZv=sUzf2to4R6xPsxy6CkihHmrV0A@mail.gmail.com>
	<CANXojcxps7KPRC2dbfU7hFvUDzkK2CmT4EroDrO6HO56h7j3cg@mail.gmail.com>
	<20150128034636.GA13452@hungrycats.org>
Date: Wed, 28 Jan 2015 11:28:31 +0100
Message-ID: <CANXojcxMSwMDwY2AkzVnRC-8msm1=ssDg93UOP-PjvAJUUnbSg@mail.gmail.com>
Subject: Re: Get the diff from a file in two snapshots.
From: Stef Bon <stefbon@gmail.com>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Aha,

thanks a lot Zygo for the hint about fiemap. I will try this, it could
indeed save an awful lot of I/O.

Stef Bon
