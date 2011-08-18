From: youagree <n3ocort3x@gmail.com>
Subject: Re: Applications using fsync cause hangs for several seconds every
 few minutes
Date: Thu, 18 Aug 2011 08:58:15 +0200
Message-ID: <4E4CB807.8000602@gmail.com>
References: <4E41A6A4.9070702@uvm.edu> <4E4BCF0C.7060109@uvm.edu> <4E4BD05B.9070501@cchtml.com> <4E4CB59F.1070402@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E4CB59F.1070402@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Are these processes principally btrfs-submit and btrfs-transacti in
particular?

Then it may be related to my very similar issue reported earlier.

On 08/18/2011 08:47 AM, Chris Samuel wrote:
> On 18/08/11 00:29, Michael Cronenworth wrote:
> 
>> I'm running kernel 3.0 (Fedora 15's 2.6.40) on two boxes
>> and I have not seen slow downs or hangs. I use Firefox.
> 
> I've got btrfs on an external USB drive with the 3.0.1 kernel and
> I see that sync seems to take an age, according to iotop it seems
> that the btrfs processes are hitting it quite hard, IIRC.
> 
> cheers,
> Chris

