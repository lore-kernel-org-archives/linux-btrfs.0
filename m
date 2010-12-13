From: Gordan Bobic <gordan@bobich.net>
Subject: Re: SSD optimizations
Date: Mon, 13 Dec 2010 17:47:36 +0000
Message-ID: <4D065C38.9030706@bobich.net>
References: <1292174654.11248.10.camel@paddy-desktop>	<4D05630E.7070809@bobich.net> <1292260671.11248.609.camel@paddy-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: jarktasaa@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1292260671.11248.609.camel@paddy-desktop>
List-ID: <linux-btrfs.vger.kernel.org>

On 13/12/2010 17:17, Paddy Steed wrote:

> So, no-one has any idea's on how to implement the cache. Would making it
> all swap work, does to OS cache files in swap?

No, it doesn't. I don't believe there are any plans to implement 
hierarchical storage in BTRFS, but perhaps one of the developers can 
confirm or deny that. As for how to do it - I don't have any ideas other 
than what I mentioned earlier (aufs to overlay file systems and cron 
jobs to rotate things in and out of cache).

Gordan
