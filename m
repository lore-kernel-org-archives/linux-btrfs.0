Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38829 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933425AbbI2KAP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 06:00:15 -0400
Date: Tue, 29 Sep 2015 10:00:13 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2] fstests: generic: Check if a bull fallocate will
 change extent number
Message-ID: <20150929100013.GD25907@carfax.org.uk>
References: <1443519264-19184-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fOHHtNG4YXGJ0yqR"
In-Reply-To: <1443519264-19184-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--fOHHtNG4YXGJ0yqR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 29, 2015 at 05:34:24PM +0800, Qu Wenruo wrote:
> Normally, a bull fallocate call on a fully written and synced file
> should not add an extent.

   What's a "bull" fallocate call? Is it a typo, or simply something
I'm not familiar with?

   Hugo.

> But not all filesystem follows the correct behavior.
> 
> Btrfs has a bug to always truncate the last page if the fallocate start
> offset is smaller than inode size.
> 
> So add this test case to detect such malfunction.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> v2:
>   Add author info...
>   Fix some comment typo
> ---
>  tests/generic/110     | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/110.out |  3 ++
>  tests/generic/group   |  1 +
>  3 files changed, 82 insertions(+)
>  create mode 100755 tests/generic/110
>  create mode 100644 tests/generic/110.out
> 
> diff --git a/tests/generic/110 b/tests/generic/110
> new file mode 100755
> index 0000000..b2b140c
> --- /dev/null
> +++ b/tests/generic/110
> @@ -0,0 +1,78 @@
> +#! /bin/bash
> +# FS QA Test 110
> +#
> +# Test if fallocate will create uneeded extra tailing extent
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2015 Fujitsu.  All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/defrag
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +_supported_fs generic
> +_supported_os IRIX Linux
> +_require_scratch
> +_need_to_be_root
> +
> +# Use 64K file size to match any sectorsize
> +# And with a unaligned tailing range to ensure it will be at least 2 pages
> +filesize=$(( 64 * 1024 + 1024 ))
> +
> +_scratch_mkfs > /dev/null 2>&1
> +_scratch_mount
> +$XFS_IO_PROG -f -c "pwrite 0 $filesize" $SCRATCH_MNT/foo | _filter_xfs_io
> +sync
> +orig_extent_nr=`_extent_count $SCRATCH_MNT/foo`
> +
> +# As all space are allocated and even written to disk, this falloc
> +# should do nothing with extent modification.
> +$XFS_IO_PROG -f -c "falloc 0 $filesize" $SCRATCH_MNT/foo
> +sync
> +new_extent_nr=`_extent_count $SCRATCH_MNT/foo`
> +
> +echo "orig: $orig_extent_nr, new: $new_extent_nr" >> $seqres.full
> +
> +if [ "x$orig_extent_nr" != "x$new_extent_nr" ]; then
> +	echo "number of extents mis-match after bull fallocate"
> +fi
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/110.out b/tests/generic/110.out
> new file mode 100644
> index 0000000..64049da
> --- /dev/null
> +++ b/tests/generic/110.out
> @@ -0,0 +1,3 @@
> +QA output created by 110
> +wrote 66560/66560 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> diff --git a/tests/generic/group b/tests/generic/group
> index 4ae256f..428f3e3 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -112,6 +112,7 @@
>  107 auto quick metadata
>  108 auto quick rw
>  109 auto metadata dir
> +110 auto quick prealloc
>  112 rw aio auto quick
>  113 rw aio auto quick
>  117 attr auto quick

-- 
Hugo Mills             | Mixing mathematics and alcohol is dangerous. Don't
hugo@... carfax.org.uk | drink and derive.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--fOHHtNG4YXGJ0yqR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWCmEtAAoJEFheFHXiqx3kiEYQALdBZ1BVNMuIigVbKV9GsjDg
rVHdZHrsvs6/XivBkSqL11URMxNsjgcayG3pQzuznfFz7BtRdf4ElE/sJK6+kYlZ
+y1m3d4W8nSvr5GIW3O60QESHahTB/mVfETqzDl2wug45sg6xQEdM4tx82263CJe
n5j8WMJaYGfZ5JxEJAgIOoPFkNhVxi8HD4P+lK8omfPtcP+lkL8pQ8FT4jvYNYMv
DHkkE+fZNCokaplWdGmsB8far6X0Ny23aaRfAkUX8ntXLHVqZTsaTeBmBummpycN
fw2Qd6Wcr9HVUGm76CIMBk3ohNPY7+1d47eUjtQcTiKDjiXQPpUv9KrDc3G3P3Kh
qMeTgxYA2goAtot5t5AaSRM6L79QfQsW/H481d4lqQw2Dl/VN5nY8daMvPGYLCZp
A8rAK+xCOr2Q9+XZd++Zk0Rc0ezQ6HyaGGt/THn89KgR6cquWWLVvMFx8EHH47+f
3EyN+hr7jPm2ZoqcrrRf0P8KbIfY4v6dt5X4SJydHyPJrqB63JpDeqv766NruJhx
kbuAaAWwAOMVex0JVPseTFgbL4FMJJdumTvr4CfnFCSB5LGDl80RRjGdm3OMpTml
pkbZ5RMAUjLrG17HA/a932NY97oW6NJxtvA/Ts685LOMR0dIBn0iPKhSya0P5/MQ
Pmk60eUAuWXo/Z1RJ+sD
=HjVB
-----END PGP SIGNATURE-----

--fOHHtNG4YXGJ0yqR--
