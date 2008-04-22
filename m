From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [Btrfs-devel] transaction ioctls
Date: Wed, 23 Apr 2008 01:05:15 +0400
Message-ID: <20080422210515.GA31827@2ka.mipt.ru>
References: <Pine.LNX.4.64.0804221210130.23551@cobra.newdream.net> <200804221641.34817.chris.mason@oracle.com> <Pine.LNX.4.64.0804221349200.23551@cobra.newdream.net> <200804221655.38102.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sage Weil <sage@newdream.net>, btrfs-devel@oss.oracle.com,
	Zach Brown <zach.brown@oracle.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200804221655.38102.chris.mason@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

On Tue, Apr 22, 2008 at 04:55:37PM -0400, Chris Mason (chris.mason@oracle.com) wrote:
> > The transactions generally look like
> >
> >  write(a)
> >  setxattr(a)
> >  write(b)
> >  setxattr(b)
> 
> Hmm, is this whole thing the atomic unit, or can a and b be done separately?

No, main idea is to bind very different operations together and make
them look atomic from userspace point of view. But transactions are
nothing without ability to correctly unroll them on demand.
Transaction can include any operation with data and metadata.

-- 
	Evgeniy Polyakov
