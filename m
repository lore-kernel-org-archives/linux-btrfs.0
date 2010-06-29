From: Daniel Kozlowski <dan.kozlowski@gmail.com>
Subject: Re: Is there a more aggressive fixer than btrfsck?
Date: Tue, 29 Jun 2010 06:37:45 -0400
Message-ID: <AANLkTilXNNQ8zxTGdjNBhI3kbMeTiT2tIN9PzjqHGWLz@mail.gmail.com>
References: <a51eea046c4dd444f9d90742beb41a6a.squirrel@webmail.sonic.net>
	<20100602155646.GA4041@flcl.lan>
	<loom.20100628T154422-48@post.gmane.org>
	<AANLkTilC9MjM7RK3b-8owdiRJUYnfmc0dIM5nt9Texla@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: =?ISO-8859-1?Q?Rodrigo_E=2E_De_Le=F3n_Plicet?= <rdeleonp@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTilC9MjM7RK3b-8owdiRJUYnfmc0dIM5nt9Texla@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 28, 2010 at 10:31 PM, Rodrigo E. De Le=F3n Plicet
<rdeleonp@gmail.com> wrote:
> On Mon, Jun 28, 2010 at 8:48 AM, Daniel Kozlowski
> <dan.kozlowski@gmail.com> wrote:
>> Sean Bartell <wingedtachikoma <at> gmail.com> writes:
>>
>>> > Is there a more aggressive filesystem restorer than btrfsck? =A0I=
t simply
>>> > gives up immediately with the following error:
>>> >
>>> > btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->n=
ode)'
>>> > failed.
>>>
>>> btrfsck currently only checks whether a filesystem is consistent. I=
t
>>> doesn't try to perform any recovery or error correction at all, so =
it's
>>> mostly useful to developers. Any error handling occurs while the
>>> filesystem is mounted.
>>>
>>
>> Is there any plan to implement this functionality. It would seem to =
me to be a
>> pretty basic feature that is missing ?
>
> If Btrfs aims to be at least half of what ZFS is, then it will not
> impose a need for fsck at all.
>
> Read "No, ZFS really doesn't need a fsck" at the following URL:
>
> http://www.c0t0d0s0.org/archives/6071-No,-ZFS-really-doesnt-need-a-fs=
ck.html
>

Interesting idea. it would seem to me however that the functionality
described in that article is more concerned with a bad transaction
rather then something like a hardware failure where a block written
more then 128 transactions ago is now corrupted and consiquently the
entire partition is now unmountable( that is what I think i am looking
at with BTRFS )


--=20
S.D.G.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
