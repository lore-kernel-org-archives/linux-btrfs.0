From: Justin Chudgar <justin@justinzane.com>
Subject: Re: btrfsck segmentation fault
Date: Sat, 08 Jan 2011 17:11:48 -0800
Message-ID: <4D290B54.3000204@justinzane.com>
References: <4D278280.4060907@math.duke.edu>	<AANLkTi=0FwYG-O+7MiOhfPiJwdDNc5enxX7hijumMqd2@mail.gmail.com> <AANLkTinwUx6JZZ8mJLU1C=EYiu_RgBSNzoEucCyoWBWd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinwUx6JZZ8mJLU1C=EYiu_RgBSNzoEucCyoWBWd@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I've got the same problem. That is, I have a 2.6.35 btrfs volume that
segfaults and causes a kernel oops upon attempts to mount it. There is
some data on there that was not covered by the daily backup. Though it
is not the end of the world, I'd like to recover it if possible. If
there are absolutely no recovery options, a note on the wiki about
which failures are nonrecoverable might be good.

Thanks for the continuous improvements.

*Justin Chudgar* - Weed, CA 96094

On 01/08/2011 03:42 AM, Fajar A. Nugraha wrote:
> On Sat, Jan 8, 2011 at 5:29 AM, cwillu <cwillu@cwillu.com> wrote:
>> On Fri, Jan 7, 2011 at 3:15 PM, Andrew Schretter
<schrett@math.duke.edu> wrote:
>>> I have a 10TB btrfs filesystem over iSCSI that is currently
unmountable. I'm
>>> currently running Fedora 13 with a recent Fedora 14 kernel
(2.6.35.9-64.fc14.i686.PAE)
>>> and the system hung with messages like :
>>>
>>> parent transid verify failed on 5937615339520 wanted 48547 found 48542
>>>
>>> I've rebooted and and am attempting to recover with btrfsck from the
btrfs-progs-unstable
>>> git tree, but it is segfaulting after finding a superblock and
listing out 3 of the
>>> "parent transid" messages. Anyone have any ideas?
>>>
>>> I tried btrfsck /dev/sdb, btrfsck -s 1 /dev/sdb, and btrfsck -s 2
/dev/sdb with the
>>> same result for each. The btrfsck binary I compiled does work on a
small (800MB) test
>>> btrfs file system. I suspect it may be due to the size of the
filesystem I am trying
>>> to repair.
>> Segfaulting is what the current btrfsck does when it finds a problem;
>> it doesn't try to fix anything yet.
> Is there something we can do to fix this particular problem (e.g.
> editing the metadata manually to use older transaction group), or is
> this one of those forhet-in-you're-screwed kind of thing?
>
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk0pC0kACgkQUl5UaPAPOwJrMACdFGRSKrw4H56mlG26Tys4hYL/
iiYAn1YNOoUaUvSJz7TB+IwX17V9XfiX
=8vhU
-----END PGP SIGNATURE-----

