From: Fred van Zwieten <fvzwieten@gmail.com>
Subject: Re: remote mirroring in the works?
Date: Mon, 30 Aug 2010 19:07:16 +0200
Message-ID: <AANLkTimBVG3eGHvNUHFGYri+JyOXrOW91GKWeM_GVOYM@mail.gmail.com>
References: <AANLkTinmSdHwXXq3s64sM39GjacafgwgTjPadZGHuway@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinmSdHwXXq3s64sM39GjacafgwgTjPadZGHuway@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

I would like to know if there is something functionally equivalent to
NetApp's SnapMirror in the works or planning? It would require block
level access to a snap and the ability to rebuild (subvolumes
including it's) snap's on another machine.

If not, what would be the best way to build something more or less
equivalent using existing tools? rsync-ing a snap seems the same, but
it isn't. First of all it 's file based, not very nice for DB's, and
you don't get the snap's on "the other side" the same.

Fred
