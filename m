Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tty0.vserver.softronics.ch ([91.214.169.36]:37200 "EHLO
        fe1.digint.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727781AbeITDmL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 23:42:11 -0400
Subject: Re: [RFC PATCH v2 0/4] btrfs-progs: build distinct binaries for
 specific btrfs subcommands
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
References: <20180912144604.6178-1-axel@tty0.ch>
From: Axel Burri <axel@tty0.ch>
Message-ID: <3ceee37e-66f5-e2f8-dbc9-fde2452a6447@tty0.ch>
Date: Thu, 20 Sep 2018 00:02:22 +0200
MIME-Version: 1.0
In-Reply-To: <20180912144604.6178-1-axel@tty0.ch>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In Reply to:

On 30/08/2018 04.38, Misono Tomohiro wrote:
>
> Hello,
>
> Not directly related this series and just FYI,
> I'm working to allow sub show/list to non-privileged user as long
> as he can access to the subvolume:
>   https://www.spinics.net/lists/linux-btrfs/msg79285.html
>
> Hopefully this will be merged to master in near future
> (any comments from user/dev is welcome).
>
> Thanks,
> Misono
>

I found some time to play around with your patchset, it worked fine on
4.18.8-gentoo kernel.

As far as I can see, only "btrfs subvolume show" and "btrfs subvolume
list" makes sense for a regular user?

With the "cmds-separated-fscaps-v2" patchset [1], you can build
separated binaries as follows:

    # make btrfs-subvolume-list.separated
    # make btrfs-subvolume-show.separated

Now not everybody wants to install these with fscaps or setuid, but it
might also make sense to provide "/usr/bin/btrfs-subvolume-{show,list}",
as they now work for a regular user. Having both root/user binaries
concurrently is not an issue (e.g. in gentoo the full-featured btrfs
command is in "/sbin/").

Last time I checked, debian installs it to "/bin/btrfs", which from my
perspective seems to be the preferred location as soon as Misonos patch
is merged.

 [1] https://github.com/digint/btrfs-progs/tree/cmds-separated-fscaps-v2
