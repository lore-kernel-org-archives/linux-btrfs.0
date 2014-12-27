Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-03v.sys.comcast.net ([69.252.207.35]:55981 "EHLO
	resqmta-ch2-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751072AbaL0OAw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Dec 2014 09:00:52 -0500
Message-ID: <549EBB90.5070406@pobox.com>
Date: Sat, 27 Dec 2014 06:00:48 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
References: <3738341.y7uRQFcLJH@merkaba> <3538352.CI4nobbHtu@merkaba> <549E9D98.7010102@pobox.com> <9534911.qSQhRgc3Jg@merkaba>
In-Reply-To: <9534911.qSQhRgc3Jg@merkaba>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/27/2014 05:16 AM, Martin Steigerwald wrote:
> It can easily be reproduced without even using Virtualbox, just by a nice
> simple fio job.
>

TL;DR: If you want a worst-case example of consuming a BTRFS filesystem 
with one single file...

#!/bin/bash
# not tested, so correct any syntax errors
typeset -i counter
for ((counter=250;counter>0;counter--)); do
  dd if=/dev/urandom of=/some/file bs=4k count=$counter
done
exit


Each pass over /some/file is 4k shorter than the previous one, but none 
of the extents can be deallocated. File will be 1MiB in size and usage 
will be something like 125.5MiB (if I've done the math correctly). 
larger values of counter will result in exponentially larger amounts of 
waste.

Doing the bad things is very bad...
