Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63587 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752892AbaCGSFr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Mar 2014 13:05:47 -0500
Message-ID: <531A0A75.6000506@fb.com>
Date: Fri, 7 Mar 2014 13:05:41 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Allow forced conversion of metadata to dup profile
 on, multiple devices
References: <530DF8D5.7010808@gmail.com>
In-Reply-To: <530DF8D5.7010808@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/26/2014 09:23 AM, Austin S Hemmelgarn wrote:
> Currently, btrfs balance start fails when trying to convert
> metadata or system chunks to dup profile on filesystems with
> multiple devices.  This requires that a conversion from a
> multi-device filesystem to a single device filesystem use the
> following methodology: 1. btrfs balance start -dconvert=single
> -mconvert=single \ -sconvert=single -f / 2. btrfs device delete /
> /dev/sdx 3. btrfs balance start -mconvert=dup -sconvert=dup / This
> results in a period of time (possibly very long if the devices are 
> big) where you don't have the protection guarantees of multiple
> copies of metadata chunks.
> 
> After applying this patch, one can instead use the following
> methodology for conversion from a multi-device filesystem to a
> single device filesystem: 1. btrfs balance start -dconvert=single
> -mconvert=dup \ -sconvert=dup -f / 2. btrfs device delete /
> /dev/sdx This greatly reduces the chances of the operation causing
> data loss due to a read error during the device delete.
> 
> Signed-off-by: Austin S. Hemmelgarn <ahferroin7@gmail.com> ---

Fails to build, wait for me to push an updated btrfs-next and rebase
and resubmit

fs/btrfs/volumes.c: In function ‘btrfs_balance’:
fs/btrfs/volumes.c:3223:55: warning: suggest parentheses around ‘&&’
within ‘||’ [-Wparentheses]
   if (((bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
                                                       ^
fs/btrfs/volumes.c:3227:8: error: ‘num_devs’ undeclared (first use in
this function)
       (num_devs > 1)) {
        ^
fs/btrfs/volumes.c:3227:8: note: each undeclared identifier is
reported only once for each function it appears in
make[1]: *** [fs/btrfs/volumes.o] Error 1
make: *** [_module_fs/btrfs] Error 2

Thanks,

Josef

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTGgp0AAoJEANb+wAKly3BrkkQANOaAAk6LJ4VO86f9/N7Hkom
Hf4FK5lQiMkzlLc8pz+RxHeIHSXScXdrVKPv8bIPoGwd171OIrMA1HZa/9iuez8z
OInjO6Zwj6l/+N3/QckAJKkNmbInNH2wgdhUrFyUw+gDFvVnl1YGUcTwx6/udqTB
kfsls2ivD7S9kfSXyaM4oxVMN+tZWpZtOs1TMpf7BDMIz92gr87VADKIocrlu5qh
EZ2YyWGyIP87jz+7zzNPUQ00/BAgC1lPnbZf+ei0L1KQbDtjII3Rl1/rlg78Zdtb
VQfYMBz0hpaOE+UNfVsClgDgMjAkphob7BXTrkzJaChOagJ5tIlSGZRUaHPt3qaz
so1R/3BaPzlTdv7gPCpMg+nSYdNl0x3w5CauCB4EX3L8PtbxK9tQdFtKmpl5GNrZ
gBADD+AAbyPoz4GO2lfQyIN6Hd5FA+drK6cErF/rY+dPlieyihdYfBWRU+nao9RY
ju07FN2UHJaAlSh/K8ZLv4lZUULDObr/tOdg5M1h5piSL9H9jOHUdaLmRzSx+7hZ
j96qRY9/W4L6avEQQLphGbgn3v+aOHcgxLS0MyO/fhXANah2z69PjpS5J7GOXGZ5
UDGTneQIeRqueYms1yqpmZA0Ctwavq0TGoDvYsOlf/x7vucJE6a02qMRitUJbuvV
6m+8a6PFRudGng7zQYef
=KCPn
-----END PGP SIGNATURE-----
