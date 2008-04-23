From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [Btrfs-devel] transaction ioctls
Date: Wed, 23 Apr 2008 16:57:54 +0400
Message-ID: <20080423125754.GA31257@2ka.mipt.ru>
References: <Pine.LNX.4.64.0804221210130.23551@cobra.newdream.net> <200804221655.38102.chris.mason@oracle.com> <20080422210515.GA31827@2ka.mipt.ru> <200804230850.55074.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sage Weil <sage@newdream.net>, btrfs-devel@oss.oracle.com,
	Zach Brown <zach.brown@oracle.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200804230850.55074.chris.mason@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris.

On Wed, Apr 23, 2008 at 08:50:54AM -0400, Chris Mason (chris.mason@oracle.com) wrote:
> Transaction rollback from a filesystem point of view is a reboot.  Real 
> database style transactions with rollback and isolation from other procs etc 
> etc are outside the scope of Btrfs.

Why rollback is a reboot? With copy-on-write it could be possible to
just commit tree state, which was before transaction start, as a current
one and thus rollback all changes. Having that possibility from
userspace could be a great benefit, since in case of application error
it is relly simple to undo all changes.

-- 
	Evgeniy Polyakov
