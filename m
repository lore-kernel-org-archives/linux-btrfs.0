Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:35993 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbbEGF4j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 May 2015 01:56:39 -0400
Received: by igbpi8 with SMTP id pi8so14170694igb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 06 May 2015 22:56:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150409110630.GB8979@localhost.localdomain>
References: <CAB3_QuJVGezacw-yYqbfr2LHzF_Em4k1XFys02KMHemh1-sMsw@mail.gmail.com>
 <CAB3_QuJaTv_vt-eSaCyrLfmT3kfGFjJPgRJYkYwgh9JZ9KRO=Q@mail.gmail.com> <20150409110630.GB8979@localhost.localdomain>
From: Paul Harvey <csirac2@gmail.com>
Date: Thu, 7 May 2015 15:56:18 +1000
Message-ID: <CAB3_QuKJuVGF-Ugn6OLeM27kv5DssZ-7zww8rncSa7K21ud=7A@mail.gmail.com>
Subject: Re: unstable atimes on empty dirs in read-only snapshots which were
 subvol parents
To: bo.li.liu@oracle.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Somehow I missed your E-mail a few weeks ago. However, I'm still not
quite understanding how your reply justifies this surprising
behaviour. Does this mean it's a WONTFIX? Could you (or someone else)
please try to elaborate on what condition this surprising behaviour
guards against?

"btrfs receive" complicates this further. If we consider my desired
behaviour (that these empty subvol dirs should behave exactly like
plain old empty dirs, i.e. a stable atime), and consider the actual
behaviour (they look like plain old empty dirs but the atime always
returns an ever-changing CURRENT_TIME), then "btrfs send | btrfs
receive" in its current form adds a third behaviour in which these
problem directories are simply omitted altogether in the snapshot on
the destination filesystem.

Which means that what you "btrfs send" is different to what you
actually "btrfs receive".

This certainly complicates the business of trying to get
reproducibility and integrity out of any backup system leveraging
btrfs snapshots.

I've updated https://bugzilla.kernel.org/show_bug.cgi?id=95201 to
include a "btrfs send | btrfs recieve" test-case demonstrating the
inconsistency between the sent snapshot and the received snapshot.

On 9 April 2015 at 21:06, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Fri, Mar 06, 2015 at 12:03:59PM +1100, Paul Harvey wrote:
>> Apparently in my haste, forgot to include any information in my email.
>> This is also in the URL to the gist of my test script:
>>
>> btrfs v3.17
>> Linux 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt4-3 (2015-02-03) x86_64 GNU/Linux
>>
>> # mount: /dev/loop2 mounted on /tmp/tmp.FkcW7fRde7.
>> # Showing mount:
>> # /tmp/tmp.1fbwCCdeNM on /tmp/tmp.FkcW7fRde7 type btrfs (rw,noatime,space_cache)
>> # Create subvolume '/tmp/tmp.FkcW7fRde7/subvol'
>> # mkdir: created directory ‘/tmp/tmp.FkcW7fRde7/snapshots’
>> # mkdir: created directory ‘/tmp/tmp.FkcW7fRde7/empty_dir’
>> # Create a readonly snapshot of '/tmp/tmp.FkcW7fRde7' in
>> '/tmp/tmp.FkcW7fRde7/snapshots/1'
>> # Testing that the subvol dir has stable atime on original parent FS:
>> # Testing that '/tmp/tmp.FkcW7fRde7/subvol' has repeatable atime of
>> #         2015-03-06T11:09:40+1100...
>> # 1:      2015-03-06T11:09:40+1100
>> # 2:      2015-03-06T11:09:40+1100
>> #         PASS /tmp/tmp.FkcW7fRde7/subvol atime is stable :)
>> # Testing that a normal empty dir has stable atime on the snapshot:
>> # Testing that '/tmp/tmp.FkcW7fRde7/snapshots/1/empty_dir' has
>> repeatable atime of
>> #         2015-03-06T11:09:40+1100...
>> # 1:      2015-03-06T11:09:40+1100
>> # 2:      2015-03-06T11:09:40+1100
>> #         PASS /tmp/tmp.FkcW7fRde7/snapshots/1/empty_dir atime is stable :)
>> # Testing that the subvol dir has stable atime on snapshot of parent FS:
>> # Testing that '/tmp/tmp.FkcW7fRde7/snapshots/1/subvol' has repeatable atime of
>> #         2015-03-06T11:09:48+1100...
>> # 1:      2015-03-06T11:09:50+1100
>> # 2:      2015-03-06T11:09:52+1100
>> #         FAIL /tmp/tmp.FkcW7fRde7/snapshots/1/subvol atime is unstable :(
>> # './btrfs-atime-bug.sh nocleanup' not specified so cleaning up our mess:
>> # umount: /tmp/tmp.FkcW7fRde7 unmounted
>> # rmdir: removing directory, ‘/tmp/tmp.FkcW7fRde7’
>> # removed ‘/tmp/tmp.1fbwCCdeNM’
>
> Right, that's an intended behaviour because we'd like to avoid hardlink similar
> problems, that is, to allow ONLY one valid access to 'subvol'.  Here btrfs
> makes a pseudo 'subvol' with setting CURRENT_TIME to inode->atime/ctime/mtime,
> that's why we see it's unstable.
>
> Thanks,
>
> -liubo
>>
>> On 6 March 2015 at 11:29, Paul Harvey <csirac2@gmail.com> wrote:
>> > Hi there,
>> >
>> > Apologies for not confirming on a much more recent kernel, if anyone
>> > could please try my test script for me on a newer kernel that would be
>> > very much appreciated.
>> >
>> > I'm working on reproducible builds, and part of this workflow involves
>> > tar archiving parts of read-only btrfs snapshots. Problem is, some of
>> > these tar archives are different from run to run when they capture an
>> > empty directory that happened to be a subvol parent on the original
>> > FS: the atimes on these empty dirs are always returning the current
>> > time - which is not the case with an ordinary empty directory created
>> > with mkdir; it's also not the same behaviour on the original FS (tar
>> > archives are reproducible if we use the original FS rather than the
>> > read-only snapshot). This all happens regardless of mounting noatime.
>> >
>> > Perhaps this verbiage is convoluted, I'm writing this in a hurry with
>> > limited internet connectivity - I have a reproducible test case here
>> > at https://gist.github.com/csirac2/c2b5b2b9d0193b3c08a8
>> >
>> > Again, I understand this is a pretty old kernel and perhaps this is
>> > fixed by now, I'll try a more recent kernel with more assertive bug
>> > report next week if nobody has time to try out my test case.
>> >
>> > Cheers
>> >
>> > --
>> > Paul Harvey
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
