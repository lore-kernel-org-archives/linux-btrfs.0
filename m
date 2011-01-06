From: Freddie Cash <fjwcash@gmail.com>
Subject: Re: Synching a Backup Server
Date: Thu, 6 Jan 2011 11:47:41 -0800
Message-ID: <AANLkTi=8zq-=ZG2sJBaV4JJbd-SnPpV3BQHg7dZA6Yoo@mail.gmail.com>
References: <201101060935.14059.CACook@quantum-sci.com>
	<AANLkTi=iWyKFOoaY6JjTuhg_0CyAtOh=s2gcBUuHGwau@mail.gmail.com>
	<AANLkTik-rhXAHW18id4WMMtdqXkicvzTZ47+2r6YMuY0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Marcin Kuk <marcin.kuk@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTik-rhXAHW18id4WMMtdqXkicvzTZ47+2r6YMuY0@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 6, 2011 at 11:33 AM, Marcin Kuk <marcin.kuk@gmail.com> wrote:
> Rsync is good, but not for all cases. Be aware of databases files -
> you should do snapshot filesystem before rsyncing.

We script a dump of all databases before the rsync runs, so we get
both text and binary backups.  If restoring the binary files doesn't
work, then we just suck in the text dumps.

If the remote system supports snapshots, doing a snapshot before the
rsync runs is a good idea, though.  It'll be nice when more
filesystems support in-line snapshots.  The LVM method is pure crap.

-- 
Freddie Cash
fjwcash@gmail.com
