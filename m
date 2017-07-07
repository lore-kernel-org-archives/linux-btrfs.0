Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:35926 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750941AbdGGFqK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Jul 2017 01:46:10 -0400
Received: by mail-pf0-f181.google.com with SMTP id q86so11844049pfl.3
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Jul 2017 22:46:10 -0700 (PDT)
Date: Thu, 6 Jul 2017 22:46:08 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org, pwnall@chromium.org
Subject: Re: Leveldb in google-chrome incompatible with btrfs?
Message-ID: <20170707054608.GA28035@vader>
References: <20170706150046.GB12959@merlins.org>
 <20170706211320.GA12206@vader.DHCP.thefacebook.com>
 <20170706212422.GH30689@merlins.org>
 <20170706230141.GA22242@vader.DHCP.thefacebook.com>
 <20170706233152.GI30689@merlins.org>
 <20170706234451.GB22242@vader.DHCP.thefacebook.com>
 <20170706235939.GJ30689@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170706235939.GJ30689@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 06, 2017 at 04:59:39PM -0700, Marc MERLIN wrote:
> On Thu, Jul 06, 2017 at 04:44:51PM -0700, Omar Sandoval wrote:
> > In the bug report, you commented that CURRENT contained MANIFEST-010814,
> > is that indeed the case or was it actually something newer? If it was
> > the newer one, then it's still tricky how we'd end up that way but not
> > as outlandish.
> 
> You are correct, my bad.
> At this point, I'm going to have to assume that something bad happened with
> rsync when I rsync'ed an old profile over the one that caused chrome to fail
> to restart.
> Especially because CURRENT was dated Oct 4th, which does not make sense.

Okay, this makes sense.

> Now that I know what to look for, I'll have a much closer look next time
> this happens, with the understanding that it would be a while if I've
> successfully fixed the reason why my laptop was crashing too often.

Sounds good.

> But you said you've also seen issues with google-chrome profile and btrfs.
> What did you experience?

I never debugged it, but I had to blow away the profile a couple of times. Then
there's this weird one which looks like a Btrfs bug:

┌[osandov@vader ~/.config]
└$ ls -al google-chrome-busted/**
ls: cannot access 'google-chrome-busted/Local State': No such file or directory
google-chrome-busted/Default:
ls: cannot access 'google-chrome-busted/Default/Preferences': No such file or directory
ls: cannot access 'google-chrome-busted/Default/.com.google.Chrome.VfAUNx': No such file or directory
total 0
drwx------ 1 osandov users 12 Feb  7 16:50 .
drwx------ 1 osandov users 14 Feb  7 16:50 ..
-????????? ? ?       ?      ?            ? .com.google.Chrome.VfAUNx
-????????? ? ?       ?      ?            ? Preferences
