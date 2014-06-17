Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54693 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209AbaFQMZH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jun 2014 08:25:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WwsRl-0007Ub-Jn
	for linux-btrfs@vger.kernel.org; Tue, 17 Jun 2014 14:25:05 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 14:25:05 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 14:25:05 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: [systemd-devel] Slow startup of systemd-journal on BTRFS
Date: Tue, 17 Jun 2014 13:24:52 +0100
Message-ID: <lnpc2k$pt$1@ger.gmane.org>
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost> <539BFF47.8060006@libero.it> <20140615221307.GE24386@tango.0pointer.de> <1709025.rRUgx5gMp1@xev> <20140616101448.GB18016@tango.0pointer.de> <539F15DC.4010600@fb.com> <lnnht8$f3j$1@ger.gmane.org> <CAE5mzvj6yA3FhZ-bpR29XLuuk8BbuOfW4HP9BKnxuuYN8L8_kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <CAE5mzvj6yA3FhZ-bpR29XLuuk8BbuOfW4HP9BKnxuuYN8L8_kw@mail.gmail.com>
Cc: systemd-devel@lists.freedesktop.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 17/06/14 02:13, cwillu wrote:
> It's not a mmap problem, it's a small writes with an msync or fsync
> after each one problem.

And for logging, that is exactly what is wanted to see why whatever
crashed...

Except...

Whilst logging, hold off on the msync/fsync unless the next log message
to be written is 'critical'?

With that, the mundane logging gets appended just as for any normal file
write. Only the more critical log messages suffer the extra overhead and
fragmentation of an immediate msync/fsync.


> For the case of sequential writes (via write or mmap), padding writes
> to page boundaries would help, if the wasted space isn't an issue.
> Another approach, again assuming all other writes are appends, would
> be to periodically (but frequently enough that the pages are still in
> cache) read a chunk of the file and write it back in-place, with or
> without an fsync. On the other hand, if you can afford to lose some
> logs on a crash, not fsyncing/msyncing after each write will also
> eliminate the fragmentation.
> 
> (Worth pointing out that none of that is conjecture, I just spent 30
> minutes testing those cases while composing this ;p)
> 
> Josef has mentioned in irc that a piece of Chris' raid5/6 work will
> also fix this when it lands.

Interesting...

The source problem is how the COW fragments under expected normal use...
Is all this unavoidable unless we rethink the semantics?


Regards,
Martin


