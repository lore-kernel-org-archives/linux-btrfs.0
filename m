From: cwillu <cwillu@cwillu.com>
Subject: Re: Balancing takes "forever"
Date: Sat, 2 Jul 2011 00:47:40 -0600
Message-ID: <CAE5mzvib3TsOK+FH9URbmJyOpM0EJihnPyqNYah=mmsXfFxCeg@mail.gmail.com>
References: <iulhuk$j0f$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Christian <cdysthe@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <iulhuk$j0f$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 1, 2011 at 4:32 PM, Christian <cdysthe@gmail.com> wrote:
> I tried to balance my home folder. The disk spins and after an hour it
> hasn't completed. This is a 300 GB home directory about half full. I know
> balance takes while, but how long should it take? This is a 7200 rpm disk on
> a dual 2 ghz processor laptop running Linux Mint 11 and btrfs 0.19. It has
> an ext2 /boot, a btrfs / and btrfs /home partitions. The btrfs partitions
> have compression enabled.

Balance currently rewrites everything, and does it in a
not-terribly-efficient way.  It's probably done by now (8 hours since
your message), which isn't unusual.  There's some improvements in the
pipeline, but they're not in a released kernel yet.
