From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] xfstests: fix 251's cp -axT problem
Date: Wed, 11 Jan 2012 13:14:29 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1201111310060.5636@dhcp-27-109.brq.redhat.com>
References: <1326195560-4434-1-git-send-email-liubo2009@cn.fujitsu.com> <20120111114544.GE14423@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Liu Bo <liubo2009@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com, Lukas Czerner <lczerner@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120111114544.GE14423@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 11 Jan 2012, Christoph Hellwig wrote:

> On Tue, Jan 10, 2012 at 07:39:20PM +0800, Liu Bo wrote:
> > When I ran xfstests, 251 got failed cause "cp -axT" did not work as wish:
> > cp: cannot overwrite directory `/mnt/scratch/1' with non-directory
> > 
> > With this patch, 251 has passed.
> 
> Why would cp give that message with a missing /?
> 
> I'm not against putting this in, but I'd like to understand what's going
> on.
> 
> Lukas, any idea?
> 

Hi Christoph,

the only reason I can think of is probably that Liu is accessing the
xfstests directory via symbolic link, hence the '$content' addresses the
symbolic link and cp is trying to overwrite the directory with
non-directory (symlink).

The fix is fine for both cases (xfstests as symlink and directory), confirmed
with a simple test.

Thanks!
-Lukas
