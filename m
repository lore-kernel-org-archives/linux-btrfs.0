Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:39296 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932707Ab3DBPpG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2013 11:45:06 -0400
Received: by mail-wi0-f178.google.com with SMTP id ez12so584849wid.11
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Apr 2013 08:45:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130329171204.GH29125@twin.jikos.cz>
References: <36071CA2-8A29-4526-8523-7EB40F1C86A6@develooper.com>
	<20130329171204.GH29125@twin.jikos.cz>
Date: Tue, 2 Apr 2013 18:45:05 +0300
Message-ID: <CAOcd+r0sUn_Dt+e2v+dSm-h33V9H-WXwXMQ+o98uvcCcrmxxsw@mail.gmail.com>
Subject: Re: btrfs "stuck" on
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: dsterba@suse.cz, =?ISO-8859-1?Q?Ask_Bj=F8rn_Hansen?= <ask@develooper.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

On Fri, Mar 29, 2013 at 8:12 PM, David Sterba <dsterba@suse.cz> wrote:
> On Thu, Mar 21, 2013 at 11:56:37AM -0700, Ask Bjørn Hansen wrote:
>> A few weeks ago I replaced a ZFS backup system with one backed by
>> btrfs. A script loops over a bunch of hosts rsyncing them to each
>> their own subvolume.  After each rsync I snapshot the "host-specific"
>> subvolume.
>>
>> The "disk" is an iscsi disk that in my benchmarks performs roughly
>> like a local raid with 2-3 SATA disks.
>>
>> It worked fine for about a week (~150 snapshots from ~20 sub volumes)
>> before it "suddenly" exploded in disk io wait. Doing anything (in
>> particular changes) on the file system is just insanely slow, rsync
>> basically can't complete (an rsync that should take 10-20 minutes
>> takes 24 hours; I have a directory of 60k files I tried deleting and
>> it's deleting one file every few minutes, that sort of thing).
>
> I'm seeing similar problem after a test that produces tons of snapshots
> and snap deletions at the same time. Accessing the directory (eg. via
> ls) containing the snapshots blocks for a long time.
>
> The contention point is a mutex of the directory entry, used for lookups
> on the 'ls' side, and the snapshot deletion process holds the mutex as
> well with obvious consequences. The contention is multiplied by the
> number of snapshots waiting to be deleted and eagerly grabbing the
> mutex, making other waiters starve.

Can you pls clarify what mutex do you mean? Do you mean the
dir->i_mutex, taken by btrfs_ioctl_snap_destroy()? If yes, then this
mutex is held only while "adding a snap to todo deletion list", and
not during snap deletion itself. Otherwise, I don't see
btrfs_drop_snapshot() locking any mutex, for example.

>
> You've observed this as deletion progressing very slowly and rsync
> blocked. That's really annoying and I'm working towards fixing it.
>
>> I am using 3.8.2-206.fc18.x86_64 (Fedora 18). I tried rebooting, it
>> doesn't make a difference. As soon as I boot "[btrfs-cleaner]" and
>> "[btrfs-transacti]" gets really busy.
>>
>> I wonder if it's because I deleted a few snapshots at some point?
>
> Yes. The progress or performance impact depends on amount of data shared
> among the snapshots and used / free space fragmentation.
>
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks,
Alex.
