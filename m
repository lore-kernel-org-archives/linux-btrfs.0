Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47618 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbcEPGAh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 02:00:37 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b2BZb-0008Mz-RV
	for linux-btrfs@vger.kernel.org; Mon, 16 May 2016 08:00:12 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 16 May 2016 08:00:11 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 16 May 2016 08:00:11 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: problems with free space cache
Date: Mon, 16 May 2016 05:59:55 +0000 (UTC)
Message-ID: <pan$d4fda$1f29731$4540c768$ab93bd6f@cox.net>
References: <CAD=QJKjop2j+K16nPcAU-bXiCVqm_aGK0g7WxjvTpBvXar+fQQ@mail.gmail.com>
	<85030f6b-b149-ccd2-ea87-42135b9ccd46@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Mon, 16 May 2016 10:24:23 +0800 as excerpted:

> IIRC clear_cache option is fs level option.
> So the first mount with clear_cache, then all subvolume will have
> clear_cache.

Question:  Does clear_cache work with a read-only mount?

I could see it being like the log replay and being done even on ro 
mounts, particularly since unlike the log replay, clear_cache is a 
specific mount option so could be seen as specifically requested even if 
otherwise ro.  Or not.  So I don't know.

He mentioned root, which is normally mounted read-only first.  That's 
what got me thinking about it.  Does that complicate things?

If root is mounted ro without clear_cache by the initr*, will a 
subsequent remount,rw,clear_cache do it?

And for those like me who keep root mounted ro by default, would 
clear_cache work at all, or would it not work until such time as I 
mounted root, or some other subvolume (which I don't have here to worry 
about, but for those who do...) writable?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

