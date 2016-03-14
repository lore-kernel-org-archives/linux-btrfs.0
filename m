Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:36810 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499AbcCNAAP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Mar 2016 20:00:15 -0400
Received: by mail-lb0-f181.google.com with SMTP id x1so218321218lbj.3
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Mar 2016 17:00:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160313205605.GV2334@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
	<CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
	<20160305143934.GE1902@torres.zugschlus.de>
	<CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
	<20160313115809.GQ2334@torres.zugschlus.de>
	<CAPmG0jbUJ8rUM4ttk3MvDPMjAV=fxqwa93Ce0s6kOLQb=3qm=g@mail.gmail.com>
	<20160313205605.GV2334@torres.zugschlus.de>
Date: Mon, 14 Mar 2016 01:00:13 +0100
Message-ID: <CAPmG0jYJgwenu-9n5qi=S+f1D7xVQv=jRhwMAfoaeOjBkysM4w@mail.gmail.com>
Subject: Re: New file system with same issue (was: Again, no space left on
 device while rebalancing and recipe doesnt work)
From: Henk Slager <eye1tm@gmail.com>
To: Marc Haber <mh+linux-btrfs@zugschlus.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 13, 2016 at 9:56 PM, Marc Haber <mh+linux-btrfs@zugschlus.de> wrote:
> On Sun, Mar 13, 2016 at 08:14:45PM +0100, Henk Slager wrote:
>> On Sun, Mar 13, 2016 at 12:58 PM, Marc Haber
>> <mh+linux-btrfs@zugschlus.de> wrote:
>> > Hi,
>> >
>> > On Sat, Mar 05, 2016 at 12:34:09PM -0700, Chris Murphy wrote:
>> >> The alternative if this can't be fixed, is to recreate the filesystem
>> >> because there's no practical way yet to migrate so many snapshots to a
>> >> new file system.
>> >
>> > I recreated the file system on March 7, with 200 GiB in size, using
>> > btrfs-tools 4.4. The snapshot-taking process has been running since
>> > then, but I also regularly cleaned up. The number of snapshots on the
>> > new filesystem has never exceeded 1000, with the current count being
>> > at 148.
>>
>> Is the snapshotting still read-write?
>
> Yes, I want to keep the possibility to remove huge files from
> snapshots that shouldnt have been on a snapshotted volume in the first
> place without having to ditch the entire snapshot.

You could do ro snapshotting and in case you want to modify something
inside a snapshot/subvolume:
# btrfs property set <subvolume> ro false
# rm <subvolume>/<somefile>
# btrfs property set <subvolume> ro true

>> Also, If some part of the OS or tools scans through the snapshot dirs
>> every now and then with atime creation on, metadata grows without a
>> real need.
>
> I mount with noatime and nodiratime anyway, and the directory the
> snapshots are mounted to (/mnt/snapshots) are excluded in
> updatedb.conf. Any other idea which tool might scan filesystems and
> that might not be noticed when it's running about a five digit number
> of snapshots?

Maybe baloo or so if you use KDE. Someone else reporting on this
maillist was searching snapshots dirs for latest before creating new
snapshot. That was more related to fs performance rather then the
metadata issue you experience.

The rw vs. ro snapshotting is the only think I can think of in order
to stop having the issue. I'm using both snapper and my own
scripts+btrfspogs since 2+ years on various small and big filesystems
with 100-1500 snapshots per fs without any metadata issues or so, but
it is all ro snapshots. And actually, if I want some modification
(rarely), I create another rw snapshot of the particular snapshot.
