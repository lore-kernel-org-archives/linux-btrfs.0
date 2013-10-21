Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from glockenspiel.complete.org ([78.47.53.23]:35266 "EHLO
	glockenspiel.complete.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab3JUDk2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Oct 2013 23:40:28 -0400
Message-ID: <5264A221.2020509@complete.org>
Date: Sun, 20 Oct 2013 22:40:17 -0500
From: John Goerzen <jgoerzen@complete.org>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Lots of trouble hanging when rm files with many extents
References: <20131020235118.3a918ba3@virtall.com>
In-Reply-To: <20131020235118.3a918ba3@virtall.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/20/2013 09:51 AM, Tomasz Chmielewski wrote:
>> but I am not sure if that was the right thing to do.  This is
>> producing OOM issues and leading to system crashes (including
>> eventual panics) with such alarming frequency that I wonder if
>> perhaps there is something different about my setup than others.
> FYI, I'm seeing similar / random hangs on systems with btrfs,
> compress-force=zlib, qgroups enabled. The systems have 32 GB RAM.
> Sometimes, I can review old logs (after force reboot) and see OOM,
> allocation failures and such.
>
> The scenario there are snapshots, rsync with --inplace flag, which can
> fragment files a lot.
>
> I'll do some more tests with lots of extents to see if it's
> reproducible here as well.
>
>
Interestingly, I've generally had qgroups enabled here as well, possibly 
on all of these systems.  Could that be the culprit?
