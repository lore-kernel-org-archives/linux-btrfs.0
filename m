Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:33035 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbbESSFg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 May 2015 14:05:36 -0400
Received: by iebgx4 with SMTP id gx4so20285883ieb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2015 11:05:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <229772989.47330.1432055382498.JavaMail.zimbra@karlsbakk.net>
References: <1761734734.45679.1431891207641.JavaMail.zimbra@karlsbakk.net>
	<pan$87dbc$361c1d30$d0fc2fb2$5646ab5d@cox.net>
	<1042503921.46602.1431940928643.JavaMail.zimbra@karlsbakk.net>
	<5559D3D7.4020405@gmail.com>
	<229772989.47330.1432055382498.JavaMail.zimbra@karlsbakk.net>
Date: Tue, 19 May 2015 12:05:36 -0600
Message-ID: <CAJCQCtRw0EogA0qhcvv0_U0ArX4HnsVpYEzmHjjHkwZDW0N5Og@mail.gmail.com>
Subject: Re: Btrfs and integration with GNU ++
From: Chris Murphy <lists@colorremedies.com>
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 19, 2015 at 11:09 AM, Roy Sigurd Karlsbakk
<roy@karlsbakk.net> wrote:
>>> Interesting - which ones is it that's doing this?
>>>
>> While I don't know of any that use it by _default_ yet, I do know that
>> it is an easy to use option on most of the big non-comercial distros
>> already (Debian, Fedora, Ubuntu, etc.), and a couple (Gentoo, Arch, and
>> possibly Slackware) have had the option to use it since it went mainline
>> (although that is just a side effect of the installation procedures, not
>> any kind of active attempt at support).
>
> Seems CentOS 7 also allows for btrfs installs. Wonder if RHEL7 also would do that. Gotta test one day...

They're meant to be binary compatible in every way, including bugs.
The difference is branding.

>
>>> I didn't run it. Some part of the Jessie startup did, and 1 minute for just
>>> 6x8GB (not TB) seems a lot…
>>>
>> To me, this sounds like some sort of systemd issue, I have heard of it
>> having issues occasionally with long delays when handling btrfs
>> filesystems with more than 4 devices.
>
> It wasn't just a delay - it was fsck running - it was rather verbose on this.

Doubtful because again, the fsck.btrfs is not an fsck, it's a no op.
And on my copy of CentOS 7 it's not running btrfs check let alone
btrfs check --repair. So I don't know what you have going on, but
without a complete journal it's hard to say. I suggest posting the
result of:

'journalctl -b -l -o short monotonic'




-- 
Chris Murphy
