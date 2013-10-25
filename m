Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:43944 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755241Ab3JYA5U convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Oct 2013 20:57:20 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Why cannot I move a read-only snapshot around?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20131024231349.GA15363@kipc2.localdomain>
Date: Thu, 24 Oct 2013 18:57:18 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <B0C94FFC-3691-45F9-BCF8-C7C1AB3D5D45@colorremedies.com>
References: <20131024152955.GA6110@kipc2.localdomain> <1D7328F7-EB4F-4C3F-8EAB-2EDB6331F77E@colorremedies.com> <20131024215715.GA14128@kipc2.localdomain> <97FC1966-5DC7-488F-8A6C-C8C8B2EB8490@colorremedies.com> <20131024224608.GA14904@kipc2.localdomain> <AD5E9D64-6AED-48E2-8635-4B599F58F3A8@colorremedies.com> <20131024231349.GA15363@kipc2.localdomain>
To: Karl Kiniger <karl.kiniger@med.ge.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 24, 2013, at 5:13 PM, Karl Kiniger <karl.kiniger@med.ge.com> wrote:

> On Thu 131024, Chris Murphy wrote:
>> 
>> On Oct 24, 2013, at 4:46 PM, Karl Kiniger <karl.kiniger@med.ge.com> wrote:
>> In what way would a r/o snapshot be modified because of moving its
>>> "mount point" ? No one is ever doing something inside.
>> 
>> For the same reason I can't move or rename a read only directory even though I'm not doing something inside.
> 
> I see now: the .. entry would change if the directory were being moved.
> 
> Still hoping there is a better way on btrfs than sending and receiving the snaps
> just to a different folder.

Presumably you can rename/move the containing folder. So if it's in a folder already, create a replacement for it, mv the current containing folder into the replacement. And then rename them however you want.


Chris Murphy