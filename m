Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:34947 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932719AbcHaV7H (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Aug 2016 17:59:07 -0400
Received: by mail-oi0-f54.google.com with SMTP id p186so55559721oia.2
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Aug 2016 14:59:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTo7nS7grh-9XWTKXX_h2pXPXCbLMRGmTfa=NzHq2Aa6g@mail.gmail.com>
References: <CAJCQCtT5YA9EMq1ZC-qeZcNLUeg1GocBm3nT2nZFEBigmV4BxQ@mail.gmail.com>
 <CAJCQCtQjX+0nAWRNPK2gYNoi8wvHxTMEzm6v84PZKXnTLxc50Q@mail.gmail.com>
 <CAJCQCtT0=gEwBerYXYnyueMk3JnmGZp71qBJFB5N4qR4ASF7cg@mail.gmail.com>
 <CAJCQCtRZNNTZ5ymH-X9Cq=h+_aaATym40W42BJ-xM5ECJOQnDg@mail.gmail.com> <CAJCQCtTo7nS7grh-9XWTKXX_h2pXPXCbLMRGmTfa=NzHq2Aa6g@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 31 Aug 2016 15:59:02 -0600
Message-ID: <CAJCQCtS374FCEqSx0qBdF1oa6=y48A4p0pMN0u456adQETyS_Q@mail.gmail.com>
Subject: Re: btrfs-progs 4.7, check reports many "incorrect local backref
 count" messages
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is still happening with btrfs-progs 4.7.1 and there is zero
information in the long result what to do about the problem, and
whether it's sane to try have --repair fix it, let alone what the
original cause of the problem was.



-- 
Chris Murphy
