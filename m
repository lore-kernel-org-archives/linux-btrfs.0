From: Anupam Garg <garga@soe.ucsc.edu>
Subject: Re: performance issues on btrfs after many snaps
Date: Thu, 2 Apr 2009 10:32:05 -0700
Message-ID: <8254822C-96EC-4185-920E-84C647E22672@soe.ucsc.edu>
References: <2DE16EF0-63DB-404A-8826-AA7A6AD535C4@soe.ucsc.edu> <1238692294.29739.7.camel@think.oraclecorp.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1238692294.29739.7.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

thanks chris.

>
> Is this a source base that I can try to reproduce these performance
> problems with?

no. unfortunately not.
I can give my workflow script (a few python lines).
Over the weekend, I'll try to switch it to build the linux kernel over  
consecutive changes.

>
> The first question would be why were the slower runs slower?  I'm
> assuming they need to read more off the disk, but capturing vmstat
> output during the fast and slow btrfs runs would help.

I'll reproduce the current experiment with vmstat output as well.

thanks much,
-anupam

