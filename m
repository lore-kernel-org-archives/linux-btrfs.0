Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:40668 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbaHDLE0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Aug 2014 07:04:26 -0400
Received: by mail-vc0-f171.google.com with SMTP id hq11so10760954vcb.16
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Aug 2014 04:04:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140804102206.GA31950@carfax.org.uk>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com>
	<53DEE40C.6020403@cn.fujitsu.com>
	<CAFChkqttiPWQ+FquT2FfKE54US7vkeEyQsUT8fuD1BWNhS3k=w@mail.gmail.com>
	<17833067.mzxAL4oqZq@quad>
	<CAFChkqs3LOM4HmDzpXgs6YTeoXvyNPbsNWCPf74=_MnPneJ+HQ@mail.gmail.com>
	<20140804102206.GA31950@carfax.org.uk>
Date: Mon, 4 Aug 2014 13:04:25 +0200
Message-ID: <CAFvQSYRDz1EW4CiKbRNEp0HKhciHPM+b_63CrOOko+D6aYPnvw@mail.gmail.com>
Subject: Re: ENOSPC with mkdir and rename
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Hugo,

>    On the 3.15+ kernels, the block reserve is split out of metadata
> and reported separately. This helps with the following process:

Thanks a lot for pointing this out, I hadn't noticed this change until now.

One thing I didn't find any information about is the overhead
introduced by mixied-mode.
It would be great if you could explain it in a few sentences.

Thank you in advance, Clemens
