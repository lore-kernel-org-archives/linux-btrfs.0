From: C Anthony Risinger <anthony@extof.me>
Subject: Re: What to do about subvolumes?
Date: Wed, 1 Dec 2010 10:03:23 -0600
Message-ID: <AANLkTikU6UDsGF2-qeDypU4Wprq8NkGD4E4j8otZ-tK7@mail.gmail.com>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
	<AANLkTin_xq7u1Xf9FVOskbKed5WDw1AAvDh8mhConCLX@mail.gmail.com>
	<1291219269-sup-8392@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, hch <hch@lst.de>,
	ssorce <ssorce@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1291219269-sup-8392@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 1, 2010 at 10:01 AM, Chris Mason <chris.mason@oracle.com> w=
rote:
> Excerpts from C Anthony Risinger's message of 2010-12-01 09:51:55 -05=
00:
>> On Wed, Dec 1, 2010 at 8:21 AM, Josef Bacik <josef@redhat.com> wrote=
:
>> >
>> > =3D=3D=3D How do we want subvolumes to work from a user perspectiv=
e? =3D=3D=3D
>> >
>> > 1) Users need to be able to create their own subvolumes. =A0The pe=
rmission
>> > semantics will be absolutely the same as creating directories, so =
I don't think
>> > this is too tricky. =A0We want this because you can only take snap=
shots of
>> > subvolumes, and so it is important that users be able to create th=
eir own
>> > discrete snapshottable targets.
>> >
>> > 2) Users need to be able to snapshot their subvolumes. =A0This is =
basically the
>> > same as #1, but it bears repeating.
>>
>> could it be possible to convert a directory into a volume? =A0or at
>> least base a snapshot off it?
>
> I'm afraid this turns into the same complexity as creating a new volu=
me
> and copying all the files/dirs in by hand.

ok; if i create an empty volume, and use cp --reflink, it would have
the desired affect though, right?

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
