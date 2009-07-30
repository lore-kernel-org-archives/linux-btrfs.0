From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Subject: Re: BTRFS file clone support for cp
Date: Thu, 30 Jul 2009 11:02:16 +0100
Message-ID: <4A716FA8.1010203@draigBrady.com>
References: <87d47o3fip.fsf@master.homenet> <4A6CEA48.5050208@draigBrady.com>	<8763defuvq.fsf@meyering.net> <87ws5tvrq8.fsf@master.homenet>	<4A6E3ADE.6050008@draigBrady.com> <8763dcvagk.fsf@master.homenet>	<20090729130106.GF13940@think> <4A705959.7010303@draigBrady.com>	<20090729161014.GJ13940@think> <4A70918D.6020003@draigBrady.com>	<20090730005702.GA32157@mail.oracle.com> <87fxcevcuy.fsf@meyering.net> <87ocr2frmx.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jim Meyering <jim@meyering.net>, linux-btrfs@vger.kernel.org,
	bug-coreutils@gnu.org, Giuseppe Scrivano <gscrivano@gnu.org>,
	Chris Mason <chris.mason@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87ocr2frmx.fsf@basil.nowhere.org>
List-ID: <linux-btrfs.vger.kernel.org>

Andi Kleen wrote:
> Jim Meyering <jim@meyering.net> writes:
>> Thanks.  I haven't looked, but after reading about the reflink sysca=
ll
>> [http://lwn.net/Articles/332802/] had come to the same conclusion:
>> this feature belongs with ln rather than with cp.
>=20
> cp already has -l so it would make sense to extend that too.
>=20
>> Besides, putting the new behavior on a new option avoids
>> the current semantic change we would otherwise induce in cp.
>=20
> I don't see how semantics change in a user visible way.

I was thinking that doing reflink() in cp has the following
user visible advantages/disadvantages:

Advantages:
  very quick copy
  less space used

Disadvantages:
  disk head seeking deferred to modification process
  possible fragmentation on write
  possible ENOSPC on write

The disk head seeking issue will go away with time.
I'm not sure if the other disadvantages exist or whether
they could be alleviated with fallocate() or something.

cheers,
P=E1draig.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
