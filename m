Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-02.prod.phx3.secureserver.net ([184.168.200.140]:58982
        "EHLO p3nlsmtpcp01-02.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725931AbeIGIhf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 04:37:35 -0400
Date: Fri, 7 Sep 2018 09:27:28 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: dduper - Offline btrfs deduplication tool
Message-ID: <20180907035728.GA7717@giis.co.in>
References: <20180824043139.GA8263@giis.co.in>
 <CAGqmi74eMiHe7HK_oueaj0JZmy1Kp1NoOCrU0yheEE8MjngLKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGqmi74eMiHe7HK_oueaj0JZmy1Kp1NoOCrU0yheEE8MjngLKA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> 
> One question:
> Why not ioctl_fideduperange?
> i.e. you kill most of benefits from that ioctl - atomicity.
> 
I plan to add fideduperange as an option too. User can
choose between fideduperange and ficlonerange call.

If I'm not wrong, with fideduperange, kernel performs
comparsion check before dedupe. And it will increase
time to dedupe files.

I believe the risk involved with ficlonerange is  minimized 
by having a backup file(reflinked). We can revert to older 
original file, if we encounter some problems.

> 
> -- 
> Have a nice day,
> Timofey.

Cheers.
Lakshmipathi.G
