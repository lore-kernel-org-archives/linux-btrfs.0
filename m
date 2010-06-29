From: =?UTF-8?Q?Rodrigo_E=2E_De_Le=C3=B3n_Plicet?= <rdeleonp@gmail.com>
Subject: Re: Is there a more aggressive fixer than btrfsck?
Date: Mon, 28 Jun 2010 21:31:49 -0500
Message-ID: <AANLkTilC9MjM7RK3b-8owdiRJUYnfmc0dIM5nt9Texla@mail.gmail.com>
References: <a51eea046c4dd444f9d90742beb41a6a.squirrel@webmail.sonic.net>
	<20100602155646.GA4041@flcl.lan> <loom.20100628T154422-48@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Daniel Kozlowski <dan.kozlowski@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20100628T154422-48@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 28, 2010 at 8:48 AM, Daniel Kozlowski
<dan.kozlowski@gmail.com> wrote:
> Sean Bartell <wingedtachikoma <at> gmail.com> writes:
>
>> > Is there a more aggressive filesystem restorer than btrfsck? =C2=A0=
It simply
>> > gives up immediately with the following error:
>> >
>> > btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->no=
de)'
>> > failed.
>>
>> btrfsck currently only checks whether a filesystem is consistent. It
>> doesn't try to perform any recovery or error correction at all, so i=
t's
>> mostly useful to developers. Any error handling occurs while the
>> filesystem is mounted.
>>
>
> Is there any plan to implement this functionality. It would seem to m=
e to be a
> pretty basic feature that is missing ?

If Btrfs aims to be at least half of what ZFS is, then it will not
impose a need for fsck at all.

Read "No, ZFS really doesn't need a fsck" at the following URL:

http://www.c0t0d0s0.org/archives/6071-No,-ZFS-really-doesnt-need-a-fsck=
=2Ehtml
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
