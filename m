From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: grub-0.97: btrfs multidevice  support [PATCH]
Date: Fri, 25 Sep 2009 16:35:30 -0700
Message-ID: <20090925233530.GA4133@mail.oracle.com>
References: <4ABBC1F5.70808@redhat.com>
 <20090924202146.GA16412@thorin>
 <20090924223810.GA2638@brong.net>
 <20090925140951.GA6318@thorin>
 <20090925150136.GQ13423@riva.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The development of GRUB 2 <grub-devel@gnu.org>,
	Bron Gondwana <brong@fastmail.fm>,
	Ric Wheeler <rwheeler@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Colin Watson <cjwatson@ubuntu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090925150136.GQ13423@riva.ucam.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 25, 2009 at 04:01:36PM +0100, Colin Watson wrote:
> This isn't naysaying those people who post patches for GRUB Legacy - but
> given the reality that nobody is maintaining GRUB Legacy upstream right
> now, which is better, to have your patch ignored or to receive a note
> saying that it's against an unmaintained target? I'd go for not being
> ignored any day.

	Thankfully grub2 is starting to see distro work.  We did ocfs2
grub2 support years ago and ran into this problem.  Do the work against
grub and no one will take the patch.  Do the work against grub2 and
upstream will take the patch, but zero users see it because grub2 was
unusable by anyone.
	Here's the original ocfs2 work from Mark Fasheh:
http://osdir.com/ml/boot-loaders.grub.devel/2005-11/msg00025.html  It's
sat idle for four years because of the grub2 vs distros confusion.
Hopefully we can get it upstream again!

Joel

-- 

"The only way to get rid of a temptation is to yield to it."
         - Oscar Wilde 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
