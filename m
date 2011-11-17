From: Arne Jansen <sensille@gmx.net>
Subject: Re: [RFC] improve space utilization on off-sized raid devices
Date: Thu, 17 Nov 2011 13:59:26 +0100
Message-ID: <4EC5052E.4040709@gmx.net>
References: <20111117002734.70530@gmx.net> <4EC4BAF8.1000407@gmx.net> <20111117115323.262060@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Thomas Schmidt <Schmidt-T@gmx.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111117115323.262060@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 17.11.2011 12:53, Thomas Schmidt wrote:
> 
>> On 17.11.2011 01:27, Thomas Schmidt wrote:
>> In your setup, it should stripe to all 8 devices until the 5 smaller ones
>> are full, and from then on stripe to the 3 remaining devices.
> 
> Afaik the behavior you describe is exactly the problem.
> It wants to continuing with 3 devices, but according to the code raid10
> requires 4.
> 

Right you are. So you want to sacrifice stripe size for space efficiency.
Why don't you just use RAID1?
Instead of reducing the stripe size for the majority of writes, I'd prefer
to allow RAID10 to go down to 2 disks. This should also solve it.
