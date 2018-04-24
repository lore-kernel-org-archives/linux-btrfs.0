Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40771 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751295AbeDXL2L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 07:28:11 -0400
Date: Tue, 24 Apr 2018 13:25:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: dsterba@suse.cz, Rosen Penev <rosenp@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: treewide: Replace strerror(errno) with %m.
Message-ID: <20180424112537.GC21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1515362061-13281-1-git-send-email-rosenp@gmail.com>
 <20180123194216.GQ15713@twin.jikos.cz>
 <bebb46aa-7d60-a08a-037e-13a83276ceb4@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <bebb46aa-7d60-a08a-037e-13a83276ceb4@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 24, 2018 at 10:52:41AM +0800, Su Yue wrote:
> 
> 
> On 01/24/2018 03:42 AM, David Sterba wrote:
> > On Sun, Jan 07, 2018 at 01:54:21PM -0800, Rosen Penev wrote:
> >> As btrfs is specific to Linux, %m can be used instead of strerror(errno)
> >> in format strings. This has some size reduction benefits for embedded
> >> systems.
> > 
> > Makes sense.
> > 
> >> glibc, musl, and uclibc-ng all support %m as a modifier to printf.
> >> A quick glance at the BIONIC libc source indicates that it has
> >> support for %m as well. BSDs and Windows do not but I do believe
> >> them to be beyond the scope of btrfs-progs.
> > 
> > Thanks for checking the compatibility. The %m can be substituted
> > by a wrapper if this becomes a problem in the future.
> > 
> It seems a little problem in output now since it's not caused by this
> patch.
> 
> $ touch /tmp/tmp
> $ btrfs-image -r /tmp/tmp /tmp/test.img
> ERROR: unable to read cluster: Success

That's probably because there's also 0 in the condition (line 1967):

1966         ret = fread(cluster, BLOCK_SIZE, 1, mdres->in);
1967         if (ret <= 0) {
1968                 error("unable to read cluster: %m");
1969                 return -EIO;
1970         }
1971         ret = 0;

We'd need to distinguish the < 0 and == 0 cases, and in one we can use
the %m as the errno will be set.
