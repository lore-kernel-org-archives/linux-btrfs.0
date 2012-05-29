Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41464 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab2E2ODG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 May 2012 10:03:06 -0400
MIME-Version: 1.0
In-Reply-To: <4FC48570.404@panasas.com>
References: <CAB9VWqAUkHH2xBXZ+edTSCffiLtEXamfugKrPZ6T0Py92kyZdA@mail.gmail.com>
	<4FC48570.404@panasas.com>
Date: Tue, 29 May 2012 16:03:05 +0200
Message-ID: <CAB9VWqAN40ObJ9=CMP1BvupfGJN9NYTuWLTpcrsBwTd6ifz=-A@mail.gmail.com>
Subject: Re: atime and filesystems with snapshots (especially Btrfs)
From: Alexander Block <ablock84@googlemail.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 29, 2012 at 10:14 AM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>
> Sounds like a real problem. I would suggest a few remedies.
> 1. Make a filesystem persistent parameter that says noatime/relatime/atime
>   So the default if not specified on mount is taken as a property of
>   the FS (mkfs can set it)
That would be possible. But again, I'm not sure if it is allowed for
one fs type to
differ from all the other filesystems in its default behavior.
> 2. The snapshot program should check and complain if it is on, and recommend
>   an off. Since the problem only starts with a snapshot.
That would definitely cause awareness for the problem and many people would
probably switch to noatime on mount.
> 3. If space availability drops under some threshold, disable atime. As you said
>   this is catastrophic in this case. So user can always search and delete files.
>   In fact if the IO was only because of atime, it should be a soft error, warned,
>   and ignored.
It would be hard to determine a good threshold. This really depends on the way
snapshots are used.
>
> But perhaps the true solution is to put atime on a side table, so only the atime
> info gets COW and not the all MetaData
This would definitely reduce the problem to a minimum. But it may be harder
to implement as it sounds. You would either have to keep 2 trees per subvolume
(one for the fs and one for atime) or share one tree for all subvols.
I don't think
2 trees per subvolume would be acceptable, but I'm not sure. A shared tree
would require to implement some kind of custom refcounting for the items, as
changes to one fs tree should not change atime of the other and thus create
new items on demand. It would probably also require snapshot origin tracking,
because on a freshly snapshotted subvolume, no atime entries would exist at
all and must be read from the parent/origin.
>
> Just my $0.017
> Boaz
>
>> Alex.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
