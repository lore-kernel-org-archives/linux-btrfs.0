Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:56842 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab3KYMzv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Nov 2013 07:55:51 -0500
Message-ID: <529348D4.8080105@jrs-s.net>
Date: Mon, 25 Nov 2013 07:55:48 -0500
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs scrub ioprio
References: <5292C7F7.8010200@jrs-s.net> <529341B5.8030600@gmail.com>
In-Reply-To: <529341B5.8030600@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Can you elaborate on this please?  I'm not directly familiar with 
cgroups, I'd greatly appreciate a quick-and-dirty example of using BIO 
cgroup to limit I/O bandwidth.

Limiting bandwidth definitely would ameliorate the problem for me; I 
already use pv's bw-limiting feature to make btrfs send | btrfs receive 
tolerable.

On 11/25/2013 07:25 AM, Austin S Hemmelgarn wrote:
> 2. allow the user to set a reasonable I/O bandwidth limit on the scrub 
> processes (you could already do this with the BIO cgroup, but it would 
> be nice to not need that to be compiled into the kernel to have this 
> happen) 

