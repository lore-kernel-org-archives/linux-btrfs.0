Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:35322 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755607AbdLTVLD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 16:11:03 -0500
Received: by mail-it0-f43.google.com with SMTP id f143so8443064itb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Dec 2017 13:11:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <09697eee-b6f6-eb02-1c0d-1d6f156985f9@applied-asynchrony.com>
References: <CAG+QAKXycv-a3G9QKts4V9RWtKxgRgTtSd6mkZP=Dagmi9Ebtg@mail.gmail.com>
 <CAG+QAKUbtQc0V0njpXoC_UZL5NF1BP+qoH6Zbh4KgEN_2EiOdw@mail.gmail.com>
 <83e041e2-a440-845f-df54-ecde29bd10dd@mendix.com> <CAG+QAKViZXY-NguA+=Dy=1pye1Da+sM2+epohnxyefT=BPwXxw@mail.gmail.com>
 <CAG+QAKWN1X9jVWZeZ8q4DNNxSCXLbYFtM-t=LjpFqeGLE8QgGg@mail.gmail.com>
 <CAJCQCtTD0sp_YZGv47m4sjUvuAeTuq_P5XaRfnZ=SjvGvhF+Nw@mail.gmail.com> <09697eee-b6f6-eb02-1c0d-1d6f156985f9@applied-asynchrony.com>
From: Rich Rauenzahn <rrauenza@gmail.com>
Date: Wed, 20 Dec 2017 13:11:02 -0800
Message-ID: <CAG+QAKVc_V5D=076JUmZf90_8O_9fC_nPaAhTU4DqoC5zvdFAA@mail.gmail.com>
Subject: Re: kernel hangs during balance
To: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I switched to the LT kernel because of this issue.  I was running
mainline and thought that LT would get me stability.  I can switch
back to LT while we RCA.

At the risk of changing two things, I could add that
(scsi_mod.use_blk_mq=n) to my boot and also switch back to ML.  I do
notice that disk IO is high at the time of the hang -- I've assumed it
is btrfs balance, but if I read the logs right, it may have finished
before the hang.  Adding more logging.

I've also put the kernel logs into a pastebin:  https://pastebin.com/80qRXA9c

...wish I could get the watchdog to force a dump/trace.  Will look at that, too.
