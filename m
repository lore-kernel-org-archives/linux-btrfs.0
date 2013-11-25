Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:40439 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab3KYNFg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Nov 2013 08:05:36 -0500
Received: by mail-ie0-f180.google.com with SMTP id tp5so6579435ieb.39
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Nov 2013 05:05:36 -0800 (PST)
Message-ID: <52934B1E.9080205@gmail.com>
Date: Mon, 25 Nov 2013 08:05:34 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Jim Salter <jim@jrs-s.net>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs scrub ioprio
References: <5292C7F7.8010200@jrs-s.net> <529341B5.8030600@gmail.com> <529348D4.8080105@jrs-s.net>
In-Reply-To: <529348D4.8080105@jrs-s.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013-11-25 07:55, Jim Salter wrote:
> Can you elaborate on this please?  I'm not directly familiar with
> cgroups, I'd greatly appreciate a quick-and-dirty example of using BIO
> cgroup to limit I/O bandwidth.
> 
> Limiting bandwidth definitely would ameliorate the problem for me; I
> already use pv's bw-limiting feature to make btrfs send | btrfs receive
> tolerable.
> 
> On 11/25/2013 07:25 AM, Austin S Hemmelgarn wrote:
>> 2. allow the user to set a reasonable I/O bandwidth limit on the scrub
>> processes (you could already do this with the BIO cgroup, but it would
>> be nice to not need that to be compiled into the kernel to have this
>> happen) 
> 
I'm not very clear on the specifics, (the only cgroup I personally use
with any regularity is freezer), but I would suggest looking at
Documentation/cgroups/blkio-controller.txt in the kernel source tree
(cgroups are one of the better subsystems WRT documentation).  I'm
pretty certain that most distributions have the required kernel options
compiled in by default, and automatically mount the needed filesystems.
