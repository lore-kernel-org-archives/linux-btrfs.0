Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23260 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbcHATef (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Aug 2016 15:34:35 -0400
Date: Mon, 1 Aug 2016 12:32:27 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: FIDEDUPERANGE with src_length == 0
Message-ID: <20160801193227.GH8590@birch.djwong.org>
References: <20160712003537.GA27653@vader.dhcp.thefacebook.com>
 <20160713052643.GD13625@birch.djwong.org>
 <20160713131938.GK10595@twin.jikos.cz>
 <20160714180625.GB23888@birch.djwong.org>
 <a8c74416-370f-0f24-6932-98c47c80e736@fb.com>
 <20160714181647.GA28021@vader.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160714181647.GA28021@vader.DHCP.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 14, 2016 at 11:16:47AM -0700, Omar Sandoval wrote:
> On Thu, Jul 14, 2016 at 02:12:58PM -0400, Chris Mason wrote:
> > 
> > 
> > On 07/14/2016 02:06 PM, Darrick J. Wong wrote:
> > > On Wed, Jul 13, 2016 at 03:19:38PM +0200, David Sterba wrote:
> > > > On Tue, Jul 12, 2016 at 10:26:43PM -0700, Darrick J. Wong wrote:
> > > > > On Mon, Jul 11, 2016 at 05:35:37PM -0700, Omar Sandoval wrote:
> > > > > > Hey, Darrick,
> > > > > > 
> > > > > > generic/182 is failing on Btrfs for me with the following output:
> > > > > > 
> > > > > > --- tests/generic/182.out       2016-07-07 19:51:54.000000000 -0700
> > > > > > +++ /tmp/fixxfstests/xfstests/results//generic/182.out.bad      2016-07-11 17:28:28.230039216 -0700
> > > > > > @@ -1,12 +1,10 @@
> > > > > >  QA output created by 182
> > > > > >  Create the original files
> > > > > > -dedupe: Extents did not match.
> > > > > >  f4820540fc0ac02750739896fe028d56  TEST_DIR/test-182/file1
> > > > > >  69ad53078a16243d98e21d9f8704a071  TEST_DIR/test-182/file2
> > > > > >  69ad53078a16243d98e21d9f8704a071  TEST_DIR/test-182/file2.chk
> > > > > >  Compare against check files
> > > > > >  Make the original file almost dedup-able
> > > > > > -dedupe: Extents did not match.
> > > > > >  f4820540fc0ac02750739896fe028d56  TEST_DIR/test-182/file1
> > > > > >  158d4e3578b94b89cbb44493a2110fb9  TEST_DIR/test-182/file2
> > > > > >  158d4e3578b94b89cbb44493a2110fb9  TEST_DIR/test-182/file2.chk
> > > > > > 
> > > > > > It looks like that test is checking that a dedupe with length == 0 is
> > > > > > treated as a dedupe to EOF, but Btrfs doesn't do that [1]. As far as I
> > > > > > can tell, it never did, but maybe I'm just confused. What was the
> > > > > > behavior when you introduced that test? That seems like a reasonable
> > > > > > thing to do, but I wanted to clear this up before changing/fixing Btrfs.
> > > > > 
> > > > > It's a shortcut that we're introducing in the upcoming XFS implementation,
> > > > > since it shares the same back end as clone/clonerange, which both have
> > > > > this behavior.
> > > > 
> > > > The support for zero length does not seem to be mentioned anywhere with
> > > > the dedupe range ioctl [1], so the current implemetnation is "up to
> > > > spec". That it should be valid is hidden in clone_verify_area where a
> > > > zero length is substituted with OFFSET_MAX
> > > > 
> > > > https://urldefense.proofpoint.com/v2/url?u=http-3A__lxr.free-2Delectrons.com_source_fs_read-5Fwrite.c-23L1607&d=CwIBAg&c=5VD0RTtNlTh3ycd41b3MUw&r=9QPtTAxcitoznaWRKKHoEQ&m=CKo3CgE8Up_NBDdC9t7fCuwHwsdf6nZG2nKcl5-NqnI&s=ZymMvbZ2mZOYBKya3guibggSaaqOHZUqedhz0pT5PPc&e=
> > > > 
> > > > So it looks like it's up to the implementation in the filesystem to
> > > > handle that. As the btrfs ioctl was extent-based, a zero length extent
> > > > does not make sense, so this case was not handled. But in your patch
> > > > 
> > > > 2b3909f8a7fe94e0234850aa9d120cca15b6e1f7
> > > > btrfs: use new dedupe data function pointer
> > > > 
> > > > it was suddenly expected to work. So the missing bits are either 'not
> > > > supported' for zero length or actually implement iteration over the
> > > > whole file.
> > > > 
> > > > [1] https://urldefense.proofpoint.com/v2/url?u=https-3A__www.mankier.com_2_ioctl-5Ffideduperange&d=CwIBAg&c=5VD0RTtNlTh3ycd41b3MUw&r=9QPtTAxcitoznaWRKKHoEQ&m=CKo3CgE8Up_NBDdC9t7fCuwHwsdf6nZG2nKcl5-NqnI&s=NYdHr9JyZZNKPLsOf_VmtZ-3X2B1azTYfyE4Lf1Fa5w&e=
> > > 
> > > Well, we can't change the semantics now because there could be programs that
> > > aren't expecting a nonzero return from a length == 0 dedupe, so like Christoph
> > > said, I'll just change generic/182 and make the VFS wrapper emulate the btrfs
> > > behavior so that any subsequent implementation won't hit this.
> > > 
> > > I'll update the clone/clonerange manpages to mention the 0 -> EOF behavior.
> > 
> > Its fine with me if we change btrfs to do the 0->EOF.  It's a corner case
> > I'm happy to include.
> > 
> > -chris
> 
> Yeah, I think it's a nice shortcut. Are there any programs which
> wouldn't want this, though? It's a milder sort of correctness problem
> since dedupe is "safe", but maybe there's some tool which is being dumb
> and trying to dedupe nothing.

The only users of extent-same that I know of are duperemove and
xfs_io.  duperemove doesn't seem to send zero-length dedupe requests.
xfs_io will if you tell it to, but the xfs_io feature is there
primarily to run xfstests.

Christoph has a valid point that we don't know the full set of users,
so we could be breaking them by changing this aspect.  OTOH this was
an undocumented ioctl for quite a while...

--D

> 
> -- 
> Omar
