From: Andrea Gelmini <andrea.gelmini@gmail.com>
Subject: Re: Problem with latest for-linus branch
Date: Mon, 30 May 2011 15:02:08 +0200
Message-ID: <BANLkTinFwJmu2KTpdVA+WTVL2jvxRZtifg@mail.gmail.com>
References: <BANLkTikmYx+K9crXYFeBmsJm+qUq9_W+gQ@mail.gmail.com>
	<1306620858-sup-7865@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1306620858-sup-7865@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

2011/5/29 Chris Mason <chris.mason@oracle.com>:
> Thanks, could you please send in the photos of the oops when you get
> chance.

By the way, switching from 2.6.38.7 to 2.6.39, I have a lot of this messages:
[  140.297248] block group 1107296256 has an wrong amount of free space
[  140.848435] block group 8623489024 has an wrong amount of free space
[  140.879178] block group 17213423616 has an wrong amount of free space
[  140.910181] block group 24729616384 has an wrong amount of free space
[  140.937690] block group 33319550976 has an wrong amount of free space
[  140.971150] block group 40835743744 has an wrong amount of free space
[  141.000816] block group 49425678336 has an wrong amount of free space
[  141.027175] block group 56941871104 has an wrong amount of free space
[  141.057614] block group 65531805696 has an wrong amount of free space
[  141.088269] block group 73047998464 has an wrong amount of free space
[  141.124767] block group 81637933056 has an wrong amount of free space
[  141.156891] block group 97744060416 has an wrong amount of free space
[  141.190143] block group 121366380544 has an wrong amount of free space
[  141.219235] block group 129956315136 has an wrong amount of free space

It also happens with 2.6.38.7, but lot less.
Should I worry?

Thanks again,
Andrea
