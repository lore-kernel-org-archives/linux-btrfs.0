Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay06.libero.it ([212.52.84.110]:46785 "EHLO
	outrelay06.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309AbaFPSnt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 14:43:49 -0400
Message-ID: <539F3BD5.6080700@libero.it>
Date: Mon, 16 Jun 2014 20:47:49 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
CC: Lennart Poettering <lennart@poettering.net>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org, systemd-devel@lists.freedesktop.org,
        Kai Krakow <hurikhan77@gmail.com>
Subject: Re: [systemd-devel] Slow startup of systemd-journal on BTRFS
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost> <pan$22693$6b452195$976b783a$e4956372@cox.net> <20140612232453.GR9508@dastard> <539B78F3.9070607@libero.it> <pan$625ac$a8aa7477$d0179ebe$c66ba817@cox.net> <539BFF47.8060006@libero.it> <20140615221307.GE24386@tango.0pointer.de> <539F1C35.6060302@inwind.it>
In-Reply-To: <539F1C35.6060302@inwind.it>
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

in this blog [1] I collected all the results of the tests which I performed in order to investigate a bit this performance problem between systemd and btrfs. I had to put these results in a blog, because there are several images. Below a brief summary.

I took an old machine (a P4 2.5GHz with 512MB of ram) where was present a fresh installation of a Fedora 20 and I measured the boot time during several reboots (up to 70).  I tested the following scenarios

1) standard (without defragmenting any file, without readahead)
2) defragment the journal file at the end of the boot
3) defragment the journal file before the flushing
4) mark as NOCOW the journald log file
5) enable the systemd-readahead
6) remove the fsync(2) call from journald
7) remove the posix_fallocate(3) call from journald
8) do a defrag when posix_fallocate(3) is called
9) do a defrag when the journal log file is opened

The test #1 highlight the problem. It shows that the boot time may require up to 50 seconds. During the reboots the number of extents of the file system.journal increases up to 6000. De-fragmenting the system.journal file the boot time decreases by ~20 seconds. My conclusion is that in BTRFS the fragmentation of this file increases the boot time.

The test #6 and #7 suggested that the fsync(2) amd posix_fallocate(3) calls aren't the root cause of the problem. Even without these the system.journal file still fragments.

The test #4 suggested that marking NOCOW the system.journal file reduces its fragmentation and so the boot time.

The test #2,#3,#9 suggested that performing a periodic defrag reduces significantly the fragmentation of system.journal and so the boot time.

The test #5 revealed that the readahead capability of systemd was not efficacy because it seems that the system.journal file was unaffected (but other *.journal files were). Further investigation is required.

BR
G.Baroncelli



[1] http://kreijack.blogspot.it/2014/06/btrfs-and-systemd-journal.html

On 06/16/2014 06:32 PM, Goffredo Baroncelli wrote:
> Hi Lennart,
> 
> On 06/16/2014 12:13 AM, Lennart Poettering wrote:
>> I am not really following though why this trips up btrfs though. I am
>> not sure I understand why this breaks btrfs COW behaviour. I mean,
>> fallocate() isn't necessarily supposed to write anything really, it's
>> mostly about allocating disk space in advance. I would claim that
>> journald's usage of it is very much within the entire reason why it
>> exists...
> 
> I performed several tests, trying different setups [1]. One of these was replacing the posix_fallocate() with a truncate, to check where is the problem. The conclusion was that *posix_fallocate() is NOT the problem*.
> 
> In another reply you stated that systemd-journald appends some data at the end of file, then update some data in the middle. I think this is the reason because the file becomes quickly fragmented.
> 
> 
> [1] Let me to revise the english, the I will post the results.
> 
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
