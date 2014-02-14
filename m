Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42626 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbaBNAUG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 19:20:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WE6Vg-0002Fv-Fa
	for linux-btrfs@vger.kernel.org; Fri, 14 Feb 2014 01:20:04 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Feb 2014 01:20:04 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Feb 2014 01:20:04 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Possible to wait for snapshot deletion?
Date: Fri, 14 Feb 2014 01:15:29 +0100
Message-ID: <1q30ta-po2.ln1@hurikhan77.spdns.de>
References: <jfhvsa-unf.ln1@hurikhan77.spdns.de> <pan.2014.02.13.21.42.31@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Holger Hoffstätte <holger.hoffstaette@googlemail.com> schrieb:

> On Thu, 13 Feb 2014 20:02:43 +0100, Kai Krakow wrote:
> 
>> Is it technically possible to wait for a snapshot completely purged from
>> disk? I imagine an option like "--wait" for btrfs delete subvolume.
> 
> That would indeed be sweet (see pointer to patch by Garry Williams).
> 
> In the meantime have you tried issuing a simple "sync" in your script
> after every snapshot deletion? I've observed that this kicks the cleaner
> into action.

I was under the impression that a sync command just doesn't do the trick. It 
kicks in the cleaner but returns to early. But I din't try that again 
lately.

But I'm actually currently using "btrfs fs sync" to do it because a normal 
"sync" command would affect all my filesystems and I'd like to keep it 
isolated.

I'll post a link to my backup script for reference in another post in this 
thread.

-- 
Replies to list only preferred.

