From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: Re: [PATCH] Changed type field to be %x for tree header (line in
 btrfs_print_tree)
Date: Tue, 10 Jun 2008 15:01:11 -0400
Message-ID: <484ECF77.7050602@hp.com>
References: <484EA1EA.7000006@hp.com> <1213122614.10187.199.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1213122614.10187.199.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> [ use %x for key type printks ]
> 
> I've gone back and forth on this, since the type used to be a mask.
> But, right now all the #defines are in decimal, I'd rather keep the
> output the same way.
> 
> -chris

Then, perhaps, one should change the %x in
print-tree.c:btrfs_print_tree() to a %u?

Alan
