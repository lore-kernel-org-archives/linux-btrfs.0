From: Mike Fleetwood <mike.fleetwood@googlemail.com>
Subject: Re: BTRFS and power loss ~= corruption?
Date: Fri, 26 Aug 2011 08:48:36 +0100
Message-ID: <CAMU1PDgk-uKU9SuQz1YxGPNVy3HVObwtYALgcDL_Jb0MWcss5w@mail.gmail.com>
References: <4E54F884.9090004@cyberwizzard.nl>
	<CAAS2fgRfW3J441Xv8x6cnKWyKGao-ZGi4_Od=iB-fLX3YixV5g@mail.gmail.com>
	<4E573F1A.2060807@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E573F1A.2060807@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 26 August 2011 07:37, Arne Jansen <sensille@gmx.net> wrote:
> On 26.08.2011 01:01, Gregory Maxwell wrote:
>> On Wed, Aug 24, 2011 at 9:11 AM, Berend Dekens <btrfs@cyberwizzard.n=
l> wrote:
>>
>> It seems to me that if someone created a block device which recorded
>> all write operations a rather excellent test could be constructed
>> where a btrfs filesystem is recorded under load and then every parti=
al
>> replay is mounted and checked for corruption/data loss.
>>
>> This would result in high confidence that no power loss event could
>> destroy data given the offered load assuming well behaved
>> (non-reordering hardware). =C2=A0If it recorded barrier operations t=
he a
>> tool could also try many (but probably not all) permissible
>> reorderings at every truncation offset.
>>
>
> I like the idea. Some more thoughts:
> =C2=A0- instead of trying all reorderings it might be enough to just =
always
> =C2=A0 deliver the oldest possible copy
> =C2=A0- the order in which btrfs writes the data probably depends on =
the
> =C2=A0 order in which the device acknowledges the request. You might =
need
> =C2=A0 to add some reordering there, too
> =C2=A0- you need to produce a wide variety of workloads, as problems =
might
> =C2=A0 only occur at a special kind of it (directIO, fsync, snapshots=
=2E..)
> =C2=A0- if there really is a regression somewhere, it would be good t=
o also
> =C2=A0 include the full block layer into the test, as the regression =
might
> =C2=A0 not be in btrfs at all
> =C2=A0- as a first small step one could just use blktrace to record t=
he write
> =C2=A0 order and analyze the order on mount as well
>
>> It seems to me that the existence of this kind of testing is somethi=
ng
>> that should be expected of a modern filesystem before it sees
>> widescale production use.

This article describes evaluating ext3, reiserfs and jfs using fault
injection using a custom Linux block device driver.
"Model-Based Failure Analysis of Journaling File Systems"
http://www.cs.wisc.edu/adsl/Publications/sfa-dsn05.pdf
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
