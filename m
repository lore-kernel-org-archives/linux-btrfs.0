From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: [PATCH 0/2] btrfs: a new tool to manage a btrfs filesystem
Date: Fri, 12 Feb 2010 11:32:15 -0800
Message-ID: <93cdabd21002121132w5d6e543bpa4147066345201aa@mail.gmail.com>
References: <201002122001.09898.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Goffredo Baroncelli <kreijack@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201002122001.09898.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 12, 2010 at 11:01 AM, Goffredo Baroncelli
<kreijack@gmail.com> wrote:
> Usage:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs delete|-D <subvolume>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Delete the sub=
volume <subvolume>.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs defrag|-d <file>|<dir> [<file>|<dir>=
=2E..]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Defragment a f=
ile or a directory.

I think the short options should be removed or else you'll still have
the easy misuses of btrfs -d and btrfs -D.

The best example would be the "ip" command which has commands and
-[a-z] options that do different types of things.  for instance, all
of the short options are applicable to all commands and change the
verbosity or format of the output.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
