From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: btrfsck segmentation fault
Date: Sat, 8 Jan 2011 18:42:48 +0700
Message-ID: <AANLkTinwUx6JZZ8mJLU1C=EYiu_RgBSNzoEucCyoWBWd@mail.gmail.com>
References: <4D278280.4060907@math.duke.edu>
	<AANLkTi=0FwYG-O+7MiOhfPiJwdDNc5enxX7hijumMqd2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andrew Schretter <schrett@math.duke.edu>,
	linux-btrfs@vger.kernel.org
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=0FwYG-O+7MiOhfPiJwdDNc5enxX7hijumMqd2@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 8, 2011 at 5:29 AM, cwillu <cwillu@cwillu.com> wrote:
> On Fri, Jan 7, 2011 at 3:15 PM, Andrew Schretter <schrett@math.duke.e=
du> wrote:
>> I have a 10TB btrfs filesystem over iSCSI that is currently unmounta=
ble. =A0I'm
>> currently running Fedora 13 with a recent Fedora 14 kernel (2.6.35.9=
-64.fc14.i686.PAE)
>> and the system hung with messages like :
>>
>> parent transid verify failed on 5937615339520 wanted 48547 found 485=
42
>>
>> I've rebooted and and am attempting to recover with btrfsck from the=
 btrfs-progs-unstable
>> git tree, but it is segfaulting after finding a superblock and listi=
ng out 3 of the
>> "parent transid" messages. =A0Anyone have any ideas?
>>
>> I tried btrfsck /dev/sdb, btrfsck -s 1 /dev/sdb, and btrfsck -s 2 /d=
ev/sdb with the
>> same result for each. =A0The btrfsck binary I compiled does work on =
a small (800MB) test
>> btrfs file system. =A0I suspect it may be due to the size of the fil=
esystem I am trying
>> to repair.
>
> Segfaulting is what the current btrfsck does when it finds a problem;
> it doesn't try to fix anything yet.

Is there something we can do to fix this particular problem (e.g.
editing the metadata manually to use older transaction group), or is
this one of those forhet-in-you're-screwed kind of thing?

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
