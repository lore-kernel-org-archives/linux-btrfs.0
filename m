From: Chris Samuel <chris@csamuel.org>
Subject: Re: Applications using fsync cause hangs for several seconds every
 few minutes
Date: Fri, 19 Aug 2011 17:34:08 +1000
Message-ID: <4E4E11F0.8050201@csamuel.org>
References: <4E41A6A4.9070702@uvm.edu> <4E4BCF0C.7060109@uvm.edu> <4E4BD05B.9070501@cchtml.com> <4E4CB59F.1070402@csamuel.org> <4E4CB807.8000602@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E4CB807.8000602@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 18/08/11 16:58, youagree wrote:

> Are these processes principally btrfs-submit and btrfs-transacti
> in particular?
> 
> Then it may be related to my very similar issue reported earlier.

I spent a little bit of time last night looking at it and it
seems that what I'm seeing also affects ext4 on my local SATA
mirror too, so whatever is going on doesn't appear to be
related to btrfs.  So ignore my comment.. ;-)

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
