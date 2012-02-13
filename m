From: Dave <dave@thekilempire.com>
Subject: Re: Please help me solving BTRFS failure
Date: Mon, 13 Feb 2012 10:02:51 -0500
Message-ID: <20120213150251.GA5933@hendrix.borisch.local>
References: <CAMLWYPqmFuq_W8fzPeRQ4eQt0idZfsJpe-MXY52dPn0YPb_iZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; x-action=pgp-signed
Cc: linux-btrfs@vger.kernel.org
To: Private Inf <privateinf@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAMLWYPqmFuq_W8fzPeRQ4eQt0idZfsJpe-MXY52dPn0YPb_iZw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On Mon, Feb 13, 2012 at 04:58:01PM +0300, Private Inf wrote:
> Hello Dave,
> 
> According to this
> thread<http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg11548.html>you
> were able to fix your faulty BTRFS.  Looks like I have the same problem as you
> do.  It is described in this thread (user DeeKey):
> https://bugs.launchpad.net/ubuntu/+source/btrfs-tools/+bug/793410
> 
> Could you please share your knowledge how to solve the problem?
> 
> Your help will be highly appreciated!
> 
> Regards,
> Denis Kulandin

Hey Denis, btrfs failures are a bitch! I've had them happen to me on multiple
occasions and am much wiser about backups now.  I'm cross posting this to the
mailing list so it will be on record in case anyone else has this issue (and so
smarter people may chime in).

In the email you're referencing, I describe getting an older kernel (2.6.32
series) and patching btrfs to ignore checksums, since that tree is what's
broken.  Then mounting read-only and copying the data to another partition.  I
can't get to kerneltrap for some reason so below is the patch I created.  I've
never use Ubuntu so I can't give you any advice on custom kernels for that
platform but as a btrfs user, you're probably used to compiling kernels every
other week ;)

The above might be purely academic though.  There seems to be some on-the-fly
repair magic build into recent kernels.  If all else fails, you should grab a
recent git of progs; I hear there's some tool that will copy data from a busted
btrfs to another volume.

Good luck!

diff -ur linux-2.6.32.orig/fs/btrfs/compression.c linux-2.6.32/fs/btrfs/compression.c
- --- linux-2.6.32.orig/fs/btrfs/compression.c	2011-08-02 16:11:53.514986277 -0400
+++ linux-2.6.32/fs/btrfs/compression.c	2011-08-02 16:12:58.621654825 -0400
@@ -140,8 +140,7 @@
 			       "wanted %u mirror %d\n", inode->i_ino,
 			       (unsigned long long)disk_start,
 			       csum, *cb_sum, cb->mirror_num);
- -			ret = -EIO;
- -			goto fail;
+         printk("btrfs ignoring compressed csum mismatch");
 		}
 		cb_sum++;
 
diff -ur linux-2.6.32.orig/fs/btrfs/inode.c linux-2.6.32/fs/btrfs/inode.c
- --- linux-2.6.32.orig/fs/btrfs/inode.c	2011-08-02 16:11:53.514986277 -0400
+++ linux-2.6.32/fs/btrfs/inode.c	2011-08-02 16:13:32.821655813 -0400
@@ -1982,8 +1982,8 @@
 
 	csum = btrfs_csum_data(root, kaddr + offset, csum,  end - start + 1);
 	btrfs_csum_final(csum, (char *)&csum);
- -	if (csum != private)
- -		goto zeroit;
+	if (csum != private && printk_ratelimit())
+      printk(KERN_INFO "btrfs ignoring csum mismatch");
 
 	kunmap_atomic(kaddr, KM_USER0);
 good:

- -- 
- -=[dave]=-

Entropy isn't what it used to be.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iF4EAREIAAYFAk85JhsACgkQXM0u5ajNnCjjiAD/aE51kI5IC4eHZp+TsffyFCOk
7L3FP5X3Uzj2BKA/0GEA/jm2fRcAUw4NO8mYJU84kqmjFDQdsKIZMJ5vjSzz3H5r
=XrxN
-----END PGP SIGNATURE-----
