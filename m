Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52275 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab3CWWWg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Mar 2013 18:22:36 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UJWq0-0005rn-OJ
	for linux-btrfs@vger.kernel.org; Sat, 23 Mar 2013 23:22:56 +0100
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Mar 2013 23:22:56 +0100
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Mar 2013 23:22:56 +0100
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: [PATCH] btrfs: document mount options in Documentation/fs/btrfs.txt
Date: Sat, 23 Mar 2013 15:22:22 -0700
Message-ID: <kil9uq$210$1@ger.gmane.org>
References: <514DEB06.7000606@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <514DEB06.7000606@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 23/03/13 10:48, Eric Sandeen wrote:
> Btrfs is a new copy on write filesystem for Linux aimed at

How much longer does "new" get to be there as the filesystem has been
going for well over half a decade.

> +  autodefrag +	Detect small random writes into files and queue them up
> for the +	defrag process.  Works best for small files; Not well suited
> for +	large database workloads.

What is "large"?  One man's large database is another's trivial database!
 Same applies to "small".  Virtual machines are also in the category of
large files with small random writes.

Quantification would help a lot.  Suggestions are "more than 10 random
writes an hour to files larger than a gigabyte".

Roger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlFOKx4ACgkQmOOfHg372QROFgCfRaaK6mlx3dn6E22Dy3c5PC2T
itUAnR0WxlZ8bFtVnlD+hdJrsnc6s9gU
=dkJp
-----END PGP SIGNATURE-----

