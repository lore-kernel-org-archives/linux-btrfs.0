Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:42847 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755910AbdLTTCD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 14:02:03 -0500
Received: by mail-oi0-f45.google.com with SMTP id o64so15300468oia.9
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Dec 2017 11:02:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAG+QAKWN1X9jVWZeZ8q4DNNxSCXLbYFtM-t=LjpFqeGLE8QgGg@mail.gmail.com>
References: <CAG+QAKXycv-a3G9QKts4V9RWtKxgRgTtSd6mkZP=Dagmi9Ebtg@mail.gmail.com>
 <CAG+QAKUbtQc0V0njpXoC_UZL5NF1BP+qoH6Zbh4KgEN_2EiOdw@mail.gmail.com>
 <83e041e2-a440-845f-df54-ecde29bd10dd@mendix.com> <CAG+QAKViZXY-NguA+=Dy=1pye1Da+sM2+epohnxyefT=BPwXxw@mail.gmail.com>
 <CAG+QAKWN1X9jVWZeZ8q4DNNxSCXLbYFtM-t=LjpFqeGLE8QgGg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 20 Dec 2017 12:02:02 -0700
Message-ID: <CAJCQCtTD0sp_YZGv47m4sjUvuAeTuq_P5XaRfnZ=SjvGvhF+Nw@mail.gmail.com>
Subject: Re: kernel hangs during balance
To: Rich Rauenzahn <rrauenza@gmail.com>
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I don't know if it's the sending MUA or the list server, but the line
wrapping makes this much harder to follow. I suggest putting it in a
text file and attaching the text file. It's definitely not on the
receiving side, I see it here also:
https://www.spinics.net/lists/linux-btrfs/msg72872.html

Also anytime you get a hang, it's best to issue sysrq+w which dumps
extra information into kernel messages that the developers sometimes
find useful.


Chris Murphy
