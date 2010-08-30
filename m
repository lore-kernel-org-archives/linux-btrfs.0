From: "K. Richard Pixley" <rich@noir.com>
Subject: Re: remote mirroring in the works?
Date: Mon, 30 Aug 2010 10:55:19 -0700
Message-ID: <4C7BF087.6060400@noir.com>
References: <AANLkTinmSdHwXXq3s64sM39GjacafgwgTjPadZGHuway@mail.gmail.com> <AANLkTimBVG3eGHvNUHFGYri+JyOXrOW91GKWeM_GVOYM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Fred van Zwieten <fvzwieten@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimBVG3eGHvNUHFGYri+JyOXrOW91GKWeM_GVOYM@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

  On 20100830 10:07, Fred van Zwieten wrote:
> Hi there,
>
> I would like to know if there is something functionally equivalent to
> NetApp's SnapMirror in the works or planning? It would require block
> level access to a snap and the ability to rebuild (subvolumes
> including it's) snap's on another machine.
>
> If not, what would be the best way to build something more or less
> equivalent using existing tools? rsync-ing a snap seems the same, but
> it isn't. First of all it 's file based, not very nice for DB's, and
> you don't get the snap's on "the other side" the same.
>
> Fred
I think drbd does precisely what you want.

It's not useful for fault tolerance, nor for load balancing, but it will 
produce a remote block copy that can be used as a sort of "hot backup".

You can also do something very similar by combining LVM, (the logical 
volume manager), with LVM snapshots and NBD, (the network block device) 
by mirroring to an NBD device.

Neither of these approaches can tolerate the remote file system being 
"live" until and unless it takes over for the primary.  But either can 
maintain a dynamic remote block device.

--rich
