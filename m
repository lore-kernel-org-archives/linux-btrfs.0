From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [RFC] improve space utilization on off-sized raid devices
Date: Thu, 17 Nov 2011 13:27:41 -0500
Message-ID: <4EC5521D.1020209@cfl.rr.com>
References: <20111117002734.70530@gmx.net> <4EC4BAF8.1000407@gmx.net> <20111117115323.262060@gmx.net> <4EC5052E.4040709@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Thomas Schmidt <Schmidt-T@gmx.de>, linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EC5052E.4040709@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 11/17/2011 7:59 AM, Arne Jansen wrote:
> Right you are. So you want to sacrifice stripe size for space efficiency.
> Why don't you just use RAID1?
> Instead of reducing the stripe size for the majority of writes, I'd prefer
> to allow RAID10 to go down to 2 disks. This should also solve it.

Yes, it appears that btrfs's current idea of raid10 is actually raid0+1, 
not raid10.  If it were proper raid10, it could use the remaining space 
on the 3 larger disks for a raid10 metadata chunk.

