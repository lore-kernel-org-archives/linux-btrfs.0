Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36599 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbaIBMe2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Sep 2014 08:34:28 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XOnI1-000134-Ah
	for linux-btrfs@vger.kernel.org; Tue, 02 Sep 2014 14:34:25 +0200
Received: from pd953e79b.dip0.t-ipconnect.de ([217.83.231.155])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Sep 2014 14:34:25 +0200
Received: from holger.hoffstaette by pd953e79b.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Sep 2014 14:34:25 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: Btrfs-progs-3.16: fs metadata is both single and dup?
Date: Tue, 2 Sep 2014 12:34:12 +0000 (UTC)
Message-ID: <pan.2014.09.02.12.34.12@googlemail.com>
References: <pan.2014.09.02.12.05.33@googlemail.com>
	<20140902121349.GF18897@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 02 Sep 2014 13:13:49 +0100, Hugo Mills wrote:

> [snip]
>> So where does the confusing initial display come from? I'm running this
>> against a (very patched) 3.14.17, but don't remember ever seeing this
>> with btrfs-progs-3.14.2.
> 
>    Your memory is faulty, I'm afraid. It's always done that -- at

After 40 it's all downhill.. :-)

> least since I started using btrfs, several years ago.

Alright then. I was just getting nervous I might have borked something 
either with my kernel or that the new progs somehow get information from 
the kernel that is off/wrong.

All my other filesystems display as expected, but they have been balanced 
previously - so nothing to see there.

Thanks!

Holger

