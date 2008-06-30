From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] COW and checksumming ioctls
Date: Mon, 30 Jun 2008 14:38:57 -0400
Message-ID: <20080630183857.GA8113@infradead.org>
References: <1213921608.27507.152.camel@BVR-FS.beaverton.ibm.com> <485B3EC5.8090006@oracle.com> <20080621072730.GA20871@infradead.org> <1214143806.10187.538.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Zach Brown <zach.brown@oracle.com>, Mingming <cmm@us.ibm.com>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1214143806.10187.538.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 22, 2008 at 10:10:06AM -0400, Chris Mason wrote:
> The idea is that backup programs already know how to do xattrs and can
> easily be changed to preserve them.  Every ioctl interface we
> create/make up has to be handed coded into the backup program.

Actually they don't.  Because of the mess we've created with the
xattr namespaces and the way e.g. ACLs are mapped into two of them
they will need to special case the interesting non-user attributes.

While sane backup applications already know about the inode flag word
because it contains lots of useful information for the existing
filesystems.

> I know xattrs are ugly, but we need to weigh the cost of the perfect
> interface with the availability of a common one.  Dave Chinner had
> talked about using xattrs to control file behavior in XFS as well, not
> sure if that ever happened.

I think I've successfully talked him out of it :)

