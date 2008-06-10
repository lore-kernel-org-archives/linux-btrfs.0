From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Changed type field to be %x for tree header (line in
	btrfs_print_tree)
Date: Tue, 10 Jun 2008 14:30:14 -0400
Message-ID: <1213122614.10187.199.camel@think.oraclecorp.com>
References: <484EA1EA.7000006@hp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <484EA1EA.7000006@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

[ use %x for key type printks ]

I've gone back and forth on this, since the type used to be a mask.
But, right now all the #defines are in decimal, I'd rather keep the
output the same way.

-chris


