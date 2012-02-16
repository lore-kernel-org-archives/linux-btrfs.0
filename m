From: Ahmet Inan <xdsopl@googlemail.com>
Subject: Re: Premature ENOSPC only with zlib Compression
Date: Thu, 16 Feb 2012 09:06:52 +0100
Message-ID: <CAFDW0jLfLtEpnijsratvGho8RzC9D7nJD8H2y0SdZ6AxYeGpYw@mail.gmail.com>
References: <CAKcLGm--EKeAbw7JzBtv7snhXEJSzTMZjn9_QDT+jGRCWsjM2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKcLGm--EKeAbw7JzBtv7snhXEJSzTMZjn9_QDT+jGRCWsjM2g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 18, 2012 at 5:13 PM, Mitch Harder
<mitch.harder@sabayonlinux.org> wrote:
> I have a Btrfs partition that is reliably reproducing premature ENOSPC
> when restoring the disk from a tar file, but it is only happening with
> zlib compression (lzo or no compression proceeds normally).

Ive just unsquashfs'ed an 5GiB image on a fresh btrfs and a much
faster System using:

compress=lzo,noatime

and got ENOSPC again :(

so it doesnt matter if lzo or zlib: ENOSPC with compression enabled!

my kernel: vanilla 3.2.5

for testing, i suggest making a squashfs of your whole system "/" and
unsquashfs that image into a new subvolume.
this really seems to trigger this ENOSPC problem, because it creates
the files fast enough.

Ahmet
