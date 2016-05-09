Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35772 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbcEIST5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 May 2016 14:19:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1azpmc-0001sg-Sd
	for linux-btrfs@vger.kernel.org; Mon, 09 May 2016 20:19:55 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 09 May 2016 20:19:54 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 09 May 2016 20:19:54 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs goes readonly + No space left on 4.3
Date: Mon, 9 May 2016 18:19:46 +0000 (UTC)
Message-ID: <pan$606ae$7c2ddacd$8669ab01$40a7c124@cox.net>
References: <561B5AA6.7040704@profihost.ag> <5723C88F.30903@profihost.ag>
	<20160502220549.GB24432@vader.DHCP.thefacebook.com>
	<573089AD.6090108@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Stefan Priebe - Profihost AG posted on Mon, 09 May 2016 14:59:25 +0200 as
excerpted:

> Am 03.05.2016 um 00:05 schrieb Omar Sandoval:
>> On Fri, Apr 29, 2016 at 10:48:15PM +0200, Stefan Priebe wrote:
>>> just want to drop a note that all those ENOSPC msg are gone with v4.5
>>> and space_cache=v2. Any plans to make space_cache=v2 default?
>>>
>> Yup, we want to make space_cache=v2 the default at some point. I'm
>> running it on my own machines and testing it here at Facebook and
>> haven't run into any issues yet. Besides stability, I also want to make
>> sure there aren't any performance regressions versus the old free space
>> cache that we haven't thought about yet.
>> 
>> Thanks for trying it out :)
> 
> Can i patch v2 as a default for me? I just looked at the code but didn't
> find an easy way to make v2 the default.

Based on previous posts, space_cache=v2 will rewrite the cache to tree 
form, and it'll stay that way (thus your default) until you specifically 
use the clear-cache option.

IOW, the code detects existing v1 or v2 and continues to use it until a 
clear-cache mount and no v2 set on the mount after, to switch back to v1, 
or a space_cache=v2 to switch to it.

IOW, the space_cache option doesn't need set more than once (and for v1, 
it doesn't actually need set at all, except perhaps after a clear_cache, 
I've never specifically set space_cache here, but it's always listed in 
the mount output and /proc/self/mounts).  After that it carries on the 
way it was.

Or did you mean that you're creating enough new btrfs that using 
space_cache=v2 even once is difficult, and you'd like to patch it to use 
v2 from the get-go?  Presumably that can indeed be patched in, but not 
being a dev, even if I could figure out a patch that worked for it, 
there's a fair chance it would be more a hack than proper code.  (As an 
admin I have a patch that switches the normal relatime default to noatime, 
so I don't have to have it in all my fstab entries, etc, and it works, 
but it's clearly a hack compared to what a proper dev would code.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

