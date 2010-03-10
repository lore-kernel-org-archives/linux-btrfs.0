From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs bug while defragmenting
Date: Wed, 10 Mar 2010 15:58:08 -0500
Message-ID: <20100310205808.GG4611@think>
References: <D09C8589-EA52-4778-8B29-1B06B27292D0@emc.com>
 <20100309192516.GQ15485@think>
 <B908B307-41C6-4F40-BD6B-451FDD32EF8B@emc.com>
 <D45A73CF-84B9-4814-970F-4CA4B66AE957@emc.com>
 <8C229A18-8B01-4F55-A020-659FDD531C35@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Philip Love <love_phil@emc.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <8C229A18-8B01-4F55-A020-659FDD531C35@emc.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 10, 2010 at 12:47:59PM -0800, Philip Love wrote:
> I obtained a similar error doing a large write to an ext3 filesystem, so there is another problem somewhere. Sorry for the inconvenience.
> Phil--

I was going to ask about memory corruptions because I couldn't trigger
this bug.  But, I did make a bunch of fixes to the defrag ioctl to fix
problems where it stalls.  So, thanks for sending this report along.

-chris
