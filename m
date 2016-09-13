Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:54302 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750734AbcIMEZi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Sep 2016 00:25:38 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bjfHY-0008Ag-Tb
        for linux-btrfs@vger.kernel.org; Tue, 13 Sep 2016 06:25:16 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Small fs
Date: Tue, 13 Sep 2016 04:25:05 +0000 (UTC)
Message-ID: <pan$35973$28ba0970$9a667dbd$d35e0fd9@cox.net>
References: <CAK5rZE49j5QYZJSriG70LVo-9JnRJRfwFA0qRZSEotXpCxJC6A@mail.gmail.com>
        <CAJCQCtT5T5M7a1vtaGZjGLiPs_6-MnMXc5qPoH0Hc7RJPz0HZw@mail.gmail.com>
        <pan$e206f$d515790a$646cc891$9e1c047e@cox.net>
        <CAJCQCtQz6cPhE1ciP5KJ2B5Ccy_5PSbzrmLmvh3rULoz_3h0bw@mail.gmail.com>
        <pan$612d5$bc50d5d7$f1744b5$1e6b9281@cox.net>
        <CAJCQCtTQfPGndDvL+mrMOMp4MH2E0Gd3xapGT5B9QP53aTi2sQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Mon, 12 Sep 2016 08:48:49 -0600 as excerpted:

> On Sun, Sep 11, 2016 at 10:54 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
>> On the bright side, the double-whammy of being under such tight
>> filesystem size constraints, coupled with finding out you have less
>> than half the space of the filesystem actually available due to
>> default-mixed-mode AND default dup-metadata (thus dup everything),
> 
> I'm not following what you mean by default dup everything. You mean
> that's how it used to work? Because on a real USB stick, 2GiB:


Yes.  What I meant is that now that --mixed isn't default, it avoids auto-
halving the space due to duping the data as well (which AFAIK it used to 
do by default since mixed-mode treated everything as metadata, and 
metadata defaults are dup except on ssd), in mixed-mode.

Tho now that I think of it, it's possible I'm mistaken, since I always 
specify single/dup/raid1/whatever, as well as mixed if I want it, 
choosing not to rely on the defaults, myself.

Which seems a pretty wise choice, with the defaults changing over time, 
sometimes, as with removal of the old default mixed under a GiB, to 
strongly dis-recommended defaults. =:^(

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

