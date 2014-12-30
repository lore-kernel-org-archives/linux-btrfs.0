Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:60226 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaL3VoO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Dec 2014 16:44:14 -0500
Received: by mail-qg0-f51.google.com with SMTP id i50so10653832qgf.38
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Dec 2014 13:44:13 -0800 (PST)
Message-ID: <54A31CAE.4020606@ubuntu.com>
Date: Tue, 30 Dec 2014 16:44:14 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: ashford@whisperpc.com, Chris Murphy <lists@colorremedies.com>
CC: "sys.syphus" <syssyphus@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: I need to P. are we almost there yet?
References: <CAAe=sHWT9G9PNYUh8yxG0dS7xCjy0Fhv03GATvkQHq64kM0oBA@mail.gmail.com>    <CAAe=sHUez9eNCSck5do7sBK=6nV1v9ZNNdqDVfnud1j5s1kJzQ@mail.gmail.com>    <CAJCQCtR=Hinq_w6ELXFT-Ema-5THoz5EpuXkCOU_fE1gv--+qQ@mail.gmail.com> <7e0d08fddb1e0060f756690f6c82c350.squirrel@webmail.wanet.net>
In-Reply-To: <7e0d08fddb1e0060f756690f6c82c350.squirrel@webmail.wanet.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/29/2014 7:20 PM, ashford@whisperpc.com wrote:
> Just some background data on traditional RAID, and the chances of
> survival with a 2-drive failure.
> 
> In traditional RAID-10, the chances of surviving a 2-drive failure
> is 66% on a 4-drive array, and approaches 100% as the number of
> drives in the array increase.
> 
> In traditional RAID-0+1 (used to be common in low-end fake-RAID
> cards), the chances of surviving a 2-drive failure is 33% on a
> 4-drive array, and approaches 50% as the number of drives in the
> array increase.

In terms of data layout, there is really no difference between raid-10
( or raid1+0 ) and raid0+1, aside from the designation you assign to
each drive.  With a dumb implementation of 0+1, any single drive
failure offlines the entire stripe, discarding the remaining good
disks in it, thus giving the probability you describe as the only
possible remaining failure(s) that do not result in the mirror also
failing is a drive in the same stripe as the original.  This however,
is only a deficiency of the implementation, not the data layout, as
all of the data on the first failed drive could be recovered from a
drive in the second stripe, so long as the second drive that failed
was any drive other than the one holding the duplicate data of the first.

This is partly why I agree with linux mdadm that raid10 is *not*
simply raid1+0; the latter is just a naive, degenerate implementation
of the former.

> In traditional RAID-1E, the chances of surviving a 2-drive failure
> is 66% on a 4-drive array, and approaches 100% as the number of
> drives in the array increase.  This is the same as for RAID-10.
> RAID-1E allows an odd number of disks to be actively used in the
> array.

What some vendors have called "1E" is simply raid10 in the default
"near" layout to mdadm.  I prefer the higher performance "offset"
layout myself.

> I'm wondering which of the above the BTRFS implementation most
> closely resembles.

Unfortunately, btrfs just uses the naive raid1+0, so no 2 or 3 disk
raid10 arrays, and no higher performing offset layout.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUoxyuAAoJENRVrw2cjl5R72oH/1nypXV72Bk4PBeaGAwH7559
lL6JH80216lbhv8hHopIeXKe7uqPGFAE5F1ArChIi08HA+CqKr5cfPNzJPlobyFj
KNLzeXi+wnJO2mbvWnnJak83GVmvpBnYvS+22RCweDELCb3pulybleJnN4yVSL25
WpVfUGnAg5lQJdX2l6THeClWX6V47NKqD6iXbt9+jyADCK2yk/5+TVbS8tixFUtj
PBxe+XGNrkTREnPAAFy6BgwO2vCD92F6+mm/lHJ0fg7gOm41UE09gzabsCGQ9LFA
kk99c9WAnJdkTqUJVw49MEwmmhs/2gluKWTeaHONpBePoFIpQEjHI89TqBsKhY4=
=+oed
-----END PGP SIGNATURE-----
