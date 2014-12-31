Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:3506 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751574AbaLaCsc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Dec 2014 21:48:32 -0500
Message-ID: <54A3633C.3040609@ubuntu.com>
Date: Tue, 30 Dec 2014 21:45:16 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: ashford@whisperpc.com,
        Jose Manuel Perez Bethencourt <jmperezbeth@gmail.com>
CC: Chris Murphy <lists@colorremedies.com>, "sys.syphus" <syssyphus@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: I need to P. are we almost there yet?
References: <CAAe=sHWT9G9PNYUh8yxG0dS7xCjy0Fhv03GATvkQHq64kM0oBA@mail.gmail.com>    <CAAe=sHUez9eNCSck5do7sBK=6nV1v9ZNNdqDVfnud1j5s1kJzQ@mail.gmail.com>    <CAJCQCtR=Hinq_w6ELXFT-Ema-5THoz5EpuXkCOU_fE1gv--+qQ@mail.gmail.com>    <7e0d08fddb1e0060f756690f6c82c350.squirrel@webmail.wanet.net>    <54A31CAE.4020606@ubuntu.com> <40b56c60ddd4801295a92c4b11d5c08e.squirrel@webmail.wanet.net>
In-Reply-To: <40b56c60ddd4801295a92c4b11d5c08e.squirrel@webmail.wanet.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 12/30/2014 06:17 PM, ashford@whisperpc.com wrote:
> I believe that someone who understands the code in depth (and that
> may also be one of the people above) determine exactly how BTRFS
> implements RAID-10.

I am such a person.  I had a similar question a year or two ago (
specifically about raid10  ) so I both experimented and read the code
myself to find out.  I was disappointed to find that it won't do
raid10 on 3 disks since the chunk metadata describes raid10 as a
stripe layered on top of a mirror.

Jose's point was also a good one though; one chunk may decide to
mirror disks A and B, so a failure of A and C it could recover from,
but a different chunk could choose to mirror on disks A and C, so that
chunk would be lost if A and C fail.  It would probably be nice if the
chunk allocator tried to be more deterministic about that.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUo2M8AAoJENRVrw2cjl5RihoH/1ulWpEK6lPaYhBSBbmWQyGu
obJZBTbeMgBAfO9VMq9X2laUfmEprwYi8FuKnCwVgA1KyftFsaJngckqMoTtpwdI
IXx2X2++MjZBkFBUFRhGlSQcbDgeB/RbBx+Vtxi2dNq3/WgZyHRfIJT1moRrxY0V
UTH1kI7JsWg4blpdm+xW4o7UKds7JKHr5Th1PUH9SmJOdsBe2efIFQyC7hyuSQs0
gBUQzxmo3HcRzBtJwJjKRICU16VBN0NW7w3m/y6K1yIlkGi4U7MZgzMSUJw/BiMT
tGX48AhBH3D3R2sjmF2aO5suPaHEVYoZuqhKevKZfTGS7izSYA74LqrGHkq5QBk=
=ESya
-----END PGP SIGNATURE-----
