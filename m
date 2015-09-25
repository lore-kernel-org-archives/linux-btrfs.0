Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:39509
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbbIYLFH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 07:05:07 -0400
Subject: Re: [PATCH] Btrfs: change how we wait for pending ordered extents
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <1443128161-31200-1-git-send-email-jbacik@fb.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <56052A60.5000105@googlemail.com>
Date: Fri, 25 Sep 2015 13:05:04 +0200
MIME-Version: 1.0
In-Reply-To: <1443128161-31200-1-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/24/15 22:56, Josef Bacik wrote:
> We have a mechanism to make sure we don't lose updates for ordered extents that
> were logged in the transaction that is currently running.  We add the ordered
> extent to a transaction list and then the transaction waits on all the ordered
> extents in that list.  However are substantially large file systems this list
> can be extremely large, and can give us soft lockups, since the ordered extents
> don't remove themselves from the list when they do complete.
> 
> To fix this we simply add a counter to the transaction that is incremented any
> time we have a logged extent that needs to be completed in the current
> transaction.  Then when the ordered extent finally completes it decrements the
> per transaction counter and wakes up the transaction if we are the last ones.
> This will eliminate the softlockup.  Thanks,

Tried this and unexpectedly didn't get any lockups or 'splosions during normal
operation, but balance now seems very slow and sits idle most of the time.

Running balance without filters on a previously balanced but empty fs:
$time btrfs filesystem balance start /mnt/usb
Done, had to relocate 3 out of 3 chunks
btrfs filesystem balance start /mnt/usb  0.01s user 0.00s system 0% cpu 1:00.91 total

On a completely new fs:
$mkfs.btrfs -L Test -msingle -dsingle -f /dev/sdf1
$mount /dev/sdf1 /mnt/usb
$time btrfs filesystem balance start /mnt/usb
Done, had to relocate 4 out of 4 chunks
btrfs filesystem balance start /mnt/usb  0.01s user 0.00s system 0% cpu 1:30.88 total

Time seems suspiciously in tune with (#chunks) * (tx commits every 30 seconds),
maybe needs a few more wakeups?

hope this helps :)

Holger

