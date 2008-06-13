From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [patch 0/5] btrfs-progs: Create libbtrfs and package it up
Date: Fri, 13 Jun 2008 13:17:16 -0400
Message-ID: <4852AB9C.1050002@suse.com>
References: <20080613200906.180149089@suse.com> <20080613202953.GA8819@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Btrfs Development List <linux-btrfs@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080613202953.GA8819@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Christoph Hellwig wrote:
> On Fri, Jun 13, 2008 at 04:09:06PM -0400, Jeff Mahoney wrote:
>> lib contains the objects that used to be $(COMMON_OBJS), but are now
>> a full-fledged shared library with supporting includes to be installed
>> in /usr/include/btrfs. Headers are also placed in lib so that patches
>> indended for the kernel can also apply to the library without a lot of
>> effort.
> 
> I don't think making this a public library yet is a good idea, the API
> will change frequently and it'll be a pain to keep it uptodate.  Just
> make it an internal static library for now.

I'm not sure I get your concerns with keeping it up to date. The library
remains with btrfs-progs. At this stage of development, anyone planning
on using it for anything external should understand the risks.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkhSq5wACgkQLPWxlyuTD7LNJQCffzmBsihbgygw3iYLxS/uXo8e
JDMAn0igroLKwEbTF6vNXbzzvlEBDK2j
=HyDu
-----END PGP SIGNATURE-----
