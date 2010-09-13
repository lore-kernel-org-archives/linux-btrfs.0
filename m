From: David Nicol <davidnicol@gmail.com>
Subject: Re: reserving an IOCTL number; other details
Date: Mon, 13 Sep 2010 15:15:55 -0500
Message-ID: <AANLkTi=RFO1kQEQ3FJYJ2XBYh4++TDYakrLxhoQDwA3k@mail.gmail.com>
References: <AANLkTi=GzqHy5h2gAmkQSSMQOCaYza=yTtWZrcyd8RSC@mail.gmail.com>
	<AANLkTinWg7o3KwDS9vHKpZV0mUyk6xKsuFvwVUjiynPk@mail.gmail.com>
	<201009131923.53227.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: kreijack <kreijack@libero.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201009131923.53227.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

https://btrfs.wiki.kernel.org/index.php/Category:Documentation does
not mention any btrfs command. the btrfsctl command has the -c sync
tool, and the tools for creating and deleting snapshots and
subvolumes, so it seems that unless this btrfs program does all of
that I have amended the right tool to provide a command line access to
a new ioctl that waits for deleted subvolume cleanups to finish.

Nothing on https://btrfs.wiki.kernel.org/index.php/Btrfsctl says
anything about deprecation or obsolescence.

On Mon, Sep 13, 2010 at 12:23 PM, Goffredo Baroncelli
<kreijack@gmail.com> wrote:
> Hi David,
>
> please don't do that. "btrfsctl" is obsolete, now the develop should involve
> the "btrfs" command.
> I you need help in updating the "btrfs" command source files, don't hesitate
> to contact me.
>
> Regards
> G.Baroncelli
