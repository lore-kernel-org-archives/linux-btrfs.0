From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: [PATCH 3/6] direct-io: do not merge logically non-contiguous
	requests
Date: Fri, 21 May 2010 18:47:36 -0700
Message-ID: <AANLkTikwPL8-WefVIMF1ldTZpWVHvS1Lbh4YB8MZ4eu0@mail.gmail.com>
References: <1274461422-18433-1-git-send-email-josef@redhat.com>
	 <1274461422-18433-3-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, hch@infradead.org,
	akpm@linux-foundation.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1274461422-18433-3-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 21, 2010 at 10:03 AM, Josef Bacik <josef@redhat.com> wrote:
> Btrfs cannot handle having logically non-contiguous requests submitte=
d. =C2=A0For
> example if you have
>
> Logical: =C2=A0[0-4095][HOLE][8192-12287]
> Physical: [0-4095] =C2=A0 =C2=A0 =C2=A0[4096-8191]
>
> Normally the DIO code would put these into the same BIO's. =C2=A0The =
problem is we
> need to know exactly what offset is associated with what BIO so we ca=
n do our
> checksumming and unlocking properly, so putting them in the same BIO =
doesn't
> work. =C2=A0So add another check where we submit the current BIO if t=
he physical
> blocks are not contigous OR the logical blocks are not contiguous.
>
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>
> V1->V2
> -Be more verbose in the in-code comment
>
> =C2=A0fs/direct-io.c | =C2=A0 20 ++++++++++++++++++--
> =C2=A01 files changed, 18 insertions(+), 2 deletions(-)
>

Btrfs has been pretty much self-contained (working well compiled
against 2.6.32 for example).  Is there a way that this wouldn't just
start silently breaking for people compiling the latest btrfs with
dkms against older kernels?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
