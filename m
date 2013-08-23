Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34216 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754416Ab3HWIBo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Aug 2013 04:01:44 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VCmJT-0000Xg-3n
	for linux-btrfs@vger.kernel.org; Fri, 23 Aug 2013 10:01:43 +0200
Received: from 50-0-67-239.dsl.static.fusionbroadband.com ([50.0.67.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 10:01:43 +0200
Received: from rogerb by 50-0-67-239.dsl.static.fusionbroadband.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 10:01:43 +0200
To: linux-btrfs@vger.kernel.org
From: Roger Binns <rogerb@rogerbinns.com>
Subject: Re: Samba strict allocate  = yes stops btrfs compression working
Date: Fri, 23 Aug 2013 01:01:31 -0700
Message-ID: <kv74sk$bg9$1@ger.gmane.org>
References: <loom.20130822T115349-248@post.gmane.org> <20130822140752.GO3990@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <20130822140752.GO3990@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 22/08/13 07:07, Josef Bacik wrote:
> Not sure what strict allocate = yes does,

I've worked on SMB servers before and can answer that.  Historically the
way Windows apps (right back into the 16 bit days) have made sure there is
space for a file about to be written is to ask the OS to allocate all the
space for it.  (Unix by default leaves holes making a sparse file.)

For example if a 10MB file is going to be written then an allocation will
be done of 10MB.  (The exact underlying protocol commands vary, but
originally were similar to the Unix seek to end and write.)  After that
seeks and writes are done.  Because the allocation succeeded the app knows
that it won't get an out of space error.

Separately from that, it turns out that some filesystems do benefit from
preallocating the file to the expected size, and then writing the contents
in dribs and drabs into the allocated space.

Consequently Samba gives you the option of really allocating all the file,
either for Windows semantics compatibility, or because it results in
improved performance on the Unix filesystem.

However I can't see it being of any benefit on a COW filesystem like btrfs.

Roger



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlIXFtsACgkQmOOfHg372QR7cwCggRyQxtxj9E7dNKV94M/Tv5o6
LC0AoN9icJNVxzkV0kDQSgf3Vt0N3g3V
=wBHz
-----END PGP SIGNATURE-----

