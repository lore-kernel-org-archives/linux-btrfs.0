From: Dmitri Nikulin <dnikulin@gmail.com>
Subject: Re: metadata copied/data not copied?
Date: Tue, 17 Mar 2009 08:14:31 +1100
Message-ID: <3a7f57190903161414s2118b763q9bad5ce1046b54e5@mail.gmail.com>
References: <200903161035.19446.csights@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200903161035.19446.csights@fastmail.fm>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 17, 2009 at 1:35 AM, CSights <csights@fastmail.fm> wrote:
> Hi everyone,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0I'm curious what would happen in btrfs if =
the following commands were issued:
>
> # cp file1 file2
> # chown newuser:newgroup file2
>
> Where file1 was owned by olduser:oldgroup.
>
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0If I understand copy-on-write correctly th=
e "cp" would merely create a new
> pointer (or whatever it is called :( ) containing the files' metadata=
 but the
> file contents would not actually be duplicated.

Certainly not. cp is a userspace program with no knowledge of
filesystem details like COW or, as you describe, deduplicate.

The semantics you are looking for come with links, except that they
don't. Hard links are implemented at the filesystem level, but they
are not copy-on-write at the user space level - if you write to the
linked file it will appear via all other links too. Soft links are
nothing more than a transparent "shortcut" that happen to give most of
the semantics people want from hard links in a much more flexible way.
But neither allows a file to have contradictory ownership - you need
ACLs to hack up access rights to mimic that. Hard links and soft links
make multiple paths refer to the same file, not merely the same
contents with different metadata. Otherwise you could soft link
/bin/sh into your home directly, setuid the link, and own the machine.
Clearly this is not the case, and won't be with btrfs either.

And if you're not talking about soft or hard links, I've no idea how
you thought that would work. It is possible for a file system to
detect identical blocks between files, but without more guidance, it
would be very expensive to do so, and with questionable benefits.

--=20
Dmitri Nikulin

Centre for Synchrotron Science
Monash University
Victoria 3800, Australia
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
