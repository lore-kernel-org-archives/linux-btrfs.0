Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:60994 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbcGFPmo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 11:42:44 -0400
Subject: Re: [PATCH] btrfs-progs: du: fix to skip not btrfs dir/file
To: Hugo Mills <hugo@carfax.org.uk>, Wang Shilong <wangshilong1991@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
References: <1467807934-23403-1-git-send-email-wangshilong1991@gmail.com>
 <577D091F.6020407@applied-asynchrony.com>
 <CAP9B-QkSBGBLbcHfBCR_zg6fVntmyLUpZ1yEfRsWiAYnFo8Hew@mail.gmail.com>
 <20160706152027.GM10223@carfax.org.uk>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <577D26E9.50607@applied-asynchrony.com>
Date: Wed, 6 Jul 2016 17:42:33 +0200
MIME-Version: 1.0
In-Reply-To: <20160706152027.GM10223@carfax.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="HRHw29dJFoLTLE6pWo1TcN9wUNC3b4vwL"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HRHw29dJFoLTLE6pWo1TcN9wUNC3b4vwL
Content-Type: multipart/mixed; boundary="7QRDfjc52no9flFCgP0xfV8NE9r0JsR8J"
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
To: Hugo Mills <hugo@carfax.org.uk>, Wang Shilong
 <wangshilong1991@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
 David Sterba <dsterba@suse.cz>
Message-ID: <577D26E9.50607@applied-asynchrony.com>
Subject: Re: [PATCH] btrfs-progs: du: fix to skip not btrfs dir/file
References: <1467807934-23403-1-git-send-email-wangshilong1991@gmail.com>
 <577D091F.6020407@applied-asynchrony.com>
 <CAP9B-QkSBGBLbcHfBCR_zg6fVntmyLUpZ1yEfRsWiAYnFo8Hew@mail.gmail.com>
 <20160706152027.GM10223@carfax.org.uk>
In-Reply-To: <20160706152027.GM10223@carfax.org.uk>

--7QRDfjc52no9flFCgP0xfV8NE9r0JsR8J
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 07/06/16 17:20, Hugo Mills wrote:
> On Thu, Jul 07, 2016 at 12:16:01AM +0900, Wang Shilong wrote:
>> On Wed, Jul 6, 2016 at 10:35 PM, Holger Hoffst=C3=A4tte
>> <holger@applied-asynchrony.com> wrote:
>>> On 07/06/16 14:25, Wang Shilong wrote:
>>>> 'btrfs file du' is a very useful tool to watch my system
>>>> file usage with snapshot aware.
>>>>
>>>> when trying to run following commands:
>>>> [root@localhost btrfs-progs]# btrfs file du /
>>>>      Total   Exclusive  Set shared  Filename
>>>> ERROR: Failed to lookup root id - Inappropriate ioctl for device
>>>> ERROR: cannot check space of '/': Unknown error -1
>>>>
>>>> and My Filesystem looks like this:
>>>> [root@localhost btrfs-progs]# df -Th
>>>> Filesystem     Type      Size  Used Avail Use% Mounted on
>>>> devtmpfs       devtmpfs   16G     0   16G   0% /dev
>>>> tmpfs          tmpfs      16G  368K   16G   1% /dev/shm
>>>> tmpfs          tmpfs      16G  1.4M   16G   1% /run
>>>> tmpfs          tmpfs      16G     0   16G   0% /sys/fs/cgroup
>>>> /dev/sda3      btrfs      60G   19G   40G  33% /
>>>> tmpfs          tmpfs      16G  332K   16G   1% /tmp
>>>> /dev/sdc       btrfs     2.8T  166G  1.7T   9% /data
>>>> /dev/sda2      xfs       2.0G  452M  1.6G  23% /boot
>>>> /dev/sda1      vfat      1.9G   11M  1.9G   1% /boot/efi
>>>> tmpfs          tmpfs     3.2G   24K  3.2G   1% /run/user/1000
>>>>
>>>> So I installed Btrfs as my root partition, but boot partition
>>>> can be other fs.
>>>>
>>>> We can Let btrfs tool aware of this is not a btrfs file or
>>>> directory and skip those files, so that someone like me
>>>> could just run 'btrfs file du /' to scan all btrfs filesystems.
>>>>
>>>> After patch, it will look like:
>>>>    Total   Exclusive  Set shared  Filename
>>>> skipping not btrfs dir/file: boot
>>>> skipping not btrfs dir/file: dev
>>>> skipping not btrfs dir/file: proc
>>>> skipping not btrfs dir/file: run
>>>> skipping not btrfs dir/file: sys
>>>>      0.00B       0.00B           -  //root/.bash_logout
>>>>      0.00B       0.00B           -  //root/.bash_profile
>>>>      0.00B       0.00B           -  //root/.bashrc
>>>>      0.00B       0.00B           -  //root/.cshrc
>>>>      0.00B       0.00B           -  //root/.tcshrc
>>>>
>>>> This works for me to analysis system usage and analysis
>>>> performaces.
>>>
>>> This is great, but can we please skip the "skipping .." messages?
>>> Maybe it's just me but I really don't see the value of printing them
>>> when they don't contribute to the result.
>>> They also mess up the display. :)
>>
>> I don't have a taste whether it needed or not, because it is somehow
>> useful to let users know some files/directories skipped....

When you run "find /path -type d" you don't get messages for all the
things you just didn't want to find either.

>    At the absolute minimum, I think that these messages should go to
> stderr (like du does when it deosn't have permissions), and should go
> away with -q. They're still irritating, but at least you can get rid
> of them easily.

If anything this should require a --verbose, not the other way
around. Maybe instead of breaking the output just indicate the
special status via "-- --" values, or default to 0.00?
Still, we're explicitly only interested in btrfs stuff and not
anything else, so printing non-information can only yield noise.

This is very much orthogonal to not printing anything after an
otherwise successful command execution.

-h



--7QRDfjc52no9flFCgP0xfV8NE9r0JsR8J--

--HRHw29dJFoLTLE6pWo1TcN9wUNC3b4vwL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iGUEARECACUFAld9JvIeHGhvbGdlckBhcHBsaWVkLWFzeW5jaHJvbnkuY29tAAoJ
EA+BNAnY3O7NSJEAoKvHGnPPObBLJ0jMT8d0J7hefTdyAJ9OelTwHDrOnrNDVdpY
rKlu4DaL7g==
=j9IS
-----END PGP SIGNATURE-----

--HRHw29dJFoLTLE6pWo1TcN9wUNC3b4vwL--
