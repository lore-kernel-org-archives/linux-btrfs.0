Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52921 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbcBUSAU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Feb 2016 13:00:20 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aXSl7-0002jZ-1x
	for linux-btrfs@vger.kernel.org; Sun, 21 Feb 2016 13:05:05 +0100
Received: from 5.158.146.200 ([5.158.146.200])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Feb 2016 13:05:05 +0100
Received: from episource by 5.158.146.200 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Feb 2016 13:05:05 +0100
To: linux-btrfs@vger.kernel.org
From: Philipp Serr <episource@gmx.de>
Subject: Re: random i/o error without error in dmesg
Date: Sun, 21 Feb 2016 13:01:18 +0100
Message-ID: <nac8uf$rea$1@ger.gmane.org>
References: <562E0D31.2080003@dblaci.hu> <5339076.FcC2BAjqs5@thetick>
 <pan$69543$b4766f34$8286648d$3871cb8f@cox.net> <56308ADC.5060207@dblaci.hu>
 <5637AAB9.5040901@dblaci.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
In-Reply-To: <5637AAB9.5040901@dblaci.hu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2 Nov 2015 19:26:01 +0100, Szalma László wrote:
> Unfortunately the problem with kernel 4.3.0 still exists.


Any news on that issue? I'm currently @ 4.3.3 and the issue persists for 
me, too.

There's one more information I might be able to contribute: In my case 
always the same single file is affected. The issue is triggered mostly 
when backing up a read-only snapshot of the volume using rsync. Once the 
issue occures, the file within the snapshot volume as well as the file 
in the main volume can't be read anymore until reboot (didn't try 
remounting the affected root partition).

