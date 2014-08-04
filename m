Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:61106 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbaHDJWs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Aug 2014 05:22:48 -0400
Received: by mail-vc0-f171.google.com with SMTP id hq11so10615268vcb.16
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Aug 2014 02:22:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFChkqttiPWQ+FquT2FfKE54US7vkeEyQsUT8fuD1BWNhS3k=w@mail.gmail.com>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com>
	<53DEE40C.6020403@cn.fujitsu.com>
	<CAFChkqttiPWQ+FquT2FfKE54US7vkeEyQsUT8fuD1BWNhS3k=w@mail.gmail.com>
Date: Mon, 4 Aug 2014 11:22:47 +0200
Message-ID: <CAFvQSYTYokjT3=-QA_5bKYjmE+Y1+0Wb4gMJrERWJOkDxDakvg@mail.gmail.com>
Subject: Re: ENOSPC with mkdir and rename
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Peter,

> All of this is *very* surprising. I'm not new to BTRFS, I've been
> using it on my own machines for multiple years. I didn't realise there
> was an un-holstered footgun on my lap at this point. How can it be
> made clear how to avoid the ENOSPC problem to myself and other
> sysadmins? Or preferably not exist as a problem?

I've also found the fixed metadata/data split to be an uncomfortable
implementation detail, and some more flexible approach would be very
welcome from my side.

So far I've used BTRFS' mixed mode mentioned in the mkfs.btrfs man page:

> -M|--mixedMix data and metadata chunks together for more efficient space utilization.
> This feature incurs a performance penalty in larger filesystems.
> It is recommended for use with filesystems of 1 GiB or smaller.

However I didn't find any information on how large the mentioned
overhead is, or where it originates from.

Best regards, Clemens
