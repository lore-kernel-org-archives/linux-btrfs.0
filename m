Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:22023 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751469Ab3KSDye convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Nov 2013 22:54:34 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: linux-stable 3.11.8 oopses
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <34196CDB-F6C0-47E3-ABF8-078C818A0659@colorremedies.com>
Date: Mon, 18 Nov 2013 20:54:31 -0700
Cc: btrfs list <linux-btrfs@vger.kernel.org>
Message-Id: <052CC3BF-35AB-4A43-8FAF-ED7DC6B5DC24@colorremedies.com>
References: <20131119030045.GA27334@pyropus.ca> <34196CDB-F6C0-47E3-ABF8-078C818A0659@colorremedies.com>
To: Charles Cazabon <charlesc-lists-btrfs@pyropus.ca>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 18, 2013, at 8:53 PM, Chris Murphy <lists@colorremedies.com> wrote:

> 
> On Nov 18, 2013, at 8:00 PM, Charles Cazabon <charlesc-lists-btrfs@pyropus.ca> wrote:
>> 
>> This is on x86_64, server-class hardware (ECC memory, etc).  I ran a scrub
>> overnight that reported no errors, and I'll do it again now that I've reverted
>> to 3.11.7.
>> 
>> Is there any other info that might be useful to the btrfs devs about this?
> 
> sysrq+w would dump the blockage to kernel messages. Depending on your kernel you may need to first enable sysrq functions with
> 
> echo 1 > /proc/sys/kernel/sysrq
> 
> then
> 
> echo 2 > /proc/sysrq-trigger

Cute. That 2 is supposed to be a w, hence sysrq+w.


Chris Murphy

