Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:33105 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115Ab2FNJwf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 05:52:35 -0400
Date: Thu, 14 Jun 2012 11:52:32 +0200
From: David Sterba <dave@jikos.cz>
To: Arne Jansen <sensille@gmx.net>
Cc: Jordan Windsor <jordanw2@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Question, Does BTRFS provide a read speed increase with RAID1
Message-ID: <20120614095232.GL32402@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <CACCfv7q83FYmrcVO3TwMwX2HmNZpkdO=uJOTtR1X9E7_wUWz9w@mail.gmail.com>
 <4FD9AAA0.2040802@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FD9AAA0.2040802@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 14, 2012 at 11:10:56AM +0200, Arne Jansen wrote:
> On 14.06.2012 11:08, Jordan Windsor wrote:
> > Hello,
> > I was wondering if I setup a array via BTRFS as RAID1 will I get a
> > read speed increase? (multiplied by the amount of harddrives)
> 
> Only if you read from multiple processes (or threads). Currently
> the lowest-order bit of the pid is used to choose the mirror to
> read from.

I've experimented with it once and came up with this simple change to
rotate the mirror

http://www.spinics.net/lists/linux-btrfs/msg12745.html

it does not select the mirror by pid but "rotating" on each mirror
request, but I did not bring any numbers and the implementation is not
clean (it uses a single static variable for all fses etc., but it works
for testing), so the patch fell on the floor.

Picking it up again later to get some more insight if it's the right
heuristic I did preliminary tests on 2 disks in raid1 and modified the
rotor hint from

   rotor++ % mirrors

to

   (rotor++ >> SHIFT) % mirrors

The numbers measured on a light 'copy large file' load showed that the
original simple increment is awfully bad, the bandwidth used was like
15/60 MB/s .

Varying SHIFT, I recorded these numbers:
SHIFT   throughput    time
2               28    1:45
3               33    1:33
4               40    1:16
5               42    1:11
6               50    1:02
7               52    1:00
8               51    1:06
9               38    1:18

So there's probably some achievable improvement, but in this testcase
the batched requestes per mirror are helping the (sequential) write too
much. It would need more testing on more disks, other types of loads
etc. And iirc as you noted on IRC back then, this mirror selection
should be adapted according to disk head position or connected to the
readahead framework (sorry if I'm not writing exactly as you put it).

In current implementation, a pathological case, when all the processes
get the same "pid % 2", would lead to an unused mirror, but it's highly
improbable (note that it's not pid of the user process doing the read,
but the btrfs worker threads).

I'd like to find a better mirror selection hint that would work well on
avearage and will get back to it someday, unless somebody else wants to
continue experimenting here.


david
