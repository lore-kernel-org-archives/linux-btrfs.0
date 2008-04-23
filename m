From: btrfs-devel@arbitraryconstant.com
Subject: Re: [Btrfs-devel] transaction ioctls
Date: Wed, 23 Apr 2008 11:12:14 -0600 (MDT)
Message-ID: <61772.206.174.215.6.1208970734.squirrel@avalon.arbitraryconstant.com>
References: <Pine.LNX.4.64.0804221210130.23551@cobra.newdream.net>
    <200804230850.55074.chris.mason@oracle.com>
    <20080423125754.GA31257@2ka.mipt.ru>
    <200804230907.28640.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200804230907.28640.chris.mason@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

> But, userland expects things not to be undone.  Picture two procs
> operating in a directory.  One proc calls fsync and gets assurance from
> the FS that things are on disk.  The other proc calls rollback and undoes
> the fsync.  The posix API isn't built around this.

Right, but it's not out of the question to dedicate a filesystem to a
single application. This is reasonably common even with LVMs.

