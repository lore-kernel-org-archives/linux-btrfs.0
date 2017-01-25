Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-03.prod.phx3.secureserver.net ([184.168.200.142]:57294
        "EHLO p3nlsmtpcp01-03.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751482AbdAYUIn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jan 2017 15:08:43 -0500
Date: Thu, 26 Jan 2017 01:37:30 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: btrfs/047: check btrfs-convert with extent and
 non-extent source
Message-ID: <20170125200730.GA11044@giis.co.in>
References: <20170118014702.GA6682@giis.co.in>
 <20170118063953.GO1859@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170118063953.GO1859@eguan.usersys.redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 18, 2017 at 02:39:53PM +0800, Eryu Guan wrote:
> On Wed, Jan 18, 2017 at 07:17:02AM +0530, Lakshmipathi.G wrote:
> > Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
> 
> Need detailed test description in commit log too.

Okay will include them.

> 
> 
> Trailing whitespace in above line.
> 

> > +BTRFS_CONVERT_PROG="`set_prog_path btrfs-convert`"
> > +E2FSCK_PROG="`set_prog_path e2fsck`"
> > +TUNE2FS_PROG="`set_prog_path tune2fs`"
> 
> These should go to common/config. Can you please update btrfs/012 as
> well to move such defines to common/config?
> 

> > +# Create & populate an ext3 filesystem
> > +$MKFS_EXT4_PROG -t ext3 -b $BLOCK_SIZE $SCRATCH_DEV > $seqres.full 2>&1 || \
> > +	_notrun "Could not create ext3 filesystem"
> 
> Better to add "-F" option to mkfs to force mkfs so it won't stop when
> there's an existing fs on SCRATCH_DEV.
> 
> > +
> > +# mount and populate non-extent file
> > +mount -t ext3 $SCRATCH_DEV $SCRATCH_MNT
> > +dd if=/dev/urandom of=$SCRATCH_MNT/f1.txt bs=1MB count=10 >> $seqres.full 2>&1
> > +NON_EXTENT_MD5=`md5sum $SCRATCH_MNT/f1.txt  | awk '{print $1}' `
> 
> Better to have different files with different file sizes and different
> types, e.g. run fsstress to create such a fs structure.
> 

Will look into fsstress tool or else simply copy files from hosts machine. (ex: /usr/lib)

> > +_scratch_unmount
> > +
> > +# Upgrade it to ext4.
> > +$TUNE2FS_PROG -O extents,uninit_bg,dir_index $SCRATCH_DEV >> $seqres.full 2>&1
> > +$E2FSCK_PROG -fyD $SCRATCH_DEV >> $seqres.full 2>&1
> 
> Why is this e2fsck needed? Add some comments? Or it just can be removed?
> 
It recommended to run e2fsck after conversion as per https://ext4.wiki.kernel.org/index.php/UpgradeToExt4

> > +
> > +if [ $NON_EXTENT_MD5 != $F1_MD5 ] ; then 
> 
> Trailing whitespace in above line.
> 
> > +_fail "ext3 file mismatch."
> 
> No need to _fail, just echo this message to break golden image.
> 
> And need indention inside "if-then-fi"
> 
> > +fi
> > +
> > +if [ $EXTENT_MD5 != $F2_MD5 ] ; then 
> 
> Trailing whitespace.
> 
> > +_fail "ext4 file mismatch."
> 
> Same here. Use echo and indention.
> 
> > +fi
> > +   
> 
> Trailing whitespace.
> 
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/btrfs/047.out b/tests/btrfs/047.out
> > new file mode 100644
> > index 0000000..58e2353
> > --- /dev/null
> > +++ b/tests/btrfs/047.out
> > @@ -0,0 +1 @@
> > +QA output created by 047
> 
> Usually we print a message "Silence is golden" to indicate that this
> test doesn't expect any output.
> 
> Thanks,
> Eryu
> 
Will modify the script to reflect above review comments.

Cheers.
Lakshmipathi.G 
