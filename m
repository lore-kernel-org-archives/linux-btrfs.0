Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:59686 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab3J0Vt5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Oct 2013 17:49:57 -0400
Received: by mail-pa0-f43.google.com with SMTP id hz1so6296976pad.2
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Oct 2013 14:49:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <526D86DE.6070603@swiftspirit.co.za>
References: <CAOeUAF_msDRoi2CDnAhwqC+=_oqNqH0=94+N9qjXpi4m4ChVLg@mail.gmail.com>
	<20131027201750.GG31029@carfax.org.uk>
	<CAOeUAF9FWCMwktn-nZR6wn+RiKHf9Qy_Yk7maqy0LzP8iQ6X6Q@mail.gmail.com>
	<526D86DE.6070603@swiftspirit.co.za>
Date: Mon, 28 Oct 2013 05:49:57 +0800
Message-ID: <CAOeUAF_Zc_PdF7BpNheV77xMNX5M3OvU823KDNGuve9OU8hYJg@mail.gmail.com>
Subject: Re: Total fs size does not match with the actual size of the setup
From: Lester B <b.lester011+btrfs@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

sudo btrfs fi df <mountpoint>

Data: total=5.62GB, used=4.96GB
System: total=32.00MB, used=4.00KB
Metadata: total=512.00MB, used=288.70MB
