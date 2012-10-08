Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:49748 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542Ab2JHQbZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Oct 2012 12:31:25 -0400
Date: Mon, 8 Oct 2012 12:31:22 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS, getting darn slower everyday
Message-ID: <20121008163122.GB2259@localhost.localdomain>
References: <50714AC8.4010100@petaramesh.org>
 <20121008160933.GA2259@localhost.localdomain>
 <5072FC37.8090105@petaramesh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <5072FC37.8090105@petaramesh.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 08, 2012 at 10:15:51AM -0600, Swâmi Petaramesh wrote:
> Le 08/10/2012 18:09, Josef Bacik a écrit :
> > Can you get sysrq+w when you are seeing slowness?  Usually bootup slow times
> > means you don't have space_cache enabled or your cache is being evicted for some
> > reason, can you check dmesg after bootup for messages related to space cache?
> > Thanks,
>  I have a few :
> 
> Oct  8 15:27:26 tethys kernel: [16174.736603] btrfs: free space inode
> generation (0) did not match free space cache generation (106988)
> Oct  8 15:27:27 tethys kernel: [16175.976784] btrfs: free space inode
> generation (0) did not match free space cache generation (30727)
> Oct  8 15:27:28 tethys kernel: [16176.420719] btrfs: free space inode
> generation (0) did not match free space cache generation (48040)
> Oct  8 15:27:28 tethys kernel: [16176.710972] btrfs: free space inode
> generation (0) did not match free space cache generation (30745)
> 
> ...in syslog, but that's about all... and not during boot...
> 
> I used to have much much more of these in syslog, but solved it by
> booting once with the "clear_cache" option, that caused boot to be
> extremely slow, but seemed to fix it...
> 
> (Remember I have such issues on several machines, it is highly
> improbable that all of them would get their cache ignored...?)

Well what happens is on a actually used fs it ends up being more fragmented than
the amount we're allowed to preallocate for our space cache, and so we don't
write anything out, so it's very likely that all of your machines could be
hitting that.  I put a patch into 3.6 to increase the cache size so that
wouldn't happen as much, perhaps move to 3.6 and see if you see some
improvements?  Thanks,

Josef
