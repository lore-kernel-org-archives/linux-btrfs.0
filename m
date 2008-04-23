From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [Btrfs-devel] transaction ioctls
Date: Wed, 23 Apr 2008 17:15:08 +0400
Message-ID: <20080423131508.GA19354@2ka.mipt.ru>
References: <Pine.LNX.4.64.0804221210130.23551@cobra.newdream.net> <200804230850.55074.chris.mason@oracle.com> <20080423125754.GA31257@2ka.mipt.ru> <200804230907.28640.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sage Weil <sage@newdream.net>, btrfs-devel@oss.oracle.com,
	Zach Brown <zach.brown@oracle.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200804230907.28640.chris.mason@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 23, 2008 at 09:07:28AM -0400, Chris Mason (chris.mason@oracle.com) wrote:
> But, userland expects things not to be undone.  Picture two procs operating in 
> a directory.  One proc calls fsync and gets assurance from the FS that things 
> are on disk.  The other proc calls rollback and undoes the fsync.  The posix 
> API isn't built around this.

Rollback happens on transaction, so first application called fsync in
own trasaction, which flushed data to disk, while second thread has own
trasaction, and that data will be removed, while data written in first
transaction is still on disk.

> There are definitely cases where the admin will want to be able to run a 
> command to shift the FS state back to some time in the past.  But, it needs 
> to be an admin level tool where the complex interactions between procs are 
> well understood (by the admin).

Well, to allow or not to allow transaction mechanism to users is the
last question imho, from security point of view it can be limited to
admin only, although if transaction is only a label to operation, then
it can be allowed to be done for users too...

-- 
	Evgeniy Polyakov
