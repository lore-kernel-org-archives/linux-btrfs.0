From: Avi Kivity <avi@redhat.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 16:25:05 +0200
Message-ID: <48FF37C1.1010001@redhat.com>
References: <20081021173714.29505.qmail@splitreflection.com> <48FE36BD.6020701@hp.com> <48FED2F9.1060103@redhat.com> <48FF3520.2000308@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Stephan von Krawczynski <skraw@ithnet.com>,
	linux-btrfs@vger.kernel.org
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48FF3520.2000308@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

jim owens wrote:
> Avi Kivity wrote:
>> jim owens wrote:
>>>
>>> Remember that the device bandwidth is the limiter so even
>>> when each host has a dedicated path to the device (as in
>>> dual port SAS or FC), that 2nd host cuts the throughput by
>>> more than 1/2 with uncoordinated seeks and transfers.
>>
>> That's only a problem if there is a single shared device.  Since 
>> btrfs supports multiple devices, each host could own a device set and 
>> access from other hosts would be through the owner.  You would need 
>> RDMA to get reasonable performance and some kind of dual-porting to 
>> get high availability.  Each host could control the allocation tree 
>> for its devices.
>
> No.  Every device including a monster $$$ array has the problem.
>
> As I said before, unless the application is partitioned
> there is always data host2 needs from host1's disk and that
> slows down host1.

The CPU load should not be significant if you have RDMA.  Or are you 
talking about the seek load?  Since host1's load should be distributed 
over all devices in the system, overall seek capacity increases as you 
add more nodes.

>
> If host2 seldom needs any host1 data, then you are describing
> a configuration that can be done easily by each host having a
> separate filesystem for the device it owns by default.  Each
> host nfs mounts the other host's data and if host1 fails, host2
> can direct mount host1-fs from the shared array.
>

Separate namespaces are uninteresting to me.  That's just pushing back 
the problem to the user.

> Even with multiple disks under the same filesystem as separate
> allocated storage there is still the problem of shared namespace
> metadata that slows down both hosts.  If you don't need shared
> namespaces then you absolutely don't want a cluster fs.
>

If you separate the allocation metadata to the storage owning node, and 
the file metadata to the actively using node, the slowdown should be low 
in most cases.  Problems begin when all nodes access the same file, but 
that's relatively rare.  Even then, when the file size does not change 
and when the data is preallocated, it's possible to achieve acceptable 
overhead.

> A cluster fs is useful, but the cost can be high so using
> it for a single-host fs is not a good idea.

Development costs, yes.  But I don't see why the runtime overhead can't 
disappear when running on a single host.  Sort of like running an smp 
kernel on uniprocessor (I agree the fs problem is much bigger).

-- 
error compiling committee.c: too many arguments to function

