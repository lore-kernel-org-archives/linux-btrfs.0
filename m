From: Avi Kivity <avi@redhat.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 09:15:05 +0200
Message-ID: <48FED2F9.1060103@redhat.com>
References: <20081021173714.29505.qmail@splitreflection.com> <48FE36BD.6020701@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Stephan von Krawczynski <skraw@ithnet.com>,
	linux-btrfs@vger.kernel.org
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48FE36BD.6020701@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

jim owens wrote:
>
> Remember that the device bandwidth is the limiter so even
> when each host has a dedicated path to the device (as in
> dual port SAS or FC), that 2nd host cuts the throughput by
> more than 1/2 with uncoordinated seeks and transfers.

That's only a problem if there is a single shared device.  Since btrfs 
supports multiple devices, each host could own a device set and access 
from other hosts would be through the owner.  You would need RDMA to get 
reasonable performance and some kind of dual-porting to get high 
availability.  Each host could control the allocation tree for its devices.

Of course, this doesn't solve the other problems with parallel mounts.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

