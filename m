Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:60748 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751723AbdLUG22 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Dec 2017 01:28:28 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eRuJD-0003aU-Ui
        for linux-btrfs@vger.kernel.org; Thu, 21 Dec 2017 07:26:23 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: kernel hangs during balance
Date: Thu, 21 Dec 2017 06:26:16 +0000 (UTC)
Message-ID: <pan$678dc$737b7f30$15572b76$e6022b@cox.net>
References: <CAG+QAKXycv-a3G9QKts4V9RWtKxgRgTtSd6mkZP=Dagmi9Ebtg@mail.gmail.com>
        <CAG+QAKUbtQc0V0njpXoC_UZL5NF1BP+qoH6Zbh4KgEN_2EiOdw@mail.gmail.com>
        <83e041e2-a440-845f-df54-ecde29bd10dd@mendix.com>
        <CAG+QAKViZXY-NguA+=Dy=1pye1Da+sM2+epohnxyefT=BPwXxw@mail.gmail.com>
        <CAG+QAKWN1X9jVWZeZ8q4DNNxSCXLbYFtM-t=LjpFqeGLE8QgGg@mail.gmail.com>
        <CAJCQCtTD0sp_YZGv47m4sjUvuAeTuq_P5XaRfnZ=SjvGvhF+Nw@mail.gmail.com>
        <09697eee-b6f6-eb02-1c0d-1d6f156985f9@applied-asynchrony.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Holger Hoffstätte posted on Wed, 20 Dec 2017 20:58:14 +0100 as excerpted:

> On 12/20/17 20:02, Chris Murphy wrote:
>> I don't know if it's the sending MUA or the list server, but the line
>> wrapping makes this much harder to follow. I suggest putting it in a
>> text file and attaching the text file. It's definitely not on the
>> receiving side, I see it here also:
>> https://www.spinics.net/lists/linux-btrfs/msg72872.html
> 
> You can see enough to suggest that blk-mq is hanging, which is
> "unsurprising" (being kind here) with such an old kernel. Rich, build
> your kernel with CONFIG_SCSI_MQ_DEFAULT=n or boot with
> scsi_mod.use_blk_mq=n as kernel prarameter.

Well, the kernel is 4.4 "el repo".  4.4 /is/ an LTS (and elrepo is AFAIK 
a red hat backports repo, not sure how official, but useful for people on 
red hat), but it's now the second-back LTS, with 4.9 and the new 4.14 
being newer LTS series.

The thing is that this is the btrfs list, and we're development and thus 
rather forward focused here.  As such, we normally want at /least/ the 
second newest (first back) lts series kernel for best chance at 
reasonable support.  While I understand people who want to stick with LTS 
being reluctant to go with the /newest/ LTS before even a single current 
release has passed, making that LTS still a bit new as such things go, 
certainly the one-back LTS, 4.9, should be reasonable.

So yes, tho 4.4 is at least an LTS, for purposes of btrfs and this list, 
it really is rather old now, and an upgrade, presumably to 4.9 in keeping 
with the LTS theme, would be recommended.  If the issue can be confirmed 
on the current and LTS 4.14, so much the better, but certainly, 4.9 is a 
recommended upgrade, and a bug there would still be in the concern for a 
fix range, while 4.4... really is just out of the focus range for this 
list, tho various longer focus distros will of course still provide 
support for it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

