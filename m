From: cwillu <cwillu@cwillu.com>
Subject: Re: [PATCH] [RFC] Add btrfs autosnap feature
Date: Fri, 2 Mar 2012 06:04:08 -0600
Message-ID: <CAE5mzviFyib_=a5Yd_cegxTA7aAj3EQCPbXMK3fXk7Qx_A+37A@mail.gmail.com>
References: <1330484376-16178-1-git-send-email-anand.jain@oracle.com>
	<1330484376-16178-2-git-send-email-anand.jain@oracle.com>
	<CAE5mzvjiL+81AsSspTrE1A1BBiL27zJ1qK1oqCF27oL+-CG9Mw@mail.gmail.com>
	<20120302113421.GA6214@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Arvin Schnell <aschnell@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120302113421.GA6214@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

>> Perhaps all that is unnecessary: =C2=A0rather than doing the walk, w=
hy not
>> make use of btrfs subvolume find-new (or rather, the syscalls it
>> uses)?
>
> While developing snapper I faced similar problems and looked at
> find-new but unfortunately it is not sufficient. E.g. when a file
> is deleted find-new does not report anything, see the reply to my
> mail here one year ago [1]. Also for newly created empty files
> find-new reports nothing, the same with metadata changes.
>
> If I'm wrong or find-new gets extended I happy to implement it in
> snapper.

=46or a system-wide undo'ish sort of thing that I think autosnapper is
going for, it should work quite nicely, but you're right that it
doesn't help a whole lot with a backup system.  It can't tell you
which files were touched or deleted, but it will still tell you that
_something_ in the subvolume was touched, modified or deleted (at
least, as of the last commit), which is all you need if you're only
ever comparing it to its source.

-- Carey
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
