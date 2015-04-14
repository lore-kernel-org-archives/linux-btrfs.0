Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45490 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbbDNDSy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 23:18:54 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YhrND-00034q-52
	for linux-btrfs@vger.kernel.org; Tue, 14 Apr 2015 05:18:51 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2015 05:18:51 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2015 05:18:51 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Big disk space usage difference, even after defrag, on
 identical data
Date: Tue, 14 Apr 2015 03:18:45 +0000 (UTC)
Message-ID: <pan$a2c0$b009b2e3$829f9ec1$354dda7c@cox.net>
References: <55297D36.8090808@sjeng.org>
	<pan$f11f0$7ca65f9$58551aba$5ec77500@cox.net> <552BCD6F.6080509@sjeng.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gian-Carlo Pascutto posted on Mon, 13 Apr 2015 16:06:39 +0200 as
excerpted:

>> Defrag should force the rewrite of entire files and take care of this,
>> but obviously it's not returning to "clean" state.  I forgot what the
>> default minimum file size is if -t isn't set, maybe 128 MiB?  But a -t1
>> will force it to defrag even small files, and I recall at least one
>> thread here where the poster said it made all the difference for him,
>> so try that.  And the -f should force a filesystem sync afterward, so
>> you know the numbers from any report you run afterward match the final
>> state.
> 
> Reading the corresponding manual, the -t explanation says that "any
> extent bigger than this size will be considered already defragged". So I
> guess setting -t1 might've fixed the problem too...but after checking
> the source, I'm not so sure.

Oops!  You are correct.  There was an on-list discussion of that before 
that I had forgotten.  The "make sure everything gets defragged" magic 
setting is -t 1G or higher, *not* the -t 1 I was trying to tell you 
previously (which will end up skipping everything, instead of defragging 
everything).

Thanks for spotting the inconsistency and calling me on it! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

