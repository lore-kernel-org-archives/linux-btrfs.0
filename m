Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45806 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbbJOOmU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Oct 2015 10:42:20 -0400
Date: Thu, 15 Oct 2015 07:41:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
        Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH 03/12] generic/80[0-2]: support xfs in addition to btrfs
Message-ID: <20151015144146.GL10391@birch.djwong.org>
References: <20151007051257.3260.73072.stgit@birch.djwong.org>
 <20151007051323.3260.60421.stgit@birch.djwong.org>
 <20151015091944.GA13683@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151015091944.GA13683@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 15, 2015 at 02:19:44AM -0700, Christoph Hellwig wrote:
> > +# this test requires the test fs support reflink...
> > +#
> > +_require_test_reflink()
> > +{
> > +    case $FSTYP in
> > +    xfs)
> > +	xfs_info "${TEST_DIR}" | grep reflink=1 -c -q || _notrun "Reflink not supported by this filesystem type: $FSTYP"
> > +	;;
> > +    btrfs)
> > +        true
> > +        ;;
> > +    *)
> > +        _notrun "Reflink not supported by this filesystem type: $FSTYP"
> > +        ;;
> > +    esac
> 
> I don't think that's a good test - we need to check if it's supported by
> trying it.  That'll automatically get us coverage for other file systems
> like xfs.
> 
> Note that dedup should get it's own feature check, as currently hacking
> nfs into this check will also run dedup tests that can't really be
> supported.

Good point.  I'll throw that in while I rework the tests.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
