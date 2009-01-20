From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs and swap files on SSD's ?
Date: Tue, 20 Jan 2009 11:41:50 -0500
Message-ID: <1232469710.15042.52.camel@think.oraclecorp.com>
References: <200901171110.22803.chris@csamuel.org>
	 <1232382162.6521.108.camel@think.oraclecorp.com> <4975AA6C.8@schleiser.de>
	 <1232456536.15042.0.camel@think.oraclecorp.com>
	 <3a7f57190901200551s7e9ee262mc3720b5b1452b8dc@mail.gmail.com>
	 <1232461902.15042.19.camel@think.oraclecorp.com>
	 <f45c907a12e473689f0061d68c4e0749@smtp.arbitraryconstant.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Dmitri Nikulin <dnikulin@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Anthony Roberts <btrfs-devel@arbitraryconstant.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <f45c907a12e473689f0061d68c4e0749@smtp.arbitraryconstant.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-01-20 at 09:35 -0700, Anthony Roberts wrote:
> > The second is an implementation detail of the linux swap file code.  It
> > expects filesystems don't move blocks around, and takes a mapping of the
> > blocks in the FS once.
> > 
> > This doesn't work with btrfs because we do move blocks around all the
> > time.
> 
> That's interesting. I have a few questions:
> 
> -Is creating a loopback device from the file any different, or does that
> lead to the same problems?

The loopback device would probably work.  At least it would cover blocks
that move around.

> 
> -Would mounting a filesystem image via loopback device cause similar
> problems?

loopback goes through safer APIs.

> 
> -Would this be viable if using a dedicated nodatacow subvolume, or is that
> still too risky because of the odd case where you do cow?

nodatacow is allowed to COW  when there are snapshots or clones.  I
wouldn't recommend swapfiles on it just because people can easily forget
about the swapfile restriction.

I plan on sending a patch to at least disable swapfiles for btrfs in
this kernel cycle.  Later on we can work out the swap bmapping apis with
the VM maintainers.

> 
> -Does online defragmentation hurt this as well?
> 

Yes.  Online defrag in XFS may have problems with this too, I'm asking
the xfs people if they have worked around this.

-chris


