Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:59238 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366AbaA0ONY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 09:13:24 -0500
Message-ID: <52E669B1.1000401@jrs-s.net>
Date: Mon, 27 Jan 2014 09:14:09 -0500
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, KC <impactoria@googlemail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Snapshots =?UTF-8?B?4oCTIG5vb2IgcXVlc3Rpb25z?=
References: <52E664E0.5070909@gmail.com> <20140127140350.GL3314@carfax.org.uk>
In-Reply-To: <20140127140350.GL3314@carfax.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Well... you can't /create/ snapshots on different partitions / cloud 
storage / whatever, but you can certainly /send/ them there once you've 
created them.

Generally the best way to do this kind of thing is with incremental 
replication of snapshots to another btrfs filesystem, which may be local 
or cloud.

    you@box1:~$ sudo btrfs send /.snapshots/snapshot1 | ssh you@box2 
sudo btrfs receive /.snapshots

This sends the snapshot to the remote machine, where it will end up in 
/.snapshots.  This is a FULL send - you'll be sending a MB of data for 
every MB stored on disk locally.  But the next time:

    you@box1:~$ sudo btrfs send -p /.snapshots/snapshot1 
/.snapshots/snapshot2 | ssh you@box2 sudo btrfs receive /.snapshots

Assuming you still have a copy of snapshot1 on box2, the next time, you 
can do an INCREMENTAL send as shown above.  This tells btrfs send to use 
snapshot1 as a "parent" - which means it only sends the blocks in 
snapshot2 that are different from the blocks in snapshot1.  For example, 
this might be a filesystem with 500GB of data - but if you only changed 
10MB of that data between snapshot1 and snapshot2, you only have to send 
that 10MB of data to box2 with this incremental send.

Now you have snapshot1 and snapshot2 on both the local and the remote 
machine - and, best part, they're deduplicated, meaning that even though 
each snapshot is a fully browseable copy of your (example) 500GB of 
data, they only require (example) 500.01GB of storage - the 500GB of 
data they share in common, plus the 10MB of stuff that's different 
between snapshot1 and snapshot2.

On 01/27/2014 09:03 AM, Hugo Mills wrote:
>> 5. Can a snapshot be stored on a different partition? And if so,
>> does that partition have to be BTRFS too? I ask, because I would
>> also want to store snapshots in a cloud storage.
>     No, they can't.

