Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([83.144.122.22]:46542 "EHLO zlom.siedziba.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751678AbeCMHPM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Mar 2018 03:15:12 -0400
From: =?UTF-8?Q?Piotr_Paw=c5=82ow?= <btrfs@pp.siedziba.pl>
Subject: Re: Raid1 volume stuck as read-only: How to dump, recreate and
 restore its content?
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org,
        a.t.hild@gmail.com
References: <CAEm4ggntj1ccp6PXvECDVrj0_RXrzn6fX7mu+CWtHNwCAoXbvg@mail.gmail.com>
 <20180311174713.53tqlmjn6t3d4gwh@angband.pl>
 <pan$16a8$693752e8$556456d2$4e57d94b@cox.net>
Message-ID: <7f9921b0-8f66-b070-7599-8750160649dd@siedziba.pl>
Date: Tue, 13 Mar 2018 08:08:27 +0100
MIME-Version: 1.0
In-Reply-To: <pan$16a8$693752e8$556456d2$4e57d94b@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
> Put differently, 4.7 is missing a year and a half worth of bugfixes that you won't have when you run it to try to check or recover that btrfs that won't mount! Do you *really* want to risk your data on bugs that were after all discovered and fixed over a year ago? 

It is also missing newly introduced bugs. Right now I'm dealing with btrfs raid1 server that had the fs getting stuck and kernel oopses due to a regression:

https://bugzilla.kernel.org/show_bug.cgi?id=198861

I had to cherry-pick commit 3be8828fc507cdafe7040a3dcf361a2bcd8e305b and recompile the kernel to even start moving the data off the failing drive, as the fix is not in stable yet, and encountering any i/o error would break the kernel. And now it seems the fs is corrupted, maybe due to all the crashes earlier.

FYI in case you decide to switch to 4.15
