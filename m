Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbbESTlH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 May 2015 15:41:07 -0400
Message-ID: <555B91D0.2060609@redhat.com>
Date: Tue, 19 May 2015 14:41:04 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Roy Sigurd Karlsbakk <roy@karlsbakk.net>
CC: Austin S Hemmelgarn <ahferroin7@gmail.com>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs and integration with GNU ++
References: <1761734734.45679.1431891207641.JavaMail.zimbra@karlsbakk.net>	<pan$87dbc$361c1d30$d0fc2fb2$5646ab5d@cox.net>	<1042503921.46602.1431940928643.JavaMail.zimbra@karlsbakk.net>	<5559D3D7.4020405@gmail.com>	<229772989.47330.1432055382498.JavaMail.zimbra@karlsbakk.net> <CAJCQCtRdQMt9w0svBGnWU0t8AbWEJ=s7i_z7namCXK_u5A4Brw@mail.gmail.com>
In-Reply-To: <CAJCQCtRdQMt9w0svBGnWU0t8AbWEJ=s7i_z7namCXK_u5A4Brw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5/19/15 1:09 PM, Chris Murphy wrote:
> On Tue, May 19, 2015 at 11:09 AM, Roy Sigurd Karlsbakk
> <roy@karlsbakk.net> wrote:
>>>> Interesting - which ones is it that's doing this?
>>>>
>>> While I don't know of any that use it by _default_ yet, I do know that
>>> it is an easy to use option on most of the big non-comercial distros
>>> already (Debian, Fedora, Ubuntu, etc.), and a couple (Gentoo, Arch, and
>>> possibly Slackware) have had the option to use it since it went mainline
>>> (although that is just a side effect of the installation procedures, not
>>> any kind of active attempt at support).
>>
>> Seems CentOS 7 also allows for btrfs installs. Wonder if RHEL7 also would do that. Gotta test one day...
> 
> Also, those CentOS/RHEL 7 kernels are old by Btrfs standards. You
> should consider using elrepo kernels (they have kernel 4.0.3 and 4.0.4
> right now), and if you can't do that, then I wouldn't use Btrfs, use
> XFS instead with those 3.10.x kernels.

FWIW, I have been keeping the btrfs codebase in RHEL7 as up to date as possible,
given release frequency constraints.

The kernel is based on 3.10, but the btrfs code is much newer.

-Eric

