From: Leonidas Spyropoulos <artafinde@gmail.com>
Subject: Re: Backporting Recent Btrfs Patches to 2.6.32
Date: Tue, 2 Nov 2010 19:36:55 +0000
Message-ID: <AANLkTikr88K5Yt6ewyDvA08UjKuAn5d8BEKq0_V6k34w@mail.gmail.com>
References: <AANLkTin0HMr2N_hRBu_um+Rf9o+Agjis4E6HLdxkebqv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTin0HMr2N_hRBu_um+Rf9o+Agjis4E6HLdxkebqv@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 15, 2010 at 8:23 PM, Mitch Harder
<mitch.harder@sabayonlinux.org> wrote:
> Since the 2.6.32 kernel is one of the long-term stable kernels, and
> since a few projects (such as OpenVZ) and distros (such as Debian) ar=
e
> using the 2.6.32 kernel, I've put together an experimental git branch
> to backport later btrfs patches to the 2.6.32 kernel.
>
> Let me know if there's any interest in this experiment, and I'll try
> to keep it maintained.
>
> I've placed a git repository containing this work here:
>
> http://gitweb.sabayon.org/?p=3Dlinux/kernel/btrfs-backport.git;a=3Dsu=
mmary
>
> The backport is currently in "works-for-me" status, and I have been
> using it for about a week without crashes.
>
> I did not attempt to backport every patch that has touched
> linux/fs/btrfs compared to the 2.6.32 kernel. =A0Some patches were pa=
rt
> of larger kernel updates that would be outside the scope of a
> backport.
>
> I was able to backport the DIO patches and the improvements to ENOSPC
> handling, as well as most of the other patches in the btrfs-unstable
> repository.
>
> Let me know if you have any feedback.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
Hi there,

I've been trying to install your kernel into my debian squezze/sid
system for test the new features of btrfs with failure so far.
My problem is that I have a 2.6.32 kernel and recent changes affecting
the btrfs system is not implemented so your repo seems like a
life-savior.

The only thing is that I am not able to fetch it.
I always stuck to
fatal: The remote end hung up unexpectedly

Also I wouldn't mind updating the kernel to newer ones although I am
not able to find any repositories with .deb files for 2.6.32 and
above. The only choise so far is experimental 2.6.36 repo which seems
to work but I don't have the linux-kbuild for installing the headers.
Thus the idea of building one myself.
Any suggestion of how to get the new changes of btrfs on my linux-box
would be welcome.

Thanks
Leonidas

PS: sorry if this is kinda out of the mailing-list topics.

--=20
Caution: breathing may be hazardous to your health.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
