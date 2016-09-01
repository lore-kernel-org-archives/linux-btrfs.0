Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:32928 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751917AbcIAWRA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Sep 2016 18:17:00 -0400
Received: by mail-oi0-f54.google.com with SMTP id c15so137501758oig.0
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Sep 2016 15:17:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTMrA=CutAMjXy+_CPqLGyfwCfYnpug1rAJuLQWv2rKDA@mail.gmail.com>
References: <CAJCQCtT5YA9EMq1ZC-qeZcNLUeg1GocBm3nT2nZFEBigmV4BxQ@mail.gmail.com>
 <CAJCQCtQjX+0nAWRNPK2gYNoi8wvHxTMEzm6v84PZKXnTLxc50Q@mail.gmail.com>
 <CAJCQCtT0=gEwBerYXYnyueMk3JnmGZp71qBJFB5N4qR4ASF7cg@mail.gmail.com>
 <CAJCQCtRZNNTZ5ymH-X9Cq=h+_aaATym40W42BJ-xM5ECJOQnDg@mail.gmail.com>
 <CAJCQCtTo7nS7grh-9XWTKXX_h2pXPXCbLMRGmTfa=NzHq2Aa6g@mail.gmail.com>
 <CAJCQCtS374FCEqSx0qBdF1oa6=y48A4p0pMN0u456adQETyS_Q@mail.gmail.com>
 <SY3PR01MB13864A03DC2503EF7E0381A49EE20@SY3PR01MB1386.ausprd01.prod.outlook.com>
 <CAJCQCtTMrA=CutAMjXy+_CPqLGyfwCfYnpug1rAJuLQWv2rKDA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 1 Sep 2016 11:59:09 -0600
Message-ID: <CAJCQCtTSUsKjcxkSfRhfND2vSQHcEgpnuvEamUYDETAesN9CBA@mail.gmail.com>
Subject: Re: btrfs-progs 4.7, check reports many "incorrect local backref
 count" messages
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OK so I have a 2nd volume, which is only ever used to 'btrfs receive'
from the 1st volume. The 2nd volume is never persistently mounted. But
it too has bunches of these incorrect backref messages, where
btrfs-progs 4.6.1 comes up clean. A 3rd volume, is only ever used to
receive rsync from the 1st and it comes up clean with 4.6.1, and
4.7.1, i.e. no such incorrect backref messages.

The 1st volume says:
found 438074621952 bytes used err is 0

So if "err is 0" then there should be nothing to fix.

I'm going to btrfs check and btrfs-image the 1st volume to capture the
current state, and then try a --repair and if it breaks the file
system I'm probably going to go ballistic...


---
Chris Murphy
