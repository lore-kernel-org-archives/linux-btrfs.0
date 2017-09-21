Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:40513 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751581AbdIULmi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Sep 2017 07:42:38 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1duzsC-0002gT-KS
        for linux-btrfs@vger.kernel.org; Thu, 21 Sep 2017 13:42:28 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: using fio to test btrfs compression
Date: Thu, 21 Sep 2017 11:42:22 +0000 (UTC)
Message-ID: <pan$3dec4$18b517ef$e5e9b759$bada3237@cox.net>
References: <CAP9W88j+UZCiF6-Bj6Nyh83L=jpTfM5vF-Pz0y09TJ5dsbciZw@mail.gmail.com>
        <CAGqmi74XQkpRwhZ23qyNg7EuGi=aC8aKymUU8g8XeMsLmNHkVA@mail.gmail.com>
        <CAP9W88gs6xYh4MxU--ktS-Ozv8vqs3q84vp52x8OM=Rz3a12vg@mail.gmail.com>
        <CAGqmi74Es55Ptfkyd=sBHdfSoE_rqqyis4juZBbiKc9+LAwMGA@mail.gmail.com>
        <CAP9W88ig1fXyrE0KURbP-1Z0-t63ODADA4HO0tO4KM3eVrRtLg@mail.gmail.com>
        <CAP9W88ifgTWGE_9Xpro=wUJkMSs9263e0Sw6yeG8Km16rdD6AA@mail.gmail.com>
        <CAGqmi75DoErKwwHu7+abu62sUbbEgjMZ1ExzpCpQ68JKmTF==g@mail.gmail.com>
        <CAP9W88ip0ef7yFc3-o8LNO=WsBjhpADbSuzQoppz6yC5KpRTQg@mail.gmail.com>
        <CAGqmi75wKaxpJNO6HfjUJZU4tESQA-r_4rTfe7MY9KW5C67JaQ@mail.gmail.com>
        <CAP9W88hrM+9vPTL=RFXC9+VdWSLMvM1UAtR+XX89FcvorYLqvQ@mail.gmail.com>
        <CAGqmi77ZFmaeSf_Ehoe_T76_RqnG2YcG68y57w8UVpuJ=_awcA@mail.gmail.com>
        <CAP9W88g-XpOcL0CyVOHEGkTc7YN=Kodpb7XCVF45TcO+equ2Vw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

shally verma posted on Wed, 20 Sep 2017 16:40:15 +0530 as excerpted:

> Is there any command that i can run to confirm file has been compressed?

There is the quite recently posted (and actively updated since then) 
compsize command.

https://github.com/kilobyte/compsize

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

