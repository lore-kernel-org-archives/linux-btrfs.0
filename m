From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: A couple of questions
Date: Mon, 31 May 2010 13:33:23 -0700
Message-ID: <AANLkTim6wNus8lCN_xYt0yx0o6e5cqMtdsadz0HFqBta@mail.gmail.com>
References: <201005271539.55644.paul.millar@desy.de>
	<20100527160044.GD3835@think>
	<201005312006.47321.paul.millar@desy.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Paul Millar <paul.millar@desy.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201005312006.47321.paul.millar@desy.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 31, 2010 at 11:06 AM, Paul Millar <paul.millar@desy.de> wro=
te:
> Hi Chris,
>
> On Thursday 27 May 2010 18:00:44 Chris Mason wrote:
>> I'd suggest that you look at T10 DIF and DIX, which are targeted at
>> exactly this kind of thing. =C2=A0We're looking at integrating dif/d=
ix into
>> btrfs at some point.
>
> I've been keeping half-an-eye on T10's work in ensuring end-to-end in=
tegrity.
> That you guys are planning to integrate dif/dix support is certainly =
welcome
> news!
>
> In my use-case (a file-server that receives a new file from a remote =
client),
> I believe that, to ensure end-to-end integrity, =C2=A0the server soft=
ware would
> have to push the client-supplied checksum into the FS when writing a =
new file.
> (I believe there's some T10 slides somewhere that show this use-case)=
 -- or
> (equivalently) the server software obtains the FS checksum for the fi=
le and
> matches it against the client-supplied value.
>
> I'm deliberately taking the simplest case when the client has chosen =
the same
> checksum algorithm as the FS uses. =C2=A0In reality, this may not be =
the case, but
> we can probably cope with that.
>
> My concern is that, if the server-software doesn't push the client-pr=
ovided
> checksum then the FS checksum (plus T-10 DIF/DIX) would not provide a=
 rigorous
> assurance that the bytes are the same. =C2=A0Without this assurance, =
corruption
> could still occur; for example, within the server's memory.
>

Have you taken into account the boundaries of the data checksums?
Your app may checksum per file or some logical partition in the file
format.  Btrfs does the checksum per-extent so unless you keep track
of where the extent boundaries are, that checksum will be useless to
the userspace app.  Also the app would be tied specifically to a
storage technology.  No matter how great foo might be, not everyone's
going to use it.

Also are you going to get this info over nfs, cifs, lustre, gluster,
ceph, foo, bar and baz?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
