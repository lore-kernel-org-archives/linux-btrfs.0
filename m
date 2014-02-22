Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:58446 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753158AbaBVCno convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Feb 2014 21:43:44 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Hard drive hangs after excessive I/O
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAAVQaYBC6sd--Sr-eYmHuE4M-Kb2cm5e44ndSV=QDM5XGd__Eg@mail.gmail.com>
Date: Fri, 21 Feb 2014 19:43:40 -0700
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <9DD9088B-2A4C-4D12-9292-C77899024989@colorremedies.com>
References: <CAAVQaYCkxpp8vX8PnO3OLffSm_MMCt6N2qFT=5DWjseZmZ1xbA@mail.gmail.com> <pan$9db86$8cb7b8f1$9ed699ad$9da2e024@cox.net> <CAAVQaYDDsfuHu-Lfcjjta48YCP50vZmnGdFM67VQJefnnAfOAg@mail.gmail.com> <6A514E1D-EDD7-431D-BF23-9737EAE41DD3@colorremedies.com> <CAAVQaYBC6sd--Sr-eYmHuE4M-Kb2cm5e44ndSV=QDM5XGd__Eg@mail.gmail.com>
To: Dave <dave@thekilempire.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 21, 2014, at 12:27 PM, Dave <dave@thekilempire.com> wrote:

> On Fri, Feb 21, 2014 at 12:59 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> Five concurrent VMs for one spinning disk. It sounds like it's seeking to death.
> 
> That's my reproducible test, not typical use.
> 
> "Seeking to death" would indicate drive activity.  When the problem
> occurs, drive activity stops for minutes at a time.
> 
> I suppose I shouldn't have even mentioned VMs because that seems to be
> muddying the discussion.  The problem persists after all the VMs are
> shut down.  For instance, right now I'm not running any VMs but I'm
> experiencing the problem (though I was performing the above test).  I
> can observe it by doing a local git clone of the linux kernel:
> git clone /usr/src/linux
> 
> If I run this from a fresh boot, it causes the hard drive to chatter
> but doesn't cause IO to hang.  After running the above 5-VM test for a
> day, even after shutting down the VMs, my machine is still in this
> state that causes IO to periodically hang.

I am not a Btrfs developer, but when the problem isn't already known, usually comes the request to reproduce the problem and issue sysrq+w, and then grab a full dmesg and post that.


Chris Murphy