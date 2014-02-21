Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:56963 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaBUT1W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Feb 2014 14:27:22 -0500
Received: by mail-ob0-f175.google.com with SMTP id va2so1598986obc.6
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Feb 2014 11:27:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <6A514E1D-EDD7-431D-BF23-9737EAE41DD3@colorremedies.com>
References: <CAAVQaYCkxpp8vX8PnO3OLffSm_MMCt6N2qFT=5DWjseZmZ1xbA@mail.gmail.com>
	<pan$9db86$8cb7b8f1$9ed699ad$9da2e024@cox.net>
	<CAAVQaYDDsfuHu-Lfcjjta48YCP50vZmnGdFM67VQJefnnAfOAg@mail.gmail.com>
	<6A514E1D-EDD7-431D-BF23-9737EAE41DD3@colorremedies.com>
Date: Fri, 21 Feb 2014 14:27:21 -0500
Message-ID: <CAAVQaYBC6sd--Sr-eYmHuE4M-Kb2cm5e44ndSV=QDM5XGd__Eg@mail.gmail.com>
Subject: Re: Hard drive hangs after excessive I/O
From: Dave <dave@thekilempire.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 21, 2014 at 12:59 PM, Chris Murphy <lists@colorremedies.com> wrote:
> Five concurrent VMs for one spinning disk. It sounds like it's seeking to death.

That's my reproducible test, not typical use.

"Seeking to death" would indicate drive activity.  When the problem
occurs, drive activity stops for minutes at a time.

I suppose I shouldn't have even mentioned VMs because that seems to be
muddying the discussion.  The problem persists after all the VMs are
shut down.  For instance, right now I'm not running any VMs but I'm
experiencing the problem (though I was performing the above test).  I
can observe it by doing a local git clone of the linux kernel:
git clone /usr/src/linux

If I run this from a fresh boot, it causes the hard drive to chatter
but doesn't cause IO to hang.  After running the above 5-VM test for a
day, even after shutting down the VMs, my machine is still in this
state that causes IO to periodically hang.
-- 
-=[dave]=-

Entropy isn't what it used to be.
