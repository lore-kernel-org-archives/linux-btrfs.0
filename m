Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:38532 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbbKAQwh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Nov 2015 11:52:37 -0500
Received: by wicll6 with SMTP id ll6so36764488wic.1
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Nov 2015 08:52:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+LE0jwqCThaMEcouGhyMyA44za3kwfpzYOdkpBwc7UKjDAFgQ@mail.gmail.com>
References: <CA+LE0jzBX8kN1NmQ-+8zUpxrB79oMEmpmzUGABYfeA_tX47jBA@mail.gmail.com>
	<CA+LE0jyX4mDLm4kwfu-wgXWwhNs2pL0Yqh9KKr_-BYiJUany4w@mail.gmail.com>
	<CA+LE0jwqCThaMEcouGhyMyA44za3kwfpzYOdkpBwc7UKjDAFgQ@mail.gmail.com>
Date: Sun, 1 Nov 2015 18:52:36 +0200
Message-ID: <CA+LE0jxF7HcYf64NinN4hrmMh6o4Wih_cNsi6WsEJdnRvrObaQ@mail.gmail.com>
Subject: Re: BTRFS raid 5/6 status
From: audio muze <audiomuze@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've looked into snap-raid and it seems well suited to my needs as
most of the data is static.  I'm planning on using it in conjunction
with mhddfs so all drives are seen as a single storage pool. Is there
then any benefit in using Btrfs as the underlying filesystem on each
of the drives?
