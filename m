From: cwillu <cwillu@cwillu.com>
Subject: Re: [GIT PULL][PATCH v2 0/6] btrfs: Add lzo compression support
Date: Thu, 23 Dec 2010 23:35:28 -0600
Message-ID: <AANLkTi=jGNaV-Sm+GsCHtwGx1UkG8bUyvGgz+2KLPgUT@mail.gmail.com>
References: <4CE48ABB.5070302@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Mitch Harder <mitch.harder@sabayonlinux.org>,
	linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CE48ABB.5070302@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 17, 2010 at 8:08 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Hi Chris,
>
> Here's the updated patchset. As I still haven't got a kernel.org
> account, I have set up a git tree in another public git repository,
> and I'll use it for now.
>
> You can pull from:
>
> =A0 =A0 =A0 =A0git://repo.or.cz/linux-btrfs-devel.git lzo-support
>
>
> Lzo is a much faster compression algorithm than gzib, so would allow
> more users to enable transparent compression, and some users can
> choose from compression ratio and compression speed.
>
> Usage:
>
> # mount -t btrfs -o compress[=3D<zlib,lzo>] dev /mnt
> or
> # mount -t btrfs -o compress-force[=3D<zlib,lzo>] dev /mnt
>
> "-o compress" without argument is still allowed for compatability.

This doesn't seem to work with -o remount.  "mount / -o
remount,compress=3Dlzo" fails with "[90192.345382] btrfs: unrecognized
mount option 'compress=3Dlzo'".  The -clzo option to defrag works fine.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
