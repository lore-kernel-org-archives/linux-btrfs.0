Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:46442 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbaHDOMj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Aug 2014 10:12:39 -0400
Received: by mail-we0-f180.google.com with SMTP id w61so7823276wes.39
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Aug 2014 07:12:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53DF9293.2090508@gmail.com>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com>
 <53DEE40C.6020403@cn.fujitsu.com> <CAFChkqttiPWQ+FquT2FfKE54US7vkeEyQsUT8fuD1BWNhS3k=w@mail.gmail.com>
 <17833067.mzxAL4oqZq@quad> <CAFChkqs3LOM4HmDzpXgs6YTeoXvyNPbsNWCPf74=_MnPneJ+HQ@mail.gmail.com>
 <20140804102206.GA31950@carfax.org.uk> <CAFvQSYRDz1EW4CiKbRNEp0HKhciHPM+b_63CrOOko+D6aYPnvw@mail.gmail.com>
 <20140804113231.GD31950@carfax.org.uk> <CAFChkqv3N27jWxL=URgkZ1G86BFBo+-Cmg9emOO3G80OKY2n4g@mail.gmail.com>
 <53DF9293.2090508@gmail.com>
From: Peter Waller <peter@scraperwiki.com>
Date: Mon, 4 Aug 2014 15:11:56 +0100
Message-ID: <CAFChkqswRLPMBzL3MXcbOReVq0ZCySQ_Bk3uzoChCzhoUWrtjA@mail.gmail.com>
Subject: Re: ENOSPC with mkdir and rename
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4 August 2014 15:02, Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:
> I really disagree with the statement that adding more storage is
> difficult or expensive, all you need to do is plug in a 2G USB flash
> drive, or allocate a ramdisk, and add the device to the filesystem only
> long enough to do a full balance.

What if the machine is a server in a datacenter you don't have
physical access to and the problem is an emergency preventing your
users from being able to get work done?

What happens if you use a RAM disk and there is a power failure?

Thanks for the other explanations and advice also,

- Peter
