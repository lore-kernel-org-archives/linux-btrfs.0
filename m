Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:60188 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932135AbaFQR4q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jun 2014 13:56:46 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [systemd-devel] Slow startup of systemd-journal on BTRFS
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAE5mzvj6yA3FhZ-bpR29XLuuk8BbuOfW4HP9BKnxuuYN8L8_kw@mail.gmail.com>
Date: Tue, 17 Jun 2014 11:56:38 -0600
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        systemd-devel@lists.freedesktop.org
Message-Id: <0C66EF49-439B-4FD6-BEFF-FB4183586C38@colorremedies.com>
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost> <539BFF47.8060006@libero.it> <20140615221307.GE24386@tango.0pointer.de> <1709025.rRUgx5gMp1@xev> <20140616101448.GB18016@tango.0pointer.de> <539F15DC.4010600@fb.com> <lnnht8$f3j$1@ger.gmane.org> <CAE5mzvj6yA3FhZ-bpR29XLuuk8BbuOfW4HP9BKnxuuYN8L8_kw@mail.gmail.com>
To: cwillu <cwillu@cwillu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 16, 2014, at 7:13 PM, cwillu <cwillu@cwillu.com> wrote:

> It's not a mmap problem, it's a small writes with an msync or fsync
> after each one problem.
> 
> For the case of sequential writes (via write or mmap), padding writes
> to page boundaries would help, if the wasted space isn't an issue.
> Another approach, again assuming all other writes are appends, would
> be to periodically (but frequently enough that the pages are still in
> cache) read a chunk of the file and write it back in-place, with or
> without an fsync. On the other hand, if you can afford to lose some
> logs on a crash, not fsyncing/msyncing after each write will also
> eliminate the fragmentation.

Normally I'd be willing to give up ~30 seconds of journal to not have fragmented journals. But then if I use systemd.log_level=debug I'd like that to trigger more frequent flushing to make sure as little of the journaling is lost as possible. Does that make sense?


Chris Murphy