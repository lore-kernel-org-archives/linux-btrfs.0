Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33871 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbaJGONC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Oct 2014 10:13:02 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XbVVd-0005Ir-IF
	for linux-btrfs@vger.kernel.org; Tue, 07 Oct 2014 16:13:01 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Oct 2014 16:13:01 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Oct 2014 16:13:01 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [Bug] 3.17.0 mixed-bg enospc but both btrfs fi show and btrfs
 fi df say there's plenty
Date: Tue, 7 Oct 2014 14:12:49 +0000 (UTC)
Message-ID: <pan$6ceba$5e2fc992$69bbe110$430a3e20@cox.net>
References: <pan$40d93$809c9f3a$611f994e$934f6422@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan posted on Tue, 07 Oct 2014 13:41:49 +0000 as excerpted:

> FWIW, if I try to cp it instead of using mc, 14208 KiB copies before I
> get the enospc.

Interesting workaround I just found:

1) cp the file and let the cp abort.
2) delete the partial copy
3) mc-copy the file.
4) watch the full 14905 KiB file mc-copy over just fine.

But:

5) delete the full copy
6) try mc-copying the thing again
7) same issue as before

And:

8) try using cp for the partial copy again
9) delete the partial copy
10) cp the file again
11) still a partial copy, but 14464 KiB instead of 14208 KiB copied

Further:

12) delete that (14464 KiB) partial copy
13) cp the file yet again
14) full file copies over (diff-identical)


With the full file copied over now, btrfs filesystem show gives the same 
results, but the btrfs filesystem df data+metadata line looks like this:

Data+Metadata, DUP: total=50.00MiB, used=43.94MiB

Given that without the file it was used=30.59 MiB, the space used by the 
14.56 MiB file is 13.35 MiB, presumably due to lzo-compression.

But why is it working under some conditions and failing with enospc under 
others?

Is this something those compression-related patches I've see floating 
around should fix?  I guess not all of them made it into 3.17 if so.  
Hopefully 3.18.  Or is this a different bug without a patch floating 
around yet?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

