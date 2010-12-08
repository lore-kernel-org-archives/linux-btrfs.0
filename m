From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: What to do about subvolumes?
Date: Wed, 8 Dec 2010 14:18:02 -0700
Message-ID: <C327E227-24A5-4DAC-A1FC-90B1B00031FE@dilger.ca>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com> <20101203214526.GA4508@localhost.localdomain> <20101203222756.GF23339@dastard> <20101207165128.GB21375@lst.de> <1291741327.3049.7.camel@heimdal.trondhjem.org> <1994A21A-98DF-4D6A-BDDE-5E40AF6F53AD@dilger.ca> <20101208172732.GD2677@pad.home.fieldses.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
	Christoph Hellwig <hch@lst.de>,
	Dave Chinner <david@fromorbit.com>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
	ssorce@redhat.com
To: "J. Bruce Fields" <bfields@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20101208172732.GD2677@pad.home.fieldses.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 2010-12-08, at 10:27, J. Bruce Fields wrote:
> On Wed, Dec 08, 2010 at 10:16:29AM -0700, Andreas Dilger wrote:
>> It looks like mk_fsid() is only actually using the UUID if it is specified in the /etc/exports file (AFAICS, this depends on ex_uuid being set from a uuid="..." option).
> 
> No, if you look at the nfs-utils source you'll find mountd sets a uuid
> by default (in utils/mountd/cache.c:uuid_by_path()).

Unfortunately, this only works for block devices, not network filesystems.

>> There was a patch in the open_by_handle() patch series that added an s_uuid field to the superblock, that could be used if no uuid= option is specified in the /etc/exports file.
> 
> Agreed that doing this in the kernel would probably be simpler.

Agreed.

Cheers, Andreas





