Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:36364 "EHLO
	mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbcFDHYs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Jun 2016 03:24:48 -0400
Received: by mail-lf0-f44.google.com with SMTP id b73so66953024lfb.3
        for <linux-btrfs@vger.kernel.org>; Sat, 04 Jun 2016 00:24:47 -0700 (PDT)
Subject: Re: btrfs
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <1464819934.6742.71.camel@scientia.net>
 <d500a743-7a39-8ec5-c6ce-e5a3c70ede91@nv-systems.net>
 <1464975482.6679.11.camel@scientia.net>
 <6f18c0d1-8ac5-c325-0ba8-ffb949c54554@gmail.com>
 <1465005092.6648.39.camel@scientia.net>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <57528238.6080809@gmail.com>
Date: Sat, 4 Jun 2016 10:24:40 +0300
MIME-Version: 1.0
In-Reply-To: <1465005092.6648.39.camel@scientia.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

04.06.2016 04:51, Christoph Anton Mitterer пишет:
...
> 
>> The only extant systems that support higher
>> levels of replication and call it RAID-1 are entirely based on MD
>> RAID
>> and it's poor choice of naming.
> 
> Not true either, show me any single hardware RAID controller that does
> RAID1 in a dup2 fashion... I manage some >2PiB of storage at the
> faculty, all controller we have, handle RAID1 in the sense of "all
> disks mirrored".
> 

Out of curiosity - which model of hardware controllers? Those I am aware
of simply won't let you create RAID1 if more than 2 disks are selected.
