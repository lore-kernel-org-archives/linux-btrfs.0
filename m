From: Chris Ball <cjb@laptop.org>
Subject: Re: zero-length files in snapshots
Date: Fri, 12 Feb 2010 14:03:03 -0500
Message-ID: <m3hbpmxons.fsf@pullcord.laptop.org>
References: <12b5f1ef1002111749u4f33b626jb6a901b29f05337f@mail.gmail.com>
	<m38wazywow.fsf@pullcord.laptop.org>
	<93cdabd21002112050x795ab5e2s9bcd426f19032f8c@mail.gmail.com>
	<20100212151940.GA4191@localhost.localdomain>
	<4B759C54.8050907@p-static.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Ravi Pinjala <ravi@p-static.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B759C54.8050907@p-static.net> (Ravi Pinjala's message of "Fri,
	12 Feb 2010 12:22:12 -0600")
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

   > Is there a race in there? It seems like if a process starts
   > modifying a file between the sync and the snapshot, data could
   > still be lost. Is there something else going on here that I'm
   > missing that would prevent this race?

AIUI, you're correct that a writer process concurrent to a snapshot
leads to a race with data that doesn't make it in to the snapshot, but
I think you're wrong in thinking that there's much we could do about
it -- either you miss writes between sync and snapshot, as we do now,
or we do sync-and-snapshot atomically, and the concurrent writes are
missed because we decided to block further writes from that process
before we took the snapshot.  The only real answer is to quiesce the
writer process before you begin.  Does that make sense?

- Chris.
-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
