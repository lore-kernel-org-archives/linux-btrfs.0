From: "K. Richard Pixley" <rich@noir.com>
Subject: Re: remote mirroring in the works?
Date: Mon, 30 Aug 2010 11:14:51 -0700
Message-ID: <4C7BF51B.2070201@noir.com>
References: <29385727.6.1283191163871.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org, Fred van Zwieten <fvzwieten@gmail.com>
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <29385727.6.1283191163871.JavaMail.root@zimbra>
List-ID: <linux-btrfs.vger.kernel.org>

  On 20100830 10:59, Roy Sigurd Karlsbakk wrote:
>> I think drbd does precisely what you want.
>>
>> It's not useful for fault tolerance, nor for load balancing, but it
>> will
>> produce a remote block copy that can be used as a sort of "hot
>> backup".
> drbd with heartbeat/pacemaker can provide fault tolerance...
I think that's a matter of semantics.

Once you've failed over from the primary system to the secondary, 
changes to your block device are terminal.  It's not easy to produce a 
system which can manage those changes and "heal" in the sense of 
allowing the primary system to return to service.  In effect, returning 
the primary system to service requires taking both systems down and 
copying the block device from the secondary back to the first.

In terms of fault tolerance, I'd call this a tolerance of about a half a 
fault since the system cannot return to it's initial configuration 
without breaking continuity of service.

And there really isn't any way to extend this. It's not fault tolerance 
in the virtual synchrony sense where there can be a pool of N machines, 
all symmetric, which can tolerate N - 1 failures and produce continuing 
service throughout.

It's also not load balanced in the virtual synchrony sense where N 
machines can all be in service concurrently and the service can tolerate 
N - 1 failures, albeit at degraded performance.  Or in the sense where 
failed servers can return to the group dynamically.

It's not sufficient for any application in which I've ever sought fault 
tolerance.  If it's sufficient for you, that's great.  But my definition 
of "fault tolerance" requires that the system be capable of returning to 
it's initial state without loss of service.  The heartbeat approach with 
single failover can't do that.

--rich - who is likely now off topic.
