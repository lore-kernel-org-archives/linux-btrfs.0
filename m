From: Ahmet Inan <xdsopl@googlemail.com>
Subject: Re: Premature ENOSPC only with zlib Compression
Date: Fri, 20 Jan 2012 19:55:42 +0100
Message-ID: <CAFDW0jKdq-uCG5Gkjccn-v7YdtTXFvrxH4Rcc+i8xv5ZwrNRbg@mail.gmail.com>
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

thank you very much for this info.

i did the same thing: compress=lzo

now i can do a full system installation to an fresh btrfs filesystem
without "--bwlimit 4096" to rsync again!

my kernel: vanilla 3.2.1

Ahmet
