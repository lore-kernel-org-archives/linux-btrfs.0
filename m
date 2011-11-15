From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [PATCH 00/21] [RFC] Btrfs: restriper
Date: Tue, 15 Nov 2011 09:33:14 -0500
Message-ID: <4EC2782A.3050005@cfl.rr.com>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com> <4EC1AB52.2070805@cfl.rr.com> <20111115092224.GA8597@zambezi.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111115092224.GA8597@zambezi.lan>
List-ID: <linux-btrfs.vger.kernel.org>

On 11/15/2011 4:22 AM, Ilya Dryomov wrote:
> Restriper won't let you do raid1 ->  dup transition because dup is only
> allowed for a single-spindle FS, so you'll end up with error "btrfs:
> unable to start restripe ...".
>
> There is no way to prioritize disks during restripe.  To get dup back
> you'll have to convert everything to single, remove the second drive and
> then convert metadata from single to dup.

So there is no way to put a disk into read only mode and prevent 
allocations of new chunks there?

It seems like both of these limitations are highly undesirable when 
trying to recover from a failing disk.  You don't want any more data 
being written to the failing disk while you are trying to remove it, and 
you certainly don't want to drop back to a single copy of data that is 
then written to the failing disk.
