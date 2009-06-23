From: Miguel F Mascarenhas Sousa Filipe <miguel.filipe@gmail.com>
Subject: Re: Release plan
Date: Tue, 23 Jun 2009 11:09:35 +0100
Message-ID: <f058a9c30906230309y316920e1he31ab3bdb467c311@mail.gmail.com>
References: <loom.20090622T151046-988@post.gmane.org>
	 <f058a9c30906230308m2062bbdbs519d65389400e39e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <f058a9c30906230308m2062bbdbs519d65389400e39e@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

On Mon, Jun 22, 2009 at 4:53 PM, Mike Ramsey <michael.j.ramsey@lmco.com=
> wrote:
>
> I was looking at file systems for Linux, Ubuntu in particular. =C2=A0=
I really like
> Sun's ZPF. =C2=A0ZPF's copy-on-write transaction model strikes me as =
the correct
> way to go. =C2=A0But ZPF lacks a GNU General Public License which blo=
cks ZPF's
> adoption by the Linux kernel. This led me to btrfs.


You mean ZFS, but I think everybody who read this "self-corrected" your=
 typo.


>
> I understand that the B-TRee File System is a "copy-on-write file sys=
tem for
> Linux announced by Oracle in 2007 and published under the GNU General=
 Public
> License (GPL)".
>
> For planning purposes, what timeframe do you see for releasing a stab=
le
> version of btrfs? =C2=A0I am not a paying customer nor am I an annoyi=
ng manager. =C2=A0I
> am just curious as to when I should plan to start paying closer atten=
tion. =C2=A04Q
> 2009? 2Q 2010?

=46ilesystems take a long time to mature, btrfs is stable enough for
daily use, has long has you don't use it for sensitive/critical data.
There are still some problems, the most anoying being the premature
"out of space"/"disc full" errors.
I would say that in time for Fedora 12, you will probably have a btrfs
more usable for the common user, but still not advised for the faint
of heart.

Consider the time that ext4 took to mature and for people to trust it.
Ext4 is stable for quite some months, but even now, the majority of
recent distro builds choose ext3 has the default filesystem.

Again.. filesystems take quite a bit of time to mature...

disclaimer: I'm not a btrfs developer, just a entusiast that follows
the developement.


Kind regards,


--
Miguel Sousa Filipe
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
