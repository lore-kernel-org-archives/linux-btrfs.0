Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:36620 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbbBTWqz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Feb 2015 17:46:55 -0500
Received: by lbvp9 with SMTP id p9so9196635lbv.3
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Feb 2015 14:46:54 -0800 (PST)
MIME-Version: 1.0
From: Calvin Walton <calvin.walton@kepstin.ca>
Date: Fri, 20 Feb 2015 17:46:34 -0500
Message-ID: <CAF1iTguBBgEK++S9RcprrsB2VbQNpjfi6aZMD2X81mP66BVS4Q@mail.gmail.com>
Subject: Re: scrub problem
To: =?UTF-8?Q?Johan_Kr=C3=B6ckel?= <johan.kroeckel@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2015-02-20 at 20:59 +0100, Johan Kröckel wrote:
> The scrub is neither cancelable not stoppable. What is the problem?
>
> [ root@host]# btrfs scrub status ./
> scrub status for XXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXX
> scrub started at Thu Feb 19 12:41:22 2015, running for 16964 seconds
> total bytes scrubbed: 1.56TiB with 0 errors
> [ root@host]# btrfs scrub cancel ./
> ERROR: scrub cancel failed on ./: not running
> [ root@host]# btrfs scrub start ./
> ERROR: scrub is already running.
> To cancel use 'btrfs scrub cancel ./'.
> To see the status use 'btrfs scrub status [-d] ./'.

You don't say here which version of btrfs-progs you are using...

As Bob said, this issue is caused by a desynchronization between the
state file on the drive and the kernel state. However, code was added
to btrfs-progs 3.17 to detect and correct this condition.

I'd suggest updating your btrfs-progs.

-- 
Calvin Walton <calvin.walton@kepstin.ca>
