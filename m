From: Patrick Goetz <pgoetz@math.utexas.edu>
Subject: Re: Atomicity or the ext4 open-write-close-rename debacle
Date: Wed, 08 Apr 2009 13:28:37 -0500
Message-ID: <49DCECD5.3030801@math.utexas.edu>
References: <49DCC0FD.3010200@math.utexas.edu> <1239208095.22111.4.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1239208095.22111.4.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> 
> With 2.6.30, extra ordering is added to btrfs, making sure that metadata
> and data are both atomically replaced during a rename.  In other words,
> for renames it will work like ext3 data=ordered mode.
> 

Thanks for the speedy response.

After spending several hours slogging through the discussion on Ted 
Tso's blog and spending much more time than anticipated learning about 
FUA, write barriers, fsync vs. fdatasync, how fsync is implemented in 
linux, etc., I'm curious about the technical details of how this is 
accomplished.  Any place where I can find this short of reading through 
the source code?



