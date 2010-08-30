From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: [RFC v2 PATCH 0/6] Btrfs: Add hot data relocation functionality
Date: Mon, 30 Aug 2010 02:42:26 +0200
Message-ID: <201008300242.27331.hka@qbs.com.pl>
References: <1281651726-23501-1-git-send-email-bchociej@gmail.com> <20100826021343.GA452@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: "bchociej@gmail.com" <bchociej@gmail.com>,
	"chris.mason@oracle.com" <chris.mason@oracle.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"cmm@us.ibm.com" <cmm@us.ibm.com>,
	"bcchocie@us.ibm.com" <bcchocie@us.ibm.com>,
	"mrlupfer@us.ibm.com" <mrlupfer@us.ibm.com>,
	"crscott@us.ibm.com" <crscott@us.ibm.com>,
	"mlupfer@gmail.com" <mlupfer@gmail.com>,
	"conscott@vt.edu" <conscott@vt.edu>
To: Shaohua Li <shaohua.li@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100826021343.GA452@sli10-conroe.sh.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 26 of August 2010 04:13:43 Shaohua Li wrote:
> On Fri, Aug 13, 2010 at 06:22:00AM +0800, bchociej@gmail.com wrote:
> > - Hooks in existing Btrfs functions to track data access frequency
> >=20
> >   (btrfs_direct_IO, btrfs_readpages, and extent_write_cache_pages)
> >=20
> > - New rbtrees for tracking access frequency of inodes and sub-file
> >=20
> >   ranges (hotdata_map.c)
> >=20
> > - A hash list for indexing data by its temperature (hotdata_hash.c)
> >=20
> > - A debugfs interface for dumping data from the rbtrees (debugfs.c)
> >=20
> > - A background kthread for relocating data to faster media based on
> >=20
> >   temperature
>=20
> Hi,
> I'm wondering if the temperature info can be exported to userspace, a=
nd
> let a daemon to do the relocation (by ioctl). A userspace daemon is m=
ore
> flexible.

=46lexibility of userspace daemon is one thing, the ability to let the =
admin=20
precisely control on which drive data is placed could be really benefic=
ial in=20
some scenarios is another thing.

This would also allow online defragmentation, together with access to=20
statistics, one that (for quick runs) has really good time/performance =
benefit=20
ratio.
--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=F3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
