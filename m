From: Andrew Guertin <andrew.guertin@uvm.edu>
Subject: Re: Applications using fsync cause hangs for several seconds every
 few minutes
Date: Wed, 17 Aug 2011 10:38:42 -0400
Message-ID: <4E4BD272.8000704@uvm.edu>
References: <4E41A6A4.9070702@uvm.edu> <4E4BCF0C.7060109@uvm.edu> <4E4BD05B.9070501@cchtml.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Michael Cronenworth <mike@cchtml.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E4BD05B.9070501@cchtml.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/17/2011 10:29 AM, Michael Cronenworth wrote:
> Andrew Guertin on 08/17/2011 09:24 AM wrote:
>> I (and presumably others) haven't
>> been able to upgrade my kernel past 2.6.38 because of this.
> 
> I'm running kernel 3.0 (Fedora 15's 2.6.40) on two boxes and I have not
> seen slow downs or hangs. I use Firefox.

Well I'd expect it to be somewhat uncommon, or it wouldn't survive 3
kernel versions :) But at least 3 people have reported it, and for me at
least it's reliably reproducible enough to bisect, so I'm quite certain
there's something going on.

--Andrew
