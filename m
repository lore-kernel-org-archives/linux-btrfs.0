From: Anthony Roberts <btrfs-devel@arbitraryconstant.com>
Subject: Re: Is there a more aggressive fixer than =?UTF-8?Q?btrfsck=3F?=
Date: Tue, 29 Jun 2010 17:19:06 -0600
Message-ID: <f9b954548c2d10c7ec9105da039c3d0c@smtp.arbitraryconstant.com>
References: <a51eea046c4dd444f9d90742beb41a6a.squirrel@webmail.sonic.net> <AANLkTilC9MjM7RK3b-8owdiRJUYnfmc0dIM5nt9Texla@mail.gmail.com> <AANLkTilXNNQ8zxTGdjNBhI3kbMeTiT2tIN9PzjqHGWLz@mail.gmail.com> <201006291834.13488.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Daniel Kozlowski <dan.kozlowski@gmail.com>,
	=?UTF-8?Q? "Rodrigo_E._De_Le=C3=B3n_Plicet" ?=
	<rdeleonp@gmail.com>, <linux-btrfs@vger.kernel.org>
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201006291834.13488.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 29 Jun 2010 18:34:13 +0200, Hubert Kario <hka@qbs.com.pl> wrote=
:
> On Tuesday 29 June 2010 12:37:45 Daniel Kozlowski wrote:
>> On Mon, Jun 28, 2010 at 10:31 PM, Rodrigo E. De Le=C3=B3n Plicet
>>=20
>> <rdeleonp@gmail.com> wrote:
>> > On Mon, Jun 28, 2010 at 8:48 AM, Daniel Kozlowski
>> >=20
>> > <dan.kozlowski@gmail.com> wrote:
>> >> Sean Bartell <wingedtachikoma <at> gmail.com> writes:
>> >>> > Is there a more aggressive filesystem restorer than btrfsck?  =
It
>> >>> > simply gives up immediately with the following error:
>> >>> >=20
>> >>> > btrfsck: disk-io.c:739: open_ctree_fd: Assertion
>> >>> > `!(!tree_root->node)' failed.
>> >>>=20
>> >>> btrfsck currently only checks whether a filesystem is consistent=
=2E
It
>> >>> doesn't try to perform any recovery or error correction at all, =
so
>> >>> it's
>> >>> mostly useful to developers. Any error handling occurs while the
>> >>> filesystem is mounted.
>> >>=20
>> >> Is there any plan to implement this functionality. It would seem =
to
me
>> >> to be a pretty basic feature that is missing ?
>> >=20
>> > If Btrfs aims to be at least half of what ZFS is, then it will not
>> > impose a need for fsck at all.
>> >=20
>> > Read "No, ZFS really doesn't need a fsck" at the following URL:
>> >=20
>> >
http://www.c0t0d0s0.org/archives/6071-No,-ZFS-really-doesnt-need-a-fsck=
=2Eh
>> > tml
>>=20
>> Interesting idea. it would seem to me however that the functionality
>> described in that article is more concerned with a bad transaction
>> rather then something like a hardware failure where a block written
>> more then 128 transactions ago is now corrupted and consiquently the
>> entire partition is now unmountable( that is what I think i am looki=
ng
>> at with BTRFS )
>=20
> Still, the FS alone should be able to recover from such situations. W=
ith

> multiple superblocks the probability that the fs is unmountable is ve=
ry
> small
> and if all superblocks are corrupted then you need a data recovery
> prorgram,=20
> not fsck.

On Tue, 29 Jun 2010 18:34:13 +0200, Hubert Kario <hka@qbs.com.pl> wrote=
:
> On Tuesday 29 June 2010 12:37:45 Daniel Kozlowski wrote:
>> On Mon, Jun 28, 2010 at 10:31 PM, Rodrigo E. De Le=C3=B3n Plicet
>>=20
>> <rdeleonp@gmail.com> wrote:
>> > On Mon, Jun 28, 2010 at 8:48 AM, Daniel Kozlowski
>> >=20
>> > <dan.kozlowski@gmail.com> wrote:
>> >> Sean Bartell <wingedtachikoma <at> gmail.com> writes:
>> >>> > Is there a more aggressive filesystem restorer than btrfsck?  =
It
>> >>> > simply gives up immediately with the following error:
>> >>> >=20
>> >>> > btrfsck: disk-io.c:739: open_ctree_fd: Assertion
>> >>> > `!(!tree_root->node)' failed.
>> >>>=20
>> >>> btrfsck currently only checks whether a filesystem is consistent=
=2E
It
>> >>> doesn't try to perform any recovery or error correction at all, =
so
>> >>> it's
>> >>> mostly useful to developers. Any error handling occurs while the
>> >>> filesystem is mounted.
>> >>=20
>> >> Is there any plan to implement this functionality. It would seem =
to
me
>> >> to be a pretty basic feature that is missing ?
>> >=20
>> > If Btrfs aims to be at least half of what ZFS is, then it will not
>> > impose a need for fsck at all.
>> >=20
>> > Read "No, ZFS really doesn't need a fsck" at the following URL:
>> >=20
>> >
http://www.c0t0d0s0.org/archives/6071-No,-ZFS-really-doesnt-need-a-fsck=
=2Eh
>> > tml
>>=20
>> Interesting idea. it would seem to me however that the functionality
>> described in that article is more concerned with a bad transaction
>> rather then something like a hardware failure where a block written
>> more then 128 transactions ago is now corrupted and consiquently the
>> entire partition is now unmountable( that is what I think i am looki=
ng
>> at with BTRFS )
>=20
> Still, the FS alone should be able to recover from such situations. W=
ith

> multiple superblocks the probability that the fs is unmountable is ve=
ry
> small
> and if all superblocks are corrupted then you need a data recovery
> prorgram,=20
> not fsck.

While it would be great to have a filesystem that can recover from such
situations, or at least fail gracefully, I'd also like to be able to
verify/repair the filesystem offline, without mounting it and potential=
ly
making things worse. For example, say you have a single-disk filesystem=
,
and while it can detect corruption it can't repair it. That's the sort =
of
scenario where you want to specify what to do, interactively or with
command line options. I don't want the only choice to be bringing it
online and destructively forcing it into a consistent state based on
variables I don't control like when someone attempts to access the file=
=2E

Regards,

-Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
