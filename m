From: jim owens <jowens@hp.com>
Subject: Re: Some very basic questions
Date: Tue, 21 Oct 2008 16:08:29 -0400
Message-ID: <48FE36BD.6020701@hp.com>
References: <20081021173714.29505.qmail@splitreflection.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Stephan von Krawczynski <skraw@ithnet.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081021173714.29505.qmail@splitreflection.com>
List-ID: <linux-btrfs.vger.kernel.org>

calin wrote:
>> question is: if you had such an implementation, are there
>> drawbacks expectable for the single-mount case? If not I'd vote for it
>> because there are not really many alternatives "on the market".
> 
> As I understand it, the largest issue is in locking and boundaries. 

Correct, that is the first big issue.  As soon as 2 machines can
access the same device, you must design for distributed locking.
And that means a lot more code, lower performance, and a lot of
things a local-only filesystem could do that must be disallowed.

The second issue is what is the purpose of more than 1 host
accessing the data directly from the device.  There are cases
where this is a good thing because the application is designed
with data partitioning and multi-instance coordination.  It is
a bad thing for random uncoordinated use like backups or fsck.

Remember that the device bandwidth is the limiter so even
when each host has a dedicated path to the device (as in
dual port SAS or FC), that 2nd host cuts the throughput by
more than 1/2 with uncoordinated seeks and transfers.

And if the host device drivers are not designed for multiple
host sharing, this can cause timeouts, resets, and false
device-failed states.

And yes... even read-only access from a 2nd host is trouble
in many parts of the design and does not come for free.

jim
