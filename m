Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay06.libero.it ([212.52.84.110]:51699 "EHLO
	outrelay06.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaFPQ3A (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 12:29:00 -0400
Message-ID: <539F1C35.6060302@inwind.it>
Date: Mon, 16 Jun 2014 18:32:53 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Lennart Poettering <lennart@poettering.net>
CC: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org,
        systemd-devel@lists.freedesktop.org
Subject: Re: [systemd-devel] Slow startup of systemd-journal on BTRFS
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost> <pan$22693$6b452195$976b783a$e4956372@cox.net> <20140612232453.GR9508@dastard> <539B78F3.9070607@libero.it> <pan$625ac$a8aa7477$d0179ebe$c66ba817@cox.net> <539BFF47.8060006@libero.it> <20140615221307.GE24386@tango.0pointer.de>
In-Reply-To: <20140615221307.GE24386@tango.0pointer.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Lennart,

On 06/16/2014 12:13 AM, Lennart Poettering wrote:
> I am not really following though why this trips up btrfs though. I am
> not sure I understand why this breaks btrfs COW behaviour. I mean,
> fallocate() isn't necessarily supposed to write anything really, it's
> mostly about allocating disk space in advance. I would claim that
> journald's usage of it is very much within the entire reason why it
> exists...

I performed several tests, trying different setups [1]. One of these was replacing the posix_fallocate() with a truncate, to check where is the problem. The conclusion was that *posix_fallocate() is NOT the problem*.

In another reply you stated that systemd-journald appends some data at the end of file, then update some data in the middle. I think this is the reason because the file becomes quickly fragmented.


[1] Let me to revise the english, the I will post the results.


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
