From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Poor performance with qemu
Date: Thu, 8 Apr 2010 11:32:13 -0400
Message-ID: <20100408153213.GJ1400@think>
References: <201003281718.03699.diegocg@gmail.com>
 <20100330125623.GB13190@think>
 <4BBDEF09.70306@redhat.com>
 <20100408152615.GI1400@think>
 <4BBDF636.5010002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Diego Calleja <diegocg@gmail.com>, linux-btrfs@vger.kernel.org
To: Avi Kivity <avi@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BBDF636.5010002@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 08, 2010 at 06:28:54PM +0300, Avi Kivity wrote:
> On 04/08/2010 06:26 PM, Chris Mason wrote:
> >>
> >>>Once the O_DIRECT read patch is in, you can switch to that, or tell qemu
> >>>to use a writeback cache instead.
> >>Even with writeback qemu will issue a lot of fsyncs.
> >Oh, I didn't see that when I was testing, when does it fsync?
> 
> When it updates qcow2 metadata or when the guest issues a barrier.
> It's relatively new.  I have a patch that introduces cache=volatile
> somewhere.

Ok, that's actually perfect.  I'll retest with that if I can get
qemu-git to work here.

-chris

