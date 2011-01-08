From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Atomic file data replace API
Date: Fri, 07 Jan 2011 20:11:04 -0500
Message-ID: <4D27B9A8.3020804@cfl.rr.com>
References: <AANLkTi=paCEdAFZkHWTSwTCjYavMPOaGY8MsLknryk=_@mail.gmail.com> <1294412141-sup-1734@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Olaf van der Spek <olafvdspek@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1294412141-sup-1734@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/07/2011 09:58 AM, Chris Mason wrote:
> Yes and no.  We have a best effort mechanism where we try to guess that
> since you've done this truncate and the write that you want the writes
> to show up quickly.  But its a guess.

It is a pretty good guess, and one that the NT kernel has been making 
for 15 years or so.  I've been following this issue for some time and I 
still don't understand why Ted is so hostile to this and can't make it 
work right on ext4.  When you get a rename() you just need to check if 
there are outstanding journal transactions and/or dirty cache pages, and 
hang the rename() transaction on the end of those.  That way if the 
system crashes after the new file has fully hit the disk, the old file 
is gone and you only have the new one, but if it crashes before, you 
still have the old one in place.

Both the writes and the rename can be delayed in the cache to an 
arbitrary point in the future; what matters is that their order is 
preserved.
