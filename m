Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754880AbbCSArg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Mar 2015 20:47:36 -0400
Message-ID: <550A1CA1.9040303@suse.com>
Date: Wed, 18 Mar 2015 20:47:29 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: syntax for deleting subvolumes?
References: <5509E34F.6010504@graphitesystems.com>	<CAJCQCtSmV63H4OnEgv2ZXSFq4s8npEGmDxUBDO5dHb7pmoC0zw@mail.gmail.com>	<5509F08E.6070702@graphitesystems.com>	<20150318215512.GC31762@carfax.org.uk>	<550A03B3.8020005@graphitesystems.com> <CAJCQCtRvbiKAQ3iwA6y0QXNaYPnXUh7nf7AGF89Xj48q3GWUpw@mail.gmail.com>
In-Reply-To: <CAJCQCtRvbiKAQ3iwA6y0QXNaYPnXUh7nf7AGF89Xj48q3GWUpw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 3/18/15 7:33 PM, Chris Murphy wrote:
> On Wed, Mar 18, 2015 at 5:01 PM, K Richard Pixley 
> <rpixley@graphitesystems.com> wrote:
> 
>> My complaint is a) about multiple subvols and b) about an
>> unnecessary and redundant subvol for the top level file system.
> 
> The current granularity supplied by root and home subvolumes is
> minor. Eventually there'd also be a boot subvolume too, but that's
> not supported yet due to a very old grubby bug that's like a booger
> that can't be flicked off.
> 
> openSUSE uses ~13 subvolumes by default, for an idea of much finer 
> granularity (which I don't like, personally, it's too much and
> really is unnecessary).

We use this layout in SLES too and it's necessary for both compliance
and principle-of-lease-surprise purposes in concert with our
snapshot-rollback facility. If you roll back your root file system,
would you really expect to lose all your logs? How about your mail? Do
you want snapshots of /tmp to hang around eating up disk space,
causing you to reduce the number of snapshots you can retain? Keeping
these as separate subvolumes also allows us to mount them seamlessly
when you boot from a snapshot to either recover or reset your system.

Does it look nice and neat? That's a matter of style. But the reasons
for having separate subvolumes are well thought out and completely
necessary.

BTW, going back to the original issue of why you'd even have a
separate non-top-level subvolume for root - if you boot from a
snapshot and choose to continue from there, you wouldn't be able to
remove the old "root" if it weren't a separate subvolume.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)

iQIcBAEBAgAGBQJVChyhAAoJEB57S2MheeWyQoAQAKVJmrh+BA8MBApVqmpOADUi
o7RvsSx0D/2lReqep9p2zCyLq0RCorClP7ESKqu+VXCl4gLkZmLszr1G5btTthk8
524vN0ErR5vb2L7hbZ/Rexkd5+H3CRmKsgLPeHeO8ladx57k1lF3bDEX4J6ssfd/
4MbIhZ/B3Xu8kxe7Te69T/86kL8A0teVesBARRlxewtm1AzMn6ABXVrAIWhJU9rk
vOe+8L/kMXTqOod0cv9wQNKWu5y587dHrrjGsTQ9qcrdTrudbFq0GKzO5gDaFTm+
RZ8LWucjMKdTDzLVxdmt0KxcBCS/fLTWjSoKeVjHk3If/ciFRYM7DZeCxKsmLU1j
5Fwtlm3VjcquzLRyAZST3buJ0atuP9w1Onu2LNKn4xymQlLvoF2U/Fp/gerNiDxe
ZxVBA6JuwG8PktAFqKNYZC9Wd3+BBmYUTyV7JXM5qXbuXZ8uN1O0e0I3XcN3zgh/
56FPQ7cKIe9AxCjxJzlho8ZDQ8kpYB1p+NiGAs7qiCIfsNKwH3ZfuwoBizdagM8M
KmFUVLC/y7b9vVQW5bQX+4NPJU9dmAYe0/dVD68ZK6ROF4b+pV5baP+qlFu8Hp1+
8DFxlG3wJ51WSoZuIvAWV+9y0drhamOONAQ0D1smddnbWvG1HoiL+Z4v36iYc9+3
kGXR3LtcuNWaV5rCjZ3i
=dToy
-----END PGP SIGNATURE-----
