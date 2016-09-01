Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:35179 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751372AbcIAV05 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Sep 2016 17:26:57 -0400
Received: by mail-oi0-f41.google.com with SMTP id p186so100544406oia.2
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Sep 2016 14:26:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTSUsKjcxkSfRhfND2vSQHcEgpnuvEamUYDETAesN9CBA@mail.gmail.com>
References: <CAJCQCtT5YA9EMq1ZC-qeZcNLUeg1GocBm3nT2nZFEBigmV4BxQ@mail.gmail.com>
 <CAJCQCtQjX+0nAWRNPK2gYNoi8wvHxTMEzm6v84PZKXnTLxc50Q@mail.gmail.com>
 <CAJCQCtT0=gEwBerYXYnyueMk3JnmGZp71qBJFB5N4qR4ASF7cg@mail.gmail.com>
 <CAJCQCtRZNNTZ5ymH-X9Cq=h+_aaATym40W42BJ-xM5ECJOQnDg@mail.gmail.com>
 <CAJCQCtTo7nS7grh-9XWTKXX_h2pXPXCbLMRGmTfa=NzHq2Aa6g@mail.gmail.com>
 <CAJCQCtS374FCEqSx0qBdF1oa6=y48A4p0pMN0u456adQETyS_Q@mail.gmail.com>
 <SY3PR01MB13864A03DC2503EF7E0381A49EE20@SY3PR01MB1386.ausprd01.prod.outlook.com>
 <CAJCQCtTMrA=CutAMjXy+_CPqLGyfwCfYnpug1rAJuLQWv2rKDA@mail.gmail.com> <CAJCQCtTSUsKjcxkSfRhfND2vSQHcEgpnuvEamUYDETAesN9CBA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 1 Sep 2016 12:45:50 -0600
Message-ID: <CAJCQCtQ=b4twsTvD_oiabXguZo49kVLZyU-k9hYo0UP0ALz_kg@mail.gmail.com>
Subject: Re: btrfs-progs 4.7, check reports many "incorrect local backref
 count" messages
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 1, 2016 at 11:59 AM, Chris Murphy <lists@colorremedies.com> wrote:
> OK so I have a 2nd volume, which is only ever used to 'btrfs receive'
> from the 1st volume. The 2nd volume is never persistently mounted. But
> it too has bunches of these incorrect backref messages, where
> btrfs-progs 4.6.1 comes up clean. A 3rd volume, is only ever used to
> receive rsync from the 1st and it comes up clean with 4.6.1, and
> 4.7.1, i.e. no such incorrect backref messages.
>
> The 1st volume says:
> found 438074621952 bytes used err is 0
>
> So if "err is 0" then there should be nothing to fix.
>
> I'm going to btrfs check and btrfs-image the 1st volume to capture the
> current state, and then try a --repair and if it breaks the file
> system I'm probably going to go ballistic...

OK so I did a repair on the primary volume, it claim to fix a bunch of
stuff, without errors. It mounts fine afterward, just like it did
before repair. And a subsequent check still finds all kinds of backref
problems that were in fact not fixed even though repair claimed to fix
them. But it doesn't crash at least.

I'll file a bug on the Ux of this, which is pretty bad, aside from the
fact it appears to not repair what it claims to repair.

Example from repair:

adding new data backref on 16913485824 root 659 owner 143234 offset 0 found 1

and from the after check
Backref 16913485824 root 659 owner 143234 offset 0 num_refs 0 not
found in extent tree
Incorrect local backref count on 16913485824 root 659 owner 143234
offset 0 found 1 wanted 0 back 0x55e44e85ccd0
Incorrect local backref count on 16913485824 root 659 owner 143234
offset 0 found 0 wanted 1 back 0x55e44eb83910
Backref disk bytenr does not match extent record, bytenr=16913485824,
ref bytenr=79553
Backref bytes do not match extent backref, bytenr=16913485824, ref
bytes=7577600, backref bytes=4096
Backref 16913485824 root 659 owner 143233 offset 0 num_refs 0 not
found in extent tree

Which is identical to what's found in the before check.




-- 
Chris Murphy
