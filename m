Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:42049 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757257AbaEJAOG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 May 2014 20:14:06 -0400
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Cc: Marc MERLIN <marc@merlins.org>, Chris Murphy <lists@colorremedies.com>,
        bo.li.liu@oracle.com, jbacik@fb.com, hugo@carfax.org.uk,
        dsterba@suse.cz, clm@fb.com
Subject: Re: btrfs cleaner failure - fs/btrfs/extent-tree.c:5748 (3.14.0)
Date: Sat, 10 May 2014 10:13:43 +1000
Message-ID: <2678329.EOSaIZaHNO@quad>
In-Reply-To: <20140509223659.GW11401@merlins.org>
References: <20140507233959.GB11401@merlins.org> <423AB9BE-EDBF-478B-8CED-C1A9A0FAE736@colorremedies.com> <20140509223659.GW11401@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Marc,

On Fri, 9 May 2014 03:36:59 PM Marc MERLIN wrote:

> Oh, I missed that.
> May  2 14:23:06 legolas kernel: [283268.319035] CPU: 0 PID: 25726 Comm:
> watchdog/0 Tainted: G        W    3.14.0-amd64-i915-preempt-20140216 #2
> This is weird because I don't use any 3rd party binary modules.

There's actually a bunch of reasons a kernel can be tainted.

> Right now, I do see:
> legolas:~# cat /proc/sys/kernel/tainted
> 512

IIUC that's an array of bit flags, and that value means you've had a previous 
kernel warning at that point according to:

https://www.kernel.org/doc/Documentation/sysctl/kernel.txt

# tainted:
#
# Non-zero if the kernel has been tainted.  Numeric values,
# which can be ORed together:
#
[...]
# 512 - A kernel warning has occurred.

Best of luck!
Chris
- -- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEVAwUBU21vOo1yjaOTJg85AQLJDwf/QOxRt0f5KqPbhknn8x0XyUQ5upC8PbzD
FoDHAkKV7tCUGQ6ZmCufBUKi0beNHNE3YKXlld8zLjlYpyV5lCZIgP3XvjQ/A4pZ
Vq+XKiqddaZHOFnjQuk9kseqXJaeH7Vr90xz2D92lcRb3NY6yoD2sdFMhAeN43vh
23stzC2Ybr79NFELWPCL3MTFL4qZrAY/4KFFKDQEZsNHMEJW2zJXX841lFsTXJwO
1Ggsi3WzNCJMo+GHRqH+9Gyb4ICk7u7FABHo+y/dShTGnxAh5/8zMnKidlSfCdzd
APKPMrydKEX+O+Fm3zDcKg8gER3FJtWKCyHXfW+zyORTMbxiH5QK5Q==
=q69d
-----END PGP SIGNATURE-----

