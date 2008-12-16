From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: weird bash autocomplete issue
Date: Tue, 16 Dec 2008 20:47:22 +0100
Message-ID: <ac3eb2510812161147q1ff0be0ev464237d6ba5d2338@mail.gmail.com>
References: <098b01c95fb5$bc2d1440$0301a8c0@bui.materna.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Roland <devzero@web.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <098b01c95fb5$bc2d1440$0301a8c0@bui.materna.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 16, 2008 at 20:37, Roland <devzero@web.de> wrote:
> i have come across a weird autocomplete issue i assume it is related to
> btrfs.
>
> let`s have some dirs:
>
> /non-btrfs-mount
>   ./linux
>   ./testdir
>
> /brtfs-mount
>   ./linux
>   ./testdir
>
> now, if i do "cd t<tab>" in /non-btrfs-mount, "t" autocompletes to "testdir"
> same for l<tab>inux - bash autocompletes as expected.
>
> now, the weird thing is, that on /btrfs-mount this behaves different.
>
> autocompletion for testdir works, but not for linux dir. weird.
>
> can someone reproduce this ?

Open another shell, find the bash process pid of the first shell with:
  ps afx
and do:
  strace -p <pid>
Go back to the first shell, hit <tab>, and the trace should show
what's going on. You see a significant difference there?

Kay
