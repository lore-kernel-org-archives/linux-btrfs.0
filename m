From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: questions about GRUB and BTRFS
Date: Tue, 21 Apr 2009 16:13:52 +0100
Message-ID: <1240326832.3632.46.camel@macbook.infradead.org>
References: <a3a222ba714187fedfe43fe9f7086242@smtp.arbitraryconstant.com>
	 <1235586140.32346.37.camel@think.oraclecorp.com>
	 <6e246ee64cdb6decfd7153436888efcb@smtp.arbitraryconstant.com>
	 <1235593343.32346.73.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Anthony Roberts <btrfs-devel@arbitraryconstant.com>,
	Linux btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1235593343.32346.73.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2009-02-25 at 15:22 -0500, Chris Mason wrote:
> > This suggests another question for me... right now you can specify a root=
> > command line to the kernel, though there's other stuff like nfsroot= where
> > more parameters are needed. Is it possible to add a btrfsroot= option with
> > a UUID+subvolume?
> 
> I'm not a huge fan of initrds, but the distro initrd scripts already
> have this kind of goodness hooked in.  I think that's the best place for
> it.

Definitely. We're talking about _removing_ the nfsroot stuff that
Anthony refers to, in fact, on the basis that it can be done within an
initrd and doesn't have to live in the kernel.

Mount by UUID for other file systems is already handled by initrd; the
kernel can't do it for itself.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

