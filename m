From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] COW and checksumming ioctls
Date: Fri, 20 Jun 2008 12:37:57 -0400
Message-ID: <1213979877.10187.515.camel@think.oraclecorp.com>
References: <1213921608.27507.152.camel@BVR-FS.beaverton.ibm.com>
	 <485B3EC5.8090006@oracle.com> <485BB852.4060202@gentoo.org>
	 <20080620135812.GB3224@unused.rdu.redhat.com> <485BC7AF.6020708@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Josef Bacik <jbacik@redhat.com>,
	Zach Brown <zach.brown@oracle.com>, Mingming <cmm@us.ibm.com>,
	linux-btrfs@vger.kernel.org
To: Joe Peterson <lavajoe@gentoo.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <485BC7AF.6020708@gentoo.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-06-20 at 09:07 -0600, Joe Peterson wrote:
> Josef Bacik wrote:
> > Database apps that do their own complicated stuff to make sure everything makes
> > it to the disk properly who dont want the extra overhead of checksumming.
> 
> I do see the benefit of that, if indeed the DB does end-to-end checking.
>  Then again, I could almost see that perhaps making the setting based on
> something at the subvolume level (not per-file level) might be even
> better for that case.
> 

But, it'll be common to mix database files with files that you do want
checksummed in the same volume.  This is an admin level decision, and we
can easily provide knobs to turn it on/off.  So, I think the ioctl is
really important and we'll just document it as best we can.

Long term, these might end up getting folded into chattr, so I think
Zach has a good point about folding them into a single
change-file-attributes ioctl.

-chris


