From: cwillu <cwillu@cwillu.com>
Subject: Re: btrfs filesystem defragment error
Date: Mon, 8 Nov 2010 19:44:29 -0600
Message-ID: <AANLkTi=WgPRafvAUUsrNydLPuz4JEjW3DNLNHYSAbAj5@mail.gmail.com>
References: <AANLkTikjgmNmuEz2k-vm-f-O2roaC0+z1p7tNZT-poea@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Leonidas Spyropoulos <artafinde@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikjgmNmuEz2k-vm-f-O2roaC0+z1p7tNZT-poea@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 8, 2010 at 5:33 PM, Leonidas Spyropoulos
<artafinde@gmail.com> wrote:
> While on Ubuntu 10.10 I cannot get defragment working.
>
> inglor@selene:~$ btrfs filesystem defragment /media/Data/
> ioctl failed on /media/Data/ ret -1 errno 1
> total 1 failures
> ...
> Is it implemented on kernel 2.6.36 and above only?

You need to run it as root (via sudo or whatever).  On the other hand,
it probably doesn't work like you think it does, and you probably
don't want to defrag anyway :p

btrfs fi defrag takes a file or folder, and defrags just that file or
folder (i.e., no recursion).  If you wanted to defrag an entire tree,
you'd have to do something like "find /whatever | xargs -I{} btrfs fi
defrag {}" or some such.  This would have the effect of unlinking any
cow'd files, which isn't necessarily useful.

--Carey
