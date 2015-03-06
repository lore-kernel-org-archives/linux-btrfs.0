Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:33384 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbbCFBEU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Mar 2015 20:04:20 -0500
Received: by iecar1 with SMTP id ar1so81743572iec.0
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Mar 2015 17:04:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB3_QuJVGezacw-yYqbfr2LHzF_Em4k1XFys02KMHemh1-sMsw@mail.gmail.com>
References: <CAB3_QuJVGezacw-yYqbfr2LHzF_Em4k1XFys02KMHemh1-sMsw@mail.gmail.com>
From: Paul Harvey <csirac2@gmail.com>
Date: Fri, 6 Mar 2015 12:03:59 +1100
Message-ID: <CAB3_QuJaTv_vt-eSaCyrLfmT3kfGFjJPgRJYkYwgh9JZ9KRO=Q@mail.gmail.com>
Subject: Re: unstable atimes on empty dirs in read-only snapshots which were
 subvol parents
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Apparently in my haste, forgot to include any information in my email.
This is also in the URL to the gist of my test script:

btrfs v3.17
Linux 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt4-3 (2015-02-03) x86_64 GNU/Linux

# mount: /dev/loop2 mounted on /tmp/tmp.FkcW7fRde7.
# Showing mount:
# /tmp/tmp.1fbwCCdeNM on /tmp/tmp.FkcW7fRde7 type btrfs (rw,noatime,space_cache)
# Create subvolume '/tmp/tmp.FkcW7fRde7/subvol'
# mkdir: created directory ‘/tmp/tmp.FkcW7fRde7/snapshots’
# mkdir: created directory ‘/tmp/tmp.FkcW7fRde7/empty_dir’
# Create a readonly snapshot of '/tmp/tmp.FkcW7fRde7' in
'/tmp/tmp.FkcW7fRde7/snapshots/1'
# Testing that the subvol dir has stable atime on original parent FS:
# Testing that '/tmp/tmp.FkcW7fRde7/subvol' has repeatable atime of
#         2015-03-06T11:09:40+1100...
# 1:      2015-03-06T11:09:40+1100
# 2:      2015-03-06T11:09:40+1100
#         PASS /tmp/tmp.FkcW7fRde7/subvol atime is stable :)
# Testing that a normal empty dir has stable atime on the snapshot:
# Testing that '/tmp/tmp.FkcW7fRde7/snapshots/1/empty_dir' has
repeatable atime of
#         2015-03-06T11:09:40+1100...
# 1:      2015-03-06T11:09:40+1100
# 2:      2015-03-06T11:09:40+1100
#         PASS /tmp/tmp.FkcW7fRde7/snapshots/1/empty_dir atime is stable :)
# Testing that the subvol dir has stable atime on snapshot of parent FS:
# Testing that '/tmp/tmp.FkcW7fRde7/snapshots/1/subvol' has repeatable atime of
#         2015-03-06T11:09:48+1100...
# 1:      2015-03-06T11:09:50+1100
# 2:      2015-03-06T11:09:52+1100
#         FAIL /tmp/tmp.FkcW7fRde7/snapshots/1/subvol atime is unstable :(
# './btrfs-atime-bug.sh nocleanup' not specified so cleaning up our mess:
# umount: /tmp/tmp.FkcW7fRde7 unmounted
# rmdir: removing directory, ‘/tmp/tmp.FkcW7fRde7’
# removed ‘/tmp/tmp.1fbwCCdeNM’

On 6 March 2015 at 11:29, Paul Harvey <csirac2@gmail.com> wrote:
> Hi there,
>
> Apologies for not confirming on a much more recent kernel, if anyone
> could please try my test script for me on a newer kernel that would be
> very much appreciated.
>
> I'm working on reproducible builds, and part of this workflow involves
> tar archiving parts of read-only btrfs snapshots. Problem is, some of
> these tar archives are different from run to run when they capture an
> empty directory that happened to be a subvol parent on the original
> FS: the atimes on these empty dirs are always returning the current
> time - which is not the case with an ordinary empty directory created
> with mkdir; it's also not the same behaviour on the original FS (tar
> archives are reproducible if we use the original FS rather than the
> read-only snapshot). This all happens regardless of mounting noatime.
>
> Perhaps this verbiage is convoluted, I'm writing this in a hurry with
> limited internet connectivity - I have a reproducible test case here
> at https://gist.github.com/csirac2/c2b5b2b9d0193b3c08a8
>
> Again, I understand this is a pretty old kernel and perhaps this is
> fixed by now, I'll try a more recent kernel with more assertive bug
> report next week if nobody has time to try out my test case.
>
> Cheers
>
> --
> Paul Harvey
