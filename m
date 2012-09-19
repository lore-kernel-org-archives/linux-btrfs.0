Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61169 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab2ISL2e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Sep 2012 07:28:34 -0400
Received: by pbbrr13 with SMTP id rr13so2245901pbb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 04:28:33 -0700 (PDT)
Message-ID: <5059AC5E.1030003@gmail.com>
Date: Wed, 19 Sep 2012 19:28:30 +0800
From: ching <lsching17@gmail.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: enquiry about autodefrag option
References: <50570652.4060200@gmail.com>
In-Reply-To: <50570652.4060200@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

can anybody helps?

On 09/17/2012 07:15 PM, ching wrote:
> I am testing btrfs for long-term storage and backup, and i would like
> to know more about "autodefrag" option:
>
> 1. Will "autodefrag" option benefit ssd?
>
>     My understanding is:
>
>        autodrag -> number of extent decrease -> metadata decrease -> a
> "healthier" filesystem in the long run
>
>    (P.S. I am aware that autodefrag will introduce extra write I/O)
>
> 2. AFAIK, "autodefrag" detects small random writes into files and
> queues them up for an automatic defrag process, so the filesystem will
> defragment itself while it's used.
>
>     If the system reboot/crash/remount-ro, will the autodefrag process
> continue after resume?
>
>

