From: Vincent Vanackere <vincent.vanackere@gmail.com>
Subject: Re: [PATCH] Btrfs: Check for NULL page in extent_range_uptodate
Date: Tue, 31 Jan 2012 10:06:22 +0100
Message-ID: <CAMpZLrianuaSdLhUvQcsKuQOD8WA-ttOVjX-2ekCzFNuq7oK1Q@mail.gmail.com>
References: <1327518224-4103-1-git-send-email-mitch.harder@sabayonlinux.org>
 <CAMpZLrg13VfO=3iX1+C90Oxrb5Ko9UCiQGk6AxX3oQ7Wz3Pbxg@mail.gmail.com> <CAKcLGm-o7Z-cfODSQjRx0v3yq=D5ZEWyqbhvpx+GBP-wLCXuAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKcLGm-o7Z-cfODSQjRx0v3yq=D5ZEWyqbhvpx+GBP-wLCXuAQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 31, 2012 at 00:13, Mitch Harder
<mitch.harder@sabayonlinux.org> wrote:

> Jeff Mahoney has been working on a large overhaul of error
> handling/BUG_ONs. =C2=A0It is difficult to say when it =C2=A0will be =
ready, or
> if it will even address this specific problem.
>
> I'd go ahead and return the disk. =C2=A0I doubt you'll be the last us=
er to
> have bad sectors, so there'll be more opportunities to see how this
> issue is handled after the changes to error handling.

Ok I'm returning the disk now. Thanks for the help !
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
