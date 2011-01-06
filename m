From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: Offline Deduplication for Btrfs
Date: Thu, 6 Jan 2011 16:25:53 +0800
Message-ID: <AANLkTim1haTSJfUyZEw1OX9mnMgj6ahg5AdWMNrb=6Cm@mail.gmail.com>
References: <1294245410-4739-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1294245410-4739-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 6, 2011 at 12:36 AM, Josef Bacik <josef@redhat.com> wrote:
> Here are patches to do offline deduplication for Btrfs. =A0It works w=
ell for the
> cases it's expected to, I'm looking for feedback on the ioctl interfa=
ce and
> such, I'm well aware there are missing features for the userspace app=
 (like
> being able to set a different blocksize). =A0If this interface is acc=
eptable I
> will flesh out the userspace app a little more, but I believe the ker=
nel side is
> ready to go.
>
> Basically I think online dedup is huge waste of time and completely u=
seless.
> You are going to want to do different things with different data. =A0=
=46or example,
> for a mailserver you are going to want to have very small blocksizes,=
 but for
> say a virtualization image store you are going to want much larger bl=
ocksizes.
> And lets not get into heterogeneous environments, those just get much=
 too
> complicated. =A0So my solution is batched dedup, where a user just ru=
ns this
> command and it dedups everything at this point. =A0This avoids the ve=
ry costly
> overhead of having to hash and lookup for duplicate extents online an=
d lets us
> be _much_ more flexible about what we want to deduplicate and how we =
want to do
> it.
>
> For the userspace app it only does 64k blocks, or whatever the larges=
t area it
> can read out of a file. =A0I'm going to extend this to do the followi=
ng things in
> the near future
>
> 1) Take the blocksize as an argument so we can have bigger/smaller bl=
ocks
> 2) Have an option to _only_ honor the blocksize, don't try and dedup =
smaller
> blocks
> 3) Use fiemap to try and dedup extents as a whole and just ignore spe=
cific
> blocksizes
> 4) Use fiemap to determine what would be the most optimal blocksize f=
or the data
> you want to dedup.
>
> I've tested this out on my setup and it seems to work well. =A0I appr=
eciate any
> feedback you may have. =A0Thanks,
>

=46YI: Using clone ioctl can do the same thing (except reading data and
computing hash in user space).

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
