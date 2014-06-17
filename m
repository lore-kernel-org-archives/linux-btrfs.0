Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay07.libero.it ([212.52.84.111]:51717 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480AbaFQTip (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jun 2014 15:38:45 -0400
Received: from venice.bhome (151.28.75.219) by outrelay07.libero.it (8.6.033) (authenticated as kreijack@libero.it)
        id 53A050B3001414AA for linux-btrfs@vger.kernel.org; Tue, 17 Jun 2014 21:38:33 +0200
Message-ID: <53A09A30.2030800@libero.it>
Date: Tue, 17 Jun 2014 21:42:40 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [systemd-devel] Slow startup of systemd-journal on BTRFS
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost> <539BFF47.8060006@libero.it> <20140615221307.GE24386@tango.0pointer.de> <1709025.rRUgx5gMp1@xev> <20140616101448.GB18016@tango.0pointer.de> <539F15DC.4010600@fb.com> <lnnht8$f3j$1@ger.gmane.org> <CAE5mzvj6yA3FhZ-bpR29XLuuk8BbuOfW4HP9BKnxuuYN8L8_kw@mail.gmail.com> <CADU+-uCQe+ThvH8EOW0tn+Oh4ZNnSP0P743mF7NXNDuD2yokCA@mail.gmail.com>
In-Reply-To: <CADU+-uCQe+ThvH8EOW0tn+Oh4ZNnSP0P743mF7NXNDuD2yokCA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/17/2014 08:46 PM, Filipe Brandenburger wrote:
> On Mon, Jun 16, 2014 at 6:13 PM, cwillu <cwillu@cwillu.com> wrote:
>> For the case of sequential writes (via write or mmap), padding writes
>> to page boundaries would help, if the wasted space isn't an issue.
>> Another approach, again assuming all other writes are appends, would
>> be to periodically (but frequently enough that the pages are still in
>> cache) read a chunk of the file and write it back in-place, with or
>> without an fsync. On the other hand, if you can afford to lose some
>> logs on a crash, not fsyncing/msyncing after each write will also
>> eliminate the fragmentation.
> 
> I was wondering if something could be done in btrfs to improve
> performance under this workload... Something like a "defrag on demand"
> for a case where mostly appends are happening.

Instead of inventing a strategy smarter than the (already smart) filesystem, would be more simple make an explicit defrag ?

In any case this "smart strategy" is filesystem specific, so it would be more simple (and less error prone) do an explicit defrag.

I tried this strategy with systemd-journald, getting good results (doing a ioctl BTRFS_IOC_DEFRAG during the journal opening).

BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
