From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: kernel BUG at extent-tree.c:3162 (get_restripe_target)
Date: Fri, 6 Apr 2012 20:05:29 +0300
Message-ID: <20120406170529.GA1907@zambezi.lan>
References: <CAKcLGm8SgQchrk1fVg0FZ9uqr1v+cLzoWt1jk7vsJdZVfA72pA@mail.gmail.com>
 <20120406154314.GI14256@twin.jikos.cz>
 <CAKcLGm990SucW0qUHfiG75=jWQid-q8hJ0cCgJLWMATpGWvQnw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: dave@jikos.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKcLGm990SucW0qUHfiG75=jWQid-q8hJ0cCgJLWMATpGWvQnw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 06, 2012 at 10:52:13AM -0500, Mitch Harder wrote:
> On Fri, Apr 6, 2012 at 10:43 AM, David Sterba <dave@jikos.cz> wrote:
> > On Fri, Apr 06, 2012 at 10:33:04AM -0500, Mitch Harder wrote:
> >> I'm consistently hitting the BUG_ON in the new get_restripe_target
> >> function that was added by "[PATCH 4/8] Btrfs: add
> >> get_restripe_target() helper" when trying to initially mount a btr=
fs
> >> partition.
> >>
> >> Lines fs/btrfs/extent-tree.c:3161-3162:
> >>
> >> =C2=A0 =C2=A0 =C2=A0 BUG_ON(!mutex_is_locked(&fs_info->volume_mute=
x) &&
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!spin_is_locked(&f=
s_info->balance_lock));
> >
> > Is it a single CPU machine? See
> >
> > http://www.spinics.net/lists/linux-btrfs/msg15884.html
> >
>=20
> Thanks!
>=20
> Yes, this is a single CPU machine.  I'll test the solution from that =
thread.

Sorry about that.  I'm going to hold off a bit to see if there will be
any objections to v2 from that thread, but we will definitely do
something about this by rc3 or rc4 at worst.

Thanks,

		Ilya
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
