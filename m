From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: BTRFS file clone support for cp
Date: Thu, 30 Jul 2009 12:28:16 -0400
Message-ID: <4A71CA20.2070906@redhat.com>
References: <87d47o3fip.fsf@master.homenet> <4A6CEA48.5050208@draigBrady.com>	<8763defuvq.fsf@meyering.net> <87ws5tvrq8.fsf@master.homenet>	<4A6E3ADE.6050008@draigBrady.com> <8763dcvagk.fsf@master.homenet>	<20090729130106.GF13940@think> <4A705959.7010303@draigBrady.com>	<20090729161014.GJ13940@think> <4A70918D.6020003@draigBrady.com>	<20090730005702.GA32157@mail.oracle.com> <87fxcevcuy.fsf@meyering.net> <4A715C61.1080607@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: Jim Meyering <jim@meyering.net>,
	Chris Mason <chris.mason@oracle.com>,
	Giuseppe Scrivano <gscrivano@gnu.org>, bug-coreutils@gnu.org,
	linux-btrfs@vger.kernel.org
To: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A715C61.1080607@draigBrady.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/30/2009 04:40 AM, P=C3=A1draig Brady wrote:
> Jim Meyering wrote:
>   =20
>> Joel Becker wrote:
>>
>>     =20
>>> On Wed, Jul 29, 2009 at 07:14:37PM +0100, P=C3=A1draig Brady wrote:
>>>       =20
>>>> At the moment we have these linking options:
>>>>
>>>> cp -l, --link #for hardlinks
>>>> cp -s, --symbolic-link #for symlinks
>>>>
>>>> So perhaps we should support:
>>>>
>>>> cp --link=3D{soft,hard,cow}
>>>> for symlink(), link() and reflink() respectively?
>>>> I.E. link to the name, inode or extents respectively.
>>>>         =20
>>> 	I've cooked up 'ln -r' for reflinks, which works for ln(1) but
>>> not for cp(1).
>>>       =20
>> Thanks.  I haven't looked, but after reading about the reflink sysca=
ll
>> [http://lwn.net/Articles/332802/] had come to the same conclusion:
>> this feature belongs with ln rather than with cp.
>>     =20
>
> Right. It definitely should be in ln anyway.
>
>   =20
>> Besides, putting the new behavior on a new option avoids
>> the current semantic change we would otherwise induce in cp.
>>     =20
>
> Yes doing reflink() in cp by default currently can
> be problematic as discussed, especially on mechanical hard disks.
> Though in future I can see most users of cp preferring
> reflink() to be done, rather than read()/write(). Ponder...
>
>   =20

I think that doing reflink by default would be a horrible idea - one=20
good reason to copy a file is to increase your level of fault tolerance=
=20
and reflink magically avoids that :-)

reflink is a neat feature, but should be used on purpose in my opinion,

ric

> In any case putting --link=3Dcow or --reflink or whatever in cp
> could be very useful for creating writeable snapshot branches.
>
> cheers,
> P=C3=A1draig.
>   =20

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
