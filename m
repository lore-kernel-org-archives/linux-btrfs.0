Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42229 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab3DVEJ7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 00:09:59 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UU84h-00036L-Ju
	for linux-btrfs@vger.kernel.org; Mon, 22 Apr 2013 06:09:55 +0200
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2013 06:09:55 +0200
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2013 06:09:55 +0200
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: [PATCH] btrfs: move leak debug code to functions
Date: Sun, 21 Apr 2013 21:09:47 -0700
Message-ID: <kl2d67$k03$1@ger.gmane.org>
References: <517387F8.506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <517387F8.506@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 20/04/13 23:32, Eric Sandeen wrote:
> +#define btrfs_leak_list_add(new, head)	do {} while (0); +#define
> btrfs_leak_list_del(entry)	do {} while (0);

Shouldn't the trailing semi-colons be omitted?

Roger

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlF0uAsACgkQmOOfHg372QSuKACfSSd2ufXyZHzuD8xLhGhcBYnp
6iMAn3NbhUgzIxbrVxHDAiWMChQOPJUx
=n9GF
-----END PGP SIGNATURE-----

