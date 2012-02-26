From: Daniel Lee <longinus00@gmail.com>
Subject: Re: filesystem full when it's not?  out of inodes?  huh?
Date: Sun, 26 Feb 2012 11:37:55 -0800
Message-ID: <4F4A8A13.2070305@gmail.com>
References: <jic3e1$gpe$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <jic3e1$gpe$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/25/2012 05:55 PM, Brian J. Murrell wrote:
> $ btrfs filesystem df /usr
> Data: total=3.22GB, used=3.22GB
> System, DUP: total=8.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=896.00MB, used=251.62MB
> Metadata: total=8.00MB, used=0.00
>
> I don't know if that's useful or not.
>
> Any ideas?
>
> Cheers
> b.
3.22GB + (896MB * 2) = 5GB

There's no mystery here, you're simply out of space. The system df 
command basically doesn't understand btrfs so will erroneously report 
free space if there isn't any.

