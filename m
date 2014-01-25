Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:34466 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaAYNdK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jan 2014 08:33:10 -0500
Received: by mail-vc0-f171.google.com with SMTP id le5so2454608vcb.2
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Jan 2014 05:33:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <7uuara-hf5.ln1@hurikhan77.spdns.de>
References: <52E2B73E.1050903@gmail.com>
	<7uuara-hf5.ln1@hurikhan77.spdns.de>
Date: Sat, 25 Jan 2014 15:33:08 +0200
Message-ID: <CAK5rZE6bF+z6Y9=X7SxtRPHE=1nNRPMmASC0VU8u90HQ_LbzVA@mail.gmail.com>
Subject: Re: Options for SSD - autodefrag etc?
From: Imran Geriskovan <imran.geriskovan@gmail.com>
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Every write on a SSD block reduces its data retension capability.

No concrete figures but it is assumed to be
- 10 years for new devices
- 1 year at rated usage. (There are much lower figures around)

Hence, I would not trade retension time and wear for
autodefrag with no/minor benefits on SSD. (which means
at least +2x write amplification on fragments)

On hard disks, we've experienced temporary freezes
(about 10secs to 3mins) during background autodefrag.

Regards,
Imran
