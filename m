Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49180 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbaJYD2U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Oct 2014 23:28:20 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xhs1a-0005GQ-MK
	for linux-btrfs@vger.kernel.org; Sat, 25 Oct 2014 05:28:18 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Oct 2014 05:28:18 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Oct 2014 05:28:18 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Heavy nocow'd VM image fragmentation
Date: Sat, 25 Oct 2014 03:28:06 +0000 (UTC)
Message-ID: <pan$37631$612ebdea$68e82275$b6e96b7b@cox.net>
References: <5449898B.4090708@nuclearwinter.com>
	<20141024114916.GI12554@merlins.org> <544B0DDC.1020102@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Fri, 24 Oct 2014 19:41:32 -0700 as excerpted:

> On 10/24/2014 04:49 AM, Marc MERLIN wrote:
>> On Thu, Oct 23, 2014 at 06:04:43PM -0500, Larkin Lowrey wrote:
>>> I have a 240GB VirtualBox vdi image that is showing heavy
>>> fragmentation (filefrag). The file was created in a dir that was
>>> chattr +C'd, the file was created via fallocate and the contents of
>>> the orignal image were copied into the file via dd. I verified that
>>> the image was +C.
>> To be honest, I have the same problem, and it's vexing:
> 
> If I understand correctly, when you take a snapshot the file goes into
> what I call "1COW" mode.

Yes, but the OP said he hadn't snapshotted since creating the file, and 
MM's a regular that actually wrote much of the wiki documentation on 
raid56 modes, so he better know about the snapshotting problem too.

So that can't be it.  There's apparently a bug in some recent code, and 
it's not honoring the NOCOW even in normal operation, when it should be.

(FWIW I'm not running any VMs or large DBs here, so don't have nocow set 
on anything and can and do use autodefrag on all my btrfs.  So I can't 
say one way or the other, personally.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

