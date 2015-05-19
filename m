Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:37939 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbbESUE5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 May 2015 16:04:57 -0400
Received: by igcau1 with SMTP id au1so23274745igc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2015 13:04:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <555B91D0.2060609@redhat.com>
References: <1761734734.45679.1431891207641.JavaMail.zimbra@karlsbakk.net>
	<pan$87dbc$361c1d30$d0fc2fb2$5646ab5d@cox.net>
	<1042503921.46602.1431940928643.JavaMail.zimbra@karlsbakk.net>
	<5559D3D7.4020405@gmail.com>
	<229772989.47330.1432055382498.JavaMail.zimbra@karlsbakk.net>
	<CAJCQCtRdQMt9w0svBGnWU0t8AbWEJ=s7i_z7namCXK_u5A4Brw@mail.gmail.com>
	<555B91D0.2060609@redhat.com>
Date: Tue, 19 May 2015 14:04:56 -0600
Message-ID: <CAJCQCtSENLFXdBAxTRe74prRpqyHi5wCoy4--Y-Zr4SFA_YHBw@mail.gmail.com>
Subject: Re: Btrfs and integration with GNU ++
From: Chris Murphy <lists@colorremedies.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 19, 2015 at 1:41 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 5/19/15 1:09 PM, Chris Murphy wrote:
>> Also, those CentOS/RHEL 7 kernels are old by Btrfs standards. You
>> should consider using elrepo kernels (they have kernel 4.0.3 and 4.0.4
>> right now), and if you can't do that, then I wouldn't use Btrfs, use
>> XFS instead with those 3.10.x kernels.
>
> FWIW, I have been keeping the btrfs codebase in RHEL7 as up to date as possible,
> given release frequency constraints.
>
> The kernel is based on 3.10, but the btrfs code is much newer.

That's good to know. Thanks for that!

-- 
Chris Murphy
