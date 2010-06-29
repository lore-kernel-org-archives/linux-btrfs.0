From: Freddie Cash <fjwcash@gmail.com>
Subject: Re: Is there a more aggressive fixer than btrfsck?
Date: Tue, 29 Jun 2010 14:36:14 -0700
Message-ID: <AANLkTinF7F5HijW2EuL8C6sv4myLwOaq-AtVCCYJG5Jq@mail.gmail.com>
References: <a51eea046c4dd444f9d90742beb41a6a.squirrel@webmail.sonic.net>
	<20100602155646.GA4041@flcl.lan>
	<loom.20100628T154422-48@post.gmane.org>
	<AANLkTilC9MjM7RK3b-8owdiRJUYnfmc0dIM5nt9Texla@mail.gmail.com>
	<AANLkTilXNNQ8zxTGdjNBhI3kbMeTiT2tIN9PzjqHGWLz@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: =?UTF-8?Q?Rodrigo_E=2E_De_Le=C3=B3n_Plicet?= <rdeleonp@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Daniel Kozlowski <dan.kozlowski@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTilXNNQ8zxTGdjNBhI3kbMeTiT2tIN9PzjqHGWLz@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 29, 2010 at 3:37 AM, Daniel Kozlowski
<dan.kozlowski@gmail.com> wrote:
> On Mon, Jun 28, 2010 at 10:31 PM, Rodrigo E. De Le=C3=B3n Plicet
> <rdeleonp@gmail.com> wrote:
>> On Mon, Jun 28, 2010 at 8:48 AM, Daniel Kozlowski
>> <dan.kozlowski@gmail.com> wrote:
>>> Sean Bartell <wingedtachikoma <at> gmail.com> writes:
>>>
>>>> > Is there a more aggressive filesystem restorer than btrfsck? =C2=
=A0It simply
>>>> > gives up immediately with the following error:
>>>> >
>>>> > btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->=
node)'
>>>> > failed.
>>>>
>>>> btrfsck currently only checks whether a filesystem is consistent. =
It
>>>> doesn't try to perform any recovery or error correction at all, so=
 it's
>>>> mostly useful to developers. Any error handling occurs while the
>>>> filesystem is mounted.
>>>>
>>>
>>> Is there any plan to implement this functionality. It would seem to=
 me to be a
>>> pretty basic feature that is missing ?
>>
>> If Btrfs aims to be at least half of what ZFS is, then it will not
>> impose a need for fsck at all.
>>
>> Read "No, ZFS really doesn't need a fsck" at the following URL:
>>
>> http://www.c0t0d0s0.org/archives/6071-No,-ZFS-really-doesnt-need-a-f=
sck.html
>>
>
> Interesting idea. it would seem to me however that the functionality
> described in that article is more concerned with a bad transaction
> rather then something like a hardware failure where a block written
> more then 128 transactions ago is now corrupted and consiquently the
> entire partition is now unmountable( that is what I think i am lookin=
g
> at with BTRFS )

In the ZFS case, this is handled by checksumming and redundant data,
and can be discovered (and fixed) via either reading the affected data
block (in which case, the checksum is wrong, the data is read from a
redundant data block, and the correct data is written over the
incorrect data) or by running a scrub.

Self-healing, checksumming, data redundancy eliminate the need for
online (or offline) fsck.

Automatic transaction rollback at boot eliminates the need for fsck at
boot, as there is no such thing as "a dirty filesystem".  Either the
data is on disk and correct, or it doesn't exist.  Yes, you may lose
data.  But you will never have a corrupted filesystem.

Not sure how things work for btrfs.


--=20
=46reddie Cash
fjwcash@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
