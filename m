Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:34764 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750974AbcIAXxi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Sep 2016 19:53:38 -0400
Received: by mail-oi0-f51.google.com with SMTP id m11so13875698oif.1
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Sep 2016 16:53:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ=b4twsTvD_oiabXguZo49kVLZyU-k9hYo0UP0ALz_kg@mail.gmail.com>
References: <CAJCQCtT5YA9EMq1ZC-qeZcNLUeg1GocBm3nT2nZFEBigmV4BxQ@mail.gmail.com>
 <CAJCQCtQjX+0nAWRNPK2gYNoi8wvHxTMEzm6v84PZKXnTLxc50Q@mail.gmail.com>
 <CAJCQCtT0=gEwBerYXYnyueMk3JnmGZp71qBJFB5N4qR4ASF7cg@mail.gmail.com>
 <CAJCQCtRZNNTZ5ymH-X9Cq=h+_aaATym40W42BJ-xM5ECJOQnDg@mail.gmail.com>
 <CAJCQCtTo7nS7grh-9XWTKXX_h2pXPXCbLMRGmTfa=NzHq2Aa6g@mail.gmail.com>
 <CAJCQCtS374FCEqSx0qBdF1oa6=y48A4p0pMN0u456adQETyS_Q@mail.gmail.com>
 <SY3PR01MB13864A03DC2503EF7E0381A49EE20@SY3PR01MB1386.ausprd01.prod.outlook.com>
 <CAJCQCtTMrA=CutAMjXy+_CPqLGyfwCfYnpug1rAJuLQWv2rKDA@mail.gmail.com>
 <CAJCQCtTSUsKjcxkSfRhfND2vSQHcEgpnuvEamUYDETAesN9CBA@mail.gmail.com> <CAJCQCtQ=b4twsTvD_oiabXguZo49kVLZyU-k9hYo0UP0ALz_kg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 1 Sep 2016 17:53:35 -0600
Message-ID: <CAJCQCtRvis1g=Z1NXBhAeiJFZ=+r9K6d9c+mji76yecTodmqbA@mail.gmail.com>
Subject: Re: btrfs-progs 4.7, check reports many "incorrect local backref
 count" messages
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OK I filed a bug:

progs 4.7.x, numerous incorrect backrefs are not fixed with --repair
https://bugzilla.kernel.org/show_bug.cgi?id=155791
