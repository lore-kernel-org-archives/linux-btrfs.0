Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bn1bon0146.outbound.protection.outlook.com ([157.56.111.146]:34788
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752920AbbBRSFK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Feb 2015 13:05:10 -0500
From: Steven Schlansker <sschlansker@opentable.com>
To: Omar Sandoval <osandov@osandov.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Forever blocked in bit_wait with kernel 3.19
Date: Wed, 18 Feb 2015 17:49:09 +0000
Message-ID: <EAACB1FB-AEBD-4ABC-B190-620C1D64EE3C@opentable.com>
References: <9E2DE950-1434-424B-974C-2ABE4BD22EE5@opentable.com>
 <20150218062629.GA18372@mew>
In-Reply-To: <20150218062629.GA18372@mew>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 17, 2015, at 10:26 PM, Omar Sandoval <osandov@osandov.com> wrote:

> On Thu, Feb 12, 2015 at 11:12:25AM +0000, Steven Schlansker wrote:
>> [ Please CC me on replies, I'm not on the list ]
>> [ This is a followup to http://www.spinics.net/lists/linux-btrfs/msg41496.html ]
>> 
>> Hello linux-btrfs,
>> I've been having troubles keeping my Apache Mesos / Docker slave nodes stable.  After some period of load, tasks begin to hang.  Once this happens task after task ends up waiting at the same point, never to return.  The system quickly becomes unusable and must be terminated.
> 
> Are you seeing any ENOMEM Btrfs-related errors in your dmesg? In your
> previous thread you trigged an ENOMEM BUG_ON and you mentioned that your
> containers often get OOM'ed.

Correct, the containers OOM relatively frequently.  We're working on fixing this but accidents happen and we're doing heavy development with memory-hungry services.

I've not observed any BTRFS complaints about memory; I'd assumed that it would be allocating outside of any container limits.  But I don't know how e.g. that interacts with page cache accounting.

> 
> I experimented with Btrfs in a memory-constrained cgroup and saw all
> sorts of buggy behavior (https://lkml.org/lkml/2015/2/17/131), but I
> haven't been able to reproduce this particular issue. This is a wild
> guess, but there could be a buggy error handling path somewhere that
> forgets to unlock a page.

That seems like a very reasonable explanation.  Is there any particular debugging I could provide to diagnose this?  I can't reproduce it on demand but it's only a matter of time until it happens again...  And I'd like to help contribute to fixing it, but I'm not much of a filesystem developer :)

