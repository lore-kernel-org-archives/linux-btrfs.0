Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51550 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbaBUIBV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Feb 2014 03:01:21 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WGl2t-0005Mq-Ho
	for linux-btrfs@vger.kernel.org; Fri, 21 Feb 2014 09:01:19 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Feb 2014 09:01:19 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Feb 2014 09:01:19 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Meaning of \"no_csum\" field when scrubbing with -R option
Date: Fri, 21 Feb 2014 08:00:55 +0000 (UTC)
Message-ID: <pan$a9781$e2170d79$56defdc9$40402ab8@cox.net>
References: <5305DE1E.8080302@cn.fujitsu.com>
	<5305E63B.4000405@informatik.uni-bonn.de>
	<5305F72F.9050109@cn.fujitsu.com> <5306BA41.1060700@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wang Shilong posted on Fri, 21 Feb 2014 10:30:25 +0800 as excerpted:

>>>> So my question is, why does scrub show a high (i.e. non-zero) value
>>>> for no_csum? I never enabled nodatasum or a similar option.

> This should be related to btrfs free space cache, it is designed as
> nocow without checksums.

That's a reasonable explanation.  Thanks. =:^)

(And anyway, if the space-cache gets corrupted, there are mount options 
to clear it, etc, and it's easily rebuilt even if it takes long enough 
keeping the cache is useful in general, so it's not a huge deal needing 
checksummed.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

