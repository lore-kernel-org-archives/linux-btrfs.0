Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50801 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbbFENIl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Jun 2015 09:08:41 -0400
Message-ID: <55719F55.8070803@suse.com>
Date: Fri, 05 Jun 2015 09:08:37 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: =?UTF-8?B?SG9sZ2VyIEhvZmZzdMOkdHRl?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: iterate over unused chunk space in FITRIM
References: <1433342874-7099-1-git-send-email-jeffm@suse.com>	<1433342874-7099-2-git-send-email-jeffm@suse.com> <pan.2015.06.04.11.15.24@googlemail.com>
In-Reply-To: <pan.2015.06.04.11.15.24@googlemail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 6/4/15 7:15 AM, Holger Hoffstätte wrote:
> On Wed, 03 Jun 2015 10:47:52 -0400, jeffm wrote:
> 
>> This patch iterates over the unused chunk space and discards any
>> regions that are unallocated, regardless of whether they were
>> ever used.  This is a change for btrfs but is consistent with
>> other file systems. ..
> [snip]
> 
> This just gave me:
> 
> fs/btrfs/volumes.c: In function 'btrfs_shrink_device': 
> fs/btrfs/volumes.c:4148:31: warning: passing argument 1 of
> 'contains_pending_extent' from incompatible pointer type if
> (contains_pending_extent(trans, device, &start, len)) { ^ 
> fs/btrfs/volumes.c:1092:12: note: expected 'struct
> btrfs_transaction *' but argument is of type 'struct
> btrfs_trans_handle *' static int contains_pending_extent(struct
> btrfs_transaction *transaction, ^
> 
> because it changes the signature of contains_pending_extent():

Thanks, Holger. It's typical for patch submissions to be against a
known version. Thanks for testing with an integrated branch, though.

>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c index
>> 174f5e1..7fdde31 100644 --- a/fs/btrfs/volumes.c +++
>> b/fs/btrfs/volumes.c @@ -1051,15 +1051,18 @@ out: return ret; }
>> 
>> -static int contains_pending_extent(struct btrfs_trans_handle
>> *trans, +static int contains_pending_extent(struct
>> btrfs_transaction *transaction, struct btrfs_device *device, u64
>> *start, u64 len)
> 
> which conflicts with Filipe's patch on Tuesday called "Btrfs: check
> pending chunks when shrinking fs to avoid corruption":
> 
> +		if (contains_pending_extent(trans, device, &start, len)) {
> 
> since trans (returned from start_transaction()) is a handle, not
> the tx itself.
> 
> ISTM that it should now pass trans->transaction instead..or
> something.

Yep. That's how you'd resolve that merge. The trans->transaction
pointer will be valid for the life of the handle.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJVcZ9VAAoJEB57S2MheeWyI+UP/2pQoipqevOtI7v71O5y6i0/
GSznfy7ku+4Eh4MLMjPttOflgIVX9BAEtunSIt/ygeuib8WH4AQoSXc0YTVyFMDE
ZsDU4BBgE24ujxRbMQjnKC+pTqlHuFUajnWzsiA7iwryp8b2CapTgNBFZqplZWOO
XjQfJPVUN/eH6Ytkw+0roiLvlifu24Cx/duT0c/b4iQzqaMzHuWod1cJGjyY48xs
rri8siGr6GUEnnA21+Zxqa3MTkqBmwTrV1VNUvTXDu9lmIszUE1ei133WSBLeBYh
FyfUzQng79ueiYkhbfPmzGcYK7nbQd+FbFGjeFmdiuypTyFxxKu89mwNqzMoJtG9
vVvv/OW7xJ0oqzrHssrMHEo4jjFHq9ImL/UX6aWGTPsbgVhPFoImiJh1vtyDLinA
Vmy+fuyzJaVFKnbaECGcO/u5c/C9I82eLdAuDlLh8FFFYSIXoCf5UfYIQ8HidisJ
C2gT+e/wtrkxisYmss325jqr1ko1Ip37PFWxbq0E7CKSOUIWMvGnNTKqQs2YYVqb
nIeGIX4roeqqMEDqjN8K8vJDdEMYInilCYp7920nayJBEs1KsknW84RsAEE9R9FZ
fymMt0+IUTw0b00KIKwf5tp5KRfEGMhhrKd+uAA7alCbI4aBo5xFhJHWTzNctIRe
jeKn4c6Kto2Mo6ayvUKq
=2JlH
-----END PGP SIGNATURE-----
