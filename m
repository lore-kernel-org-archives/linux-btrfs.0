Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [77.88.71.232] ([77.88.71.232]:57003 "EHLO zimbra.karlsbakk.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbbESRJ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 May 2015 13:09:56 -0400
Date: Tue, 19 May 2015 19:09:42 +0200 (CEST)
From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <229772989.47330.1432055382498.JavaMail.zimbra@karlsbakk.net>
In-Reply-To: <5559D3D7.4020405@gmail.com>
References: <1761734734.45679.1431891207641.JavaMail.zimbra@karlsbakk.net> <pan$87dbc$361c1d30$d0fc2fb2$5646ab5d@cox.net> <1042503921.46602.1431940928643.JavaMail.zimbra@karlsbakk.net> <5559D3D7.4020405@gmail.com>
Subject: Re: Btrfs and integration with GNU ++
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> Interesting - which ones is it that's doing this?
>>
> While I don't know of any that use it by _default_ yet, I do know that
> it is an easy to use option on most of the big non-comercial distros
> already (Debian, Fedora, Ubuntu, etc.), and a couple (Gentoo, Arch, and
> possibly Slackware) have had the option to use it since it went mainline
> (although that is just a side effect of the installation procedures, not
> any kind of active attempt at support).

Seems CentOS 7 also allows for btrfs installs. Wonder if RHEL7 also would do that. Gotta test one day...

>> I didn't run it. Some part of the Jessie startup did, and 1 minute for just
>> 6x8GB (not TB) seems a lot…
>>
> To me, this sounds like some sort of systemd issue, I have heard of it
> having issues occasionally with long delays when handling btrfs
> filesystems with more than 4 devices.

It wasn't just a delay - it was fsck running - it was rather verbose on this.

roy
