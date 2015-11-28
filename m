Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:33528 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbbK1SeW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Nov 2015 13:34:22 -0500
Received: by iouu10 with SMTP id u10so140816718iou.0
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Nov 2015 10:34:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1448684040.6837.18.camel@scientia.net>
References: <1448643790.11377.39.camel@scientia.net>
	<CAPmG0jZDHkvFq8_f__2p2net3Qu_rfvxBeyRHNZPZ3tekbhMMQ@mail.gmail.com>
	<1448684040.6837.18.camel@scientia.net>
Date: Sat, 28 Nov 2015 11:34:21 -0700
Message-ID: <CAJCQCtQZ0-q5m=DM5nsrveU-W=Bc-L75m+Oyx6XsYHs2pJwzCg@mail.gmail.com>
Subject: Re: slowness when cp respectively send/receiving on top of dm-crypt
From: Chris Murphy <lists@colorremedies.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 27, 2015 at 9:14 PM, Christoph Anton Mitterer
<calestyo@scientia.net> wrote:

> - Bust most importantly,... if the reason was SMR, why should always
> when no IO happens dmcrypt_write be at basically full CPU.

It sounds to me like maybe LUKS is configured to use an encryption
algorithm that isn't subject to CPU optimized support, e.g. aes-xts on
my laptop gets 1600MiB/s where serpent-cbc gets only 68MiB/s and pegs
the CPU. This is reported by 'cryptsetup benchmark'

-- 
Chris Murphy
