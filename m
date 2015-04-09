Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47926 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304AbbDILGn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 07:06:43 -0400
Date: Thu, 9 Apr 2015 19:06:32 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Paul Harvey <csirac2@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: unstable atimes on empty dirs in read-only snapshots which were
 subvol parents
Message-ID: <20150409110630.GB8979@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAB3_QuJVGezacw-yYqbfr2LHzF_Em4k1XFys02KMHemh1-sMsw@mail.gmail.com>
 <CAB3_QuJaTv_vt-eSaCyrLfmT3kfGFjJPgRJYkYwgh9JZ9KRO=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAB3_QuJaTv_vt-eSaCyrLfmT3kfGFjJPgRJYkYwgh9JZ9KRO=Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 06, 2015 at 12:03:59PM +1100, Paul Harvey wrote:
> Apparently in my haste, forgot to include any information in my email.
> This is also in the URL to the gist of my test script:
> 
> btrfs v3.17
> Linux 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt4-3 (2015-02-03) x86_64 GNU/Linux
> 
> # mount: /dev/loop2 mounted on /tmp/tmp.FkcW7fRde7.
> # Showing mount:
> # /tmp/tmp.1fbwCCdeNM on /tmp/tmp.FkcW7fRde7 type btrfs (rw,noatime,space_cache)
> # Create subvolume '/tmp/tmp.FkcW7fRde7/subvol'
> # mkdir: created directory ‘/tmp/tmp.FkcW7fRde7/snapshots’
> # mkdir: created directory ‘/tmp/tmp.FkcW7fRde7/empty_dir’
> # Create a readonly snapshot of '/tmp/tmp.FkcW7fRde7' in
> '/tmp/tmp.FkcW7fRde7/snapshots/1'
> # Testing that the subvol dir has stable atime on original parent FS:
> # Testing that '/tmp/tmp.FkcW7fRde7/subvol' has repeatable atime of
> #         2015-03-06T11:09:40+1100...
> # 1:      2015-03-06T11:09:40+1100
> # 2:      2015-03-06T11:09:40+1100
> #         PASS /tmp/tmp.FkcW7fRde7/subvol atime is stable :)
> # Testing that a normal empty dir has stable atime on the snapshot:
> # Testing that '/tmp/tmp.FkcW7fRde7/snapshots/1/empty_dir' has
> repeatable atime of
> #         2015-03-06T11:09:40+1100...
> # 1:      2015-03-06T11:09:40+1100
> # 2:      2015-03-06T11:09:40+1100
> #         PASS /tmp/tmp.FkcW7fRde7/snapshots/1/empty_dir atime is stable :)
> # Testing that the subvol dir has stable atime on snapshot of parent FS:
> # Testing that '/tmp/tmp.FkcW7fRde7/snapshots/1/subvol' has repeatable atime of
> #         2015-03-06T11:09:48+1100...
> # 1:      2015-03-06T11:09:50+1100
> # 2:      2015-03-06T11:09:52+1100
> #         FAIL /tmp/tmp.FkcW7fRde7/snapshots/1/subvol atime is unstable :(
> # './btrfs-atime-bug.sh nocleanup' not specified so cleaning up our mess:
> # umount: /tmp/tmp.FkcW7fRde7 unmounted
> # rmdir: removing directory, ‘/tmp/tmp.FkcW7fRde7’
> # removed ‘/tmp/tmp.1fbwCCdeNM’

Right, that's an intended behaviour because we'd like to avoid hardlink similar
problems, that is, to allow ONLY one valid access to 'subvol'.  Here btrfs
makes a pseudo 'subvol' with setting CURRENT_TIME to inode->atime/ctime/mtime,
that's why we see it's unstable.

Thanks,

-liubo
> 
> On 6 March 2015 at 11:29, Paul Harvey <csirac2@gmail.com> wrote:
> > Hi there,
> >
> > Apologies for not confirming on a much more recent kernel, if anyone
> > could please try my test script for me on a newer kernel that would be
> > very much appreciated.
> >
> > I'm working on reproducible builds, and part of this workflow involves
> > tar archiving parts of read-only btrfs snapshots. Problem is, some of
> > these tar archives are different from run to run when they capture an
> > empty directory that happened to be a subvol parent on the original
> > FS: the atimes on these empty dirs are always returning the current
> > time - which is not the case with an ordinary empty directory created
> > with mkdir; it's also not the same behaviour on the original FS (tar
> > archives are reproducible if we use the original FS rather than the
> > read-only snapshot). This all happens regardless of mounting noatime.
> >
> > Perhaps this verbiage is convoluted, I'm writing this in a hurry with
> > limited internet connectivity - I have a reproducible test case here
> > at https://gist.github.com/csirac2/c2b5b2b9d0193b3c08a8
> >
> > Again, I understand this is a pretty old kernel and perhaps this is
> > fixed by now, I'll try a more recent kernel with more assertive bug
> > report next week if nobody has time to try out my test case.
> >
> > Cheers
> >
> > --
> > Paul Harvey
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
