From: Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: Horrible btrfs performance due to fragmentation
Date: Mon, 1 Nov 2010 17:58:52 +0200
Message-ID: <AANLkTingbRtFQUoQNZmQubL0LNhVF2hvkdma6j7VDTEU@mail.gmail.com>
References: <AANLkTinWT9OyicLfdeY+AvWs=5vb5z8skZ3t6keYjk9j@mail.gmail.com>
	<AANLkTikNywvthaU-+s5HXvh3RX=HxiFWmADW--Ln_Gga@mail.gmail.com>
	<AANLkTimgCU1tM9VJv8RJ-dim+bRsT7cbZ9ZidbT5sco-@mail.gmail.com>
	<20101031224757.GA2430@selene>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Felipe Contreras <felipe.contreras@gmail.com>,
	cwillu <cwillu@cwillu.com>,
	Calvin Walton <calvin.walton@gmail.com>,
	Linux Kernel Mailing List <l
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101031224757.GA2430@selene>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 1, 2010 at 12:47 AM, Hugo Mills <hugo-lkml@carfax.org.uk> w=
rote:
> On Mon, Nov 01, 2010 at 12:36:58AM +0200, Felipe Contreras wrote:
>> On Mon, Nov 1, 2010 at 12:25 AM, cwillu <cwillu@cwillu.com> wrote:
>> > btrfs fi defrag isn't recursive. =C2=A0"btrfs filesystem defrag /h=
ome" will
>> > defragment the space used to store the folder, without touching th=
e
>> > space used to store files in that folder.
>>
>> Yes, that came up on the IRC, but:
>>
>> 1) It doesn't make sense: "btrfs filesystem" doesn't allow a fileyst=
em
>> as argument? Why would anyone want it to be _non_ recursive?
>
> =C2=A0 You missed the subsequent discussion on IRC about the interact=
ion
> of COW with defrag. Essentially, if you've got two files that are COW
> copies of each other, and one has had something written to it since,
> it's *impossible* for both files to be defragmented, without making a
> full copy of both:
>
> Start with a file (A, etc are data blocks on the disk):
>
> file1 =3D ABCDEF
>
> Cow copy it:
>
> file1 =3D ABCDEF
> file2 =3D ABCDEF
>
> Now write to one of them:
>
> file1 =3D ABCDEF
> file2 =3D ABCDxF
>
> =C2=A0 So, either file1 is contiguous, and file2 is fragmented (with =
the
> block x somewhere else on disk), or file2 is contiguous, and file1 is
> fragmented (with E somewhere else on disk). In fact, we've determined
> by experiment that when you defrag a file that's sharing blocks with
> another one, the file gets copied in its entirety, thus separating th=
e
> blocks of the file and its COW duplicate.

Ok, but the fragmentation would not be an issue in this case.

>> 2) The filesystem should not degrade performance so horribly no matt=
er
>> how long the it has been used. Even git has automatic garbage
>> collection.
>
> =C2=A0 Since, I believe, btrfs uses COW very heavily internally for
> ensuring consistency, you can end up with fragmenting files and
> directories very easily. You probably need some kind of scrubber that
> goes looking for non-COW files that are fragmented, and defrags them
> in the background.

Or when going through all the fragments of a file, have a counter, and
if it exceeds certain limit mark it somehow, so that it gets
defragmented at least to a certain extent.

--=20
=46elipe Contreras
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
