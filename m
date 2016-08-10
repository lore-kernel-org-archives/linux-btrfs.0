Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:36507 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbcHJVVL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Aug 2016 17:21:11 -0400
Received: by mail-oi0-f45.google.com with SMTP id f189so76608186oig.3
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Aug 2016 14:21:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$d9b53$c31dc60$985cf806$b833643c@cox.net>
References: <CAGdWbB5k_HmN2b4zzrnYN+ExiqeP_9Eu9mVBCHEtgZNKHfTARA@mail.gmail.com>
 <pan$d9b53$c31dc60$985cf806$b833643c@cox.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 10 Aug 2016 15:21:09 -0600
Message-ID: <CAJCQCtTHH=q9cE-BHDYuDpUASQx4Rnzx_b3VR=v-3s_THf1f4w@mail.gmail.com>
Subject: Re: checksum error in metadata node - best way to move root fs to new drive?
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm using LUKS, aes xts-plain64, on six devices. One is using mixed-bg
single device. One is dsingle mdup. And then 2x2 mraid1 draid1. I've
had zero problems. The two computers these run on do have aesni
support. Aging wise, they're all at least a  year old. But I've been
using Btrfs on LUKS for much longer than that.


Chris Murphy
