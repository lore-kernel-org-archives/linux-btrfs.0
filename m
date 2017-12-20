Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:49410 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755557AbdLTT6Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 14:58:16 -0500
Subject: Re: kernel hangs during balance
To: Chris Murphy <lists@colorremedies.com>,
        Rich Rauenzahn <rrauenza@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
References: <CAG+QAKXycv-a3G9QKts4V9RWtKxgRgTtSd6mkZP=Dagmi9Ebtg@mail.gmail.com>
 <CAG+QAKUbtQc0V0njpXoC_UZL5NF1BP+qoH6Zbh4KgEN_2EiOdw@mail.gmail.com>
 <83e041e2-a440-845f-df54-ecde29bd10dd@mendix.com>
 <CAG+QAKViZXY-NguA+=Dy=1pye1Da+sM2+epohnxyefT=BPwXxw@mail.gmail.com>
 <CAG+QAKWN1X9jVWZeZ8q4DNNxSCXLbYFtM-t=LjpFqeGLE8QgGg@mail.gmail.com>
 <CAJCQCtTD0sp_YZGv47m4sjUvuAeTuq_P5XaRfnZ=SjvGvhF+Nw@mail.gmail.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <09697eee-b6f6-eb02-1c0d-1d6f156985f9@applied-asynchrony.com>
Date: Wed, 20 Dec 2017 20:58:14 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTD0sp_YZGv47m4sjUvuAeTuq_P5XaRfnZ=SjvGvhF+Nw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/20/17 20:02, Chris Murphy wrote:
> I don't know if it's the sending MUA or the list server, but the line
> wrapping makes this much harder to follow. I suggest putting it in a
> text file and attaching the text file. It's definitely not on the
> receiving side, I see it here also:
> https://www.spinics.net/lists/linux-btrfs/msg72872.html

You can see enough to suggest that blk-mq is hanging, which is
"unsurprising" (being kind here) with such an old kernel.
Rich, build your kernel with CONFIG_SCSI_MQ_DEFAULT=n or
boot with scsi_mod.use_blk_mq=n as kernel prarameter.

-h
