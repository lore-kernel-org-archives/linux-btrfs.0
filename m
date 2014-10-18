Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-11v.sys.comcast.net ([69.252.207.43]:60198 "EHLO
	resqmta-ch2-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751186AbaJRQCT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Oct 2014 12:02:19 -0400
Message-ID: <54428F04.70805@pobox.com>
Date: Sat, 18 Oct 2014 09:02:12 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Paul Jones <paul@pauljones.id.au>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: 3.17.1 blocked task (several observations about when I first
 encountered this. 8-)
References: <B7F2379062E32745A8651FBDB20F64593B0C9CF2@Server.waterlogic.com.au>
In-Reply-To: <B7F2379062E32745A8651FBDB20F64593B0C9CF2@Server.waterlogic.com.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/18/2014 05:00 AM, Paul Jones wrote:
> Just found this stack trace in dmesg while running a scrub on one of my file systems. I haven’t seen this reported yet so I thought I should report it ☺
> All filesystems are raid1.
 > ...
> [ 5396.970316] INFO: task kworker/u16:8:7540 blocked for more than 120 seconds.
> [ 5396.970318]       Not tainted 3.17.1-gentoo-r1 #1
> [ 5396.970319] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 5396.970319] kworker/u16:8   D ffff880302e4a2a0     0  7540      2 0x00000000
> [ 5396.970325] Workqueue: writeback bdi_writeback_workfn (flush-btrfs-3)
 > ...

(1) This backtrace is harmless in terms of system integrity. It is 
purely advisory. As it says in the message "echo 0 > /proc/sys/..." to 
disable this message.

(2) I reported a similarly long transaction on the first mount of a 
BTRFS image that I'd just converted from EXT4, thinking it was an error.

(3) I'd destroyed my system by thininking this panic-looking backtrace 
was actually a panic and resetting my box because _I_ paniced. /doh! 
[the system was building the initial csum tree or something and turning 
it off during that made an unrecoverable mess. having only part of your 
csum tree, it turns out, is "bad". I saved my data by doing a "btrfs 
restore".]

(4) someone else had to point out to me that the message was purely 
informative and that its emission doesn't affect process outcome at all.

The lessons I learned:

BTRFS _can_ do some _very_ time consuming things in "one transaction" 
and the kernel's "you might want to take a look at this task" timer is 
set to consider things like "one over-long write to device" as "one 
action" as compared to, say, creating an entire csum tree.

Don't panic, and _don't_ turn off your box. (which used to be a good 
ting to do if fsck was eating a partition back before ext3, but old man 
reflexes can be wrong now-a-days 8-).

The "info" stack traces need to look a lot less like the "panic" stack 
traces... 8-)

TL;DR :: the above is almost certainly the result of the scrub doing 
something particularly arduous but correct, or another transaction 
correctly waiting for the scrub to finish with a particular resource.

-- Rob.


