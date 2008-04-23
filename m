From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [Btrfs-devel] transaction ioctls
Date: Wed, 23 Apr 2008 08:50:54 -0400
Message-ID: <200804230850.55074.chris.mason@oracle.com>
References: <Pine.LNX.4.64.0804221210130.23551@cobra.newdream.net> <200804221655.38102.chris.mason@oracle.com> <20080422210515.GA31827@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: Sage Weil <sage@newdream.net>, btrfs-devel@oss.oracle.com,
	Zach Brown <zach.brown@oracle.com>, linux-btrfs@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080422210515.GA31827@2ka.mipt.ru>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 22 April 2008, Evgeniy Polyakov wrote:
> Hi.
>
> On Tue, Apr 22, 2008 at 04:55:37PM -0400, Chris Mason 
(chris.mason@oracle.com) wrote:
> > > The transactions generally look like
> > >
> > >  write(a)
> > >  setxattr(a)
> > >  write(b)
> > >  setxattr(b)
> >
> > Hmm, is this whole thing the atomic unit, or can a and b be done
> > separately?
>
> No, main idea is to bind very different operations together and make
> them look atomic from userspace point of view. But transactions are
> nothing without ability to correctly unroll them on demand.
> Transaction can include any operation with data and metadata.

Transaction rollback from a filesystem point of view is a reboot.  Real 
database style transactions with rollback and isolation from other procs etc 
etc are outside the scope of Btrfs.

-chris

