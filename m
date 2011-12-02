From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: btrfs errors
Date: Fri, 2 Dec 2011 19:38:40 +0700
Message-ID: <CAG1y0sdaMA=ei=v7tGHmUT1qT3ELftoqUHnO-jXmjfE5LvpC_A@mail.gmail.com>
References: <AFB7E63B2FEE4449B3DBF47BC3AA36F085956971@server2k8.thomii.com>
	<000501ccb0ee$b92cd590$2b8680b0$@thomii.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Mike Thomas <btrfs@thomii.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <000501ccb0ee$b92cd590$2b8680b0$@thomii.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 2, 2011 at 7:34 PM, Mike Thomas <btrfs@thomii.com> wrote:
> Hi, I've been using btrfs for a while now, I've been utilizing snapsh=
otting
> nightly/weekly/monthly.=A0 During the weekly I also do a backup of th=
e
> filesystem to an ext4 filesystem.=A0 My storage is a linux md raid 5 =
volume.
> I've recently noticed these errors in the logs during the backup of t=
he
> files to the ext4 filesystem.=A0 I am running RHEL 6.1
> (2.6.32-131.0.15.el6.x86_64)

that's like dinosaur age, in btrfs terms :P

>
> I'd like to help in any way I can so I thought I'd post here to see i=
f there
> is anything I can do to help.

I'd try compiling latest 3.2-rc kernel. or Chris' for-linus tree
(http://git.kernel.org/?p=3Dlinux/kernel/git/mason/linux-btrfs.git;a=3D=
shortlog;h=3Drefs/heads/for-linus)
which is based on 3.1, and see if it goes away.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
