From: Carl Cook <CACook@quantum-sci.com>
Subject: Re: Synching a Backup Server
Date: Thu, 6 Jan 2011 13:42:23 -0800
Message-ID: <201101061342.23991.CACook@quantum-sci.com>
References: <201101060935.14059.CACook@quantum-sci.com> <AANLkTi=iWyKFOoaY6JjTuhg_0CyAtOh=s2gcBUuHGwau@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=iWyKFOoaY6JjTuhg_0CyAtOh=s2gcBUuHGwau@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu 06 January 2011 11:16:49 Freddie Cash wrote:
> Just run rsync on the backup server, tell it to connect via ssh to the
> remote server, and rsync / (root filesystem) into /backups/htpc/ (or
> whatever directory you want).  Use an exclude file to exclude the
> directories you don't want backed up (like /proc, /sys, /dev).

> Then repeat the rsync process the next day, into the exact same
> directory.  Only files that have changed will be transferred.  Then
> snapshot the filesystem using the current date.

Kool.


> > Also with this system, I'm concerned that if there is corruption on the HTPC, it could be propagated to the backup server.  Is there some way to address this?  Longer intervals to sync, so I have a chance to discover?
> 
> Using snapshots on the backup server allows you to go back in time to
> recover files that may have been accidentally deleted, or to recover
> files that have been corrupted.

How?  I can see that rsync will not transfer the files that have not changed, but I assume it transfers the changed ones.  How can you go back in time?  Is there like a snapshot file that records the state of all files there?
