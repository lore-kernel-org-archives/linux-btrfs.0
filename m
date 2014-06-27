Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbaF0Vgf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 17:36:35 -0400
Message-ID: <53ADE3DD.2000604@redhat.com>
Date: Fri, 27 Jun 2014 16:36:29 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.net>, linux-btrfs@vger.kernel.org
Subject: Re: "nossd" option ignored
References: <20140628012710.620102ef@natsu>
In-Reply-To: <20140628012710.620102ef@natsu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 6/27/14, 2:27 PM, Roman Mamedov wrote:
> Hello,
> 
> With kernel 3.14.5...
> 
> $ sudo umount /mnt/net/alpha/11
> umount: /mnt/net/alpha/11: not mounted
> 
> $ sudo mount -o inode_cache,space_cache,compress=lzo,noatime,nossd,skip_balance /dev/nbd11 /mnt/net/alpha/11
> 
> $ sudo mount | grep nbd11
> /dev/nbd11 on /mnt/net/alpha/11 type btrfs (rw,noatime,compress=lzo,ssd,space_cache,inode_cache,skip_balance)
> 
> $ dmesg | tail
> ...
> [1353819.363462] BTRFS: device fsid 8cf8eff9-fd5a-4b6f-bb85-3f2df2f63c99 devid 1 transid 25041 /dev/nbd11
> [1353819.364668] BTRFS info (device nbd11): enabling inode map caching
> [1353819.364674] BTRFS info (device nbd11): disk space caching is enabled
> [1353821.784617] BTRFS: detected SSD devices, enabling SSD mode
> 
> --
> I'm certain the "nossd" option used to work (prevent the SSD mode) with this
> exact same configuration on older kernels. Any idea why it doesn't now?
> 

Looks like it was broken by this commit in v3.14:

commit 078025347c8ed43ff330e392476d8866ac1b297f
Author: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date:   Mon Jan 13 13:36:07 2014 +0800

    btrfs: Cleanup the btrfs_parse_options for remount.

due to this change:
 
                case Opt_nossd:
- -                       btrfs_info(root->fs_info, "not using ssd allocation scheme");
- -                       btrfs_set_opt(info->mount_opt, NOSSD);
+                       btrfs_clear_and_info(root, NOSSD,
+                                            "not using ssd allocation scheme");
                        btrfs_clear_opt(info->mount_opt, SSD);
- -                       btrfs_clear_opt(info->mount_opt, SSD_SPREAD);
                        break;

whereas "nossd" used to set the "NOSSD" option, it now tries to *clear* "NOSSD"

There seem to be other breakages as well.

Looks like mount option regression tests are needed.

Because "clear_and_info" says nothing if there's nothing to clear, you get no
printk, either.

The ssd options are a mess; you can mount "-o nossd,ssd_spread" for example.

I'll send a patch to at least make it behave at least as well as before, but bleah.

- -Eric
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTrePdAAoJECCuFpLhPd7gPAAQALBa9X7rip3xgvYESO8crwFd
4CT1+0v+4ZuHfa6EVwlpXXMTAvvt4FaRwTL9olmR9YGKx+0S5BcpXaRnDagcgRdO
QMoiJ1m61CW05UlpSG0WQdJIBaMY2p7+eMs+jTi2f4mmkZd8DWF4fAiec+VU8def
ntUiMPrIMX6BCIEMIg/wox94U5z5v+V4zEqt62djE2YrI3hNIReu+98TRtGgumYX
7LP3oqPoDy7hMzyzWk6gZjQG9YJuvfU8qyijSOISh/vL/wxzNU++R5sDv9rIUUJX
nRJOKHnlT5ZPKgcopzWoft7Ir7dFPYM6p0vDhqsROOmpEGvKovhabzHrKYh+JwR8
MgltVu+9OdO8S54XLOboJmyIuTsANrIz3EjuNt6HJLwSjOAP6viibaNvciTxHECq
3C9rky/oBwE7cavMq5sploV0ZYRV+OuTJ5OtUJLCerpzpXWu8zH+4qMw9SGAmAVc
4BYTYtlfDn7N/b1EQucHmpsDK5H0N2MxR0FivmpdgIyL+j4EAWI65Y+OLupUf5Bn
Yzzg8VYK0ohRDivf2g5AJzZ8xZPQS3rG9xl/jbwzlnyn67+uGBqWYFPTOtakLj1h
29KYyq5XR1uxaBO0eCNGlOXOAHY1t+r5WEgRx9lxrBX7qmrZVGsLZh4nihr//hME
fOByY8Y+Fv9Dh47eTD5U
=oIka
-----END PGP SIGNATURE-----
