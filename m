From: Piavlo <piavka@cs.bgu.ac.il>
Subject: Re: high cpu load for random write
Date: Wed, 01 Jul 2009 11:51:13 +0300
Message-ID: <4A4B2381.8050708@cs.bgu.ac.il>
References: <4A4A0AF1.9060107@cs.bgu.ac.il> <20090630134103.GB8345@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090630134103.GB8345@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> checksumming (which is constant for creating the file and for random
> writes) and the second is the cost of maintaining back references for
> the file data extent.
>
> In btrfs, we track the owners of each extent, which makes repair, volume
> management and other things much easier.  Small random writes make for a
> lot of extents, and so they also make for a lot of tracking.
>   
 I've no problem with high cpu load on dedicated storage servers, but it
does not seems right for desktop usage.
Please correct me if i'm wrong.
 
Alex
> In general, you'll find that mount -o ssd will be faster here, just
> because it forces the allocator into more sequential allocations for
> this workload.
>
> You'll find that mount -o nodatacow uses much less CPU time, but this
> disables checksumming and a few other advanced features.
>
> -chris
>   

