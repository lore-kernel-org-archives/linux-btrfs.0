Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35896 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754599AbdCGLzX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Mar 2017 06:55:23 -0500
Date: Tue, 7 Mar 2017 12:54:46 +0100
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs progs pre-release 4.10-rc1
Message-ID: <20170307115446.GR4662@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170302145947.14775-1-dsterba@suse.com>
 <35e4a389-f8aa-6da7-b971-607744ed8c44@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <35e4a389-f8aa-6da7-b971-607744ed8c44@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 07, 2017 at 11:03:33AM +0900, Tsutomu Itoh wrote:
> Hi David,
> 
> On 2017/03/02 23:59, David Sterba wrote:
> > Hi,
> > 
> > a pre-release has been tagged. There are patches that have queued so far, but
> > I haven't gone through everything that's in the mailinglist. The 4.10 release
> > ETA is next week so I'll try to process the backlog and merge what would seem
> > applicable.
> > 
> > Changes:
> >   * send: dump output fixes: missing newlies
> >   * check: several fixes for the lowmem mode, improved error reporting
> >   * build
> >     * removed some library deps for binaries that not use them
> >     * ctags, cscope
> >     * split Makefile to the autotool generated part and the rest, not needed
> >       to autogen.sh after adding a file
> >   * shared code: sync easy parts with kernel sources
> >   * other
> >     * lots of cleanups
> >     * source file reorganization: convert, mkfs, utils
> >     * lots of spelling fixes in docs, other updates
> >     * more tests
> > 
> > ETA for 4.10 is in +7 days (2017-03-08).
> > 
> > Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
> > Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
> > 
> > Shortlog:
> > 
> > Austin S. Hemmelgarn (1):
> >       btrfs-progs: better document btrfs receive security
> > 
> > Benedikt Morbach (1):
> >       btrfs-progs: send-dump: add missing newlines
> > 
> > David Sterba (102):
> 
> >       btrfs-progs: rework option parser to use getopt for global options
> 
> I think that btrfs/{008,016,019,...} of xfstests has failed due to the
> above patch.
> 
> btrfs/008 1s ... [failed, exit status 1] - output mismatch (see /xfstests/results//btrfs/008.out.bad)
>     --- tests/btrfs/008.out     2015-08-04 16:09:38.000000000 +0900
>     +++ /xfstests/results//btrfs/008.out.bad    2017-03-07 09:00:50.581906234 +0900
>     @@ -1,2 +1,3 @@
>      QA output created by 008
>     -Silence is golden
>     +send failed
>     +(see /xfstests/results//btrfs/008.full for details)

What's in the .full report?

>     ...
>     (Run 'diff -u tests/btrfs/008.out /xfstests/results//btrfs/008.out.bad'  to see the entire diff)
