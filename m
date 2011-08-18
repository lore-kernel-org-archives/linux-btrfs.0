From: Chris Samuel <chris@csamuel.org>
Subject: Re: Applications using fsync cause hangs for several seconds every
 few minutes
Date: Thu, 18 Aug 2011 16:47:59 +1000
Message-ID: <4E4CB59F.1070402@csamuel.org>
References: <4E41A6A4.9070702@uvm.edu> <4E4BCF0C.7060109@uvm.edu> <4E4BD05B.9070501@cchtml.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Andrew Guertin <andrew.guertin@uvm.edu>,
	linux-btrfs@vger.kernel.org
To: Michael Cronenworth <mike@cchtml.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E4BD05B.9070501@cchtml.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 18/08/11 00:29, Michael Cronenworth wrote:

> I'm running kernel 3.0 (Fedora 15's 2.6.40) on two boxes
> and I have not seen slow downs or hangs. I use Firefox.

I've got btrfs on an external USB drive with the 3.0.1 kernel and
I see that sync seems to take an age, according to iotop it seems
that the btrfs processes are hitting it quite hard, IIRC.

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
