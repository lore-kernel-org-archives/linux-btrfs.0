From: Joe Peterson <lavajoe@gentoo.org>
Subject: Re: [PATCH] COW and checksumming ioctls
Date: Sat, 21 Jun 2008 00:07:55 -0600
Message-ID: <485C9ABB.3070709@gentoo.org>
References: <1213921608.27507.152.camel@BVR-FS.beaverton.ibm.com>	 <485B3EC5.8090006@oracle.com> <485BB852.4060202@gentoo.org>	 <20080620135812.GB3224@unused.rdu.redhat.com> <485BC7AF.6020708@gentoo.org> <1213979877.10187.515.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Josef Bacik <jbacik@redhat.com>,
	Zach Brown <zach.brown@oracle.com>, Mingming <cmm@us.ibm.com>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1213979877.10187.515.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> But, it'll be common to mix database files with files that you do want
> checksummed in the same volume.  This is an admin level decision, and we
> can easily provide knobs to turn it on/off.  So, I think the ioctl is
> really important and we'll just document it as best we can.

I do see now why this ability is desirable, especially if there is a way
to see a file's checksum/COW settings (or better still, to query the
filesystem for which files have certain settings).  My initial concern
was that an admin or user may not realize (or forget) a file was left in
an "unprotected" state, but yes, I'm sure there are ways to mitigate
that possibility.

						-Joe
