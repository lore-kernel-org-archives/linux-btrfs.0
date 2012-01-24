From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs slowdown with ceph (how to reproduce)
Date: Tue, 24 Jan 2012 14:40:44 -0500
Message-ID: <20120124194044.GI4387@shiny>
References: <CAO47_-8Eb_v8X95KxSZ2H-DNC3hLZkrfq1ce3CAfW2G9CUV5gQ@mail.gmail.com>
 <20120123181928.GA3724@localhost.localdomain>
 <20120123185040.GH4387@shiny>
 <4F1F036E.9030801@tuxadero.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, Christian Brunner <chb@muc.de>,
	linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org
To: Martin Mailand <martin@tuxadero.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F1F036E.9030801@tuxadero.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 24, 2012 at 08:15:58PM +0100, Martin Mailand wrote:
> Hi
> I tried the branch on one of my ceph osd, and there is a big
> difference in the performance.
> The average request size stayed high, but after around a hour the
> kernel crashed.
> 
> IOstat
> http://pastebin.com/xjuriJ6J
> 
> Kernel trace
> http://pastebin.com/SYE95GgH

Aha, this I know how to fix.  Thanks for trying it out.

-chris
