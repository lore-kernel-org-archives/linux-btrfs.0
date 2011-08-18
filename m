From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Applications using fsync cause hangs for several seconds every few minutes
Date: Thu, 18 Aug 2011 10:38:25 -0400
Message-ID: <1313678278-sup-1155@shiny>
References: <4E41A6A4.9070702@uvm.edu> <4E447E2E.2070502@uvm.edu>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andrew Guertin <andrew.guertin@uvm.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4E447E2E.2070502@uvm.edu>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Andrew Guertin's message of 2011-08-11 21:13:18 -0400:
> On 08/09/2011 05:29 PM, Andrew Guertin wrote:
> > I have not tried 3.1-rc1, but plan to soon.
> 
> I've tested now, this does still occur in 3.1-rc1.

Ok, I had high hopes that the btrfs changes in rc1 would fix this.

Could you please try with the deadline elevator instead of the cfq
default?

-chris
