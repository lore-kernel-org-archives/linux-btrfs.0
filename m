From: C Anthony Risinger <anthony@extof.me>
Subject: Re: default subvolume abilities/restrictions
Date: Wed, 19 May 2010 09:55:19 -0500
Message-ID: <AANLkTimMAJ7WOgerdxp-yxlRvT9SaREnumqFFQ85VeOL@mail.gmail.com>
References: <AANLkTilY3SUN01IRz1mkKPlkMAJabJr-hYiWazPpeXsx@mail.gmail.com>
	 <m3y6fg7z23.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Chris Ball <cjb@laptop.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m3y6fg7z23.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 19, 2010 at 9:20 AM, Chris Ball <cjb@laptop.org> wrote:
> Hi,
>
> =A0 > moving along to a question... can the default subvolume be
> =A0 > swapped/removed/renamed/popped/shifted?
>
> I think "btrfs subvolume list; btrfs subvolume set-default <id> <path=
>"
> does what you need.
>
> - Chris.

maybe i'm missing something or not being clear.  take the following
setup for the "." subvol:

/
/etc
/usr
/lib

if i snapshot / to /__active i now have:

/
/etc
/usr
/lib
/__active

i now "btrfs subvolume set-default
<whatever_the_internal_id_is_for_active> /"... what happens to the
directories /usr, /etc, and /lib that _still_ exist in the "." subvol?
 it's my understanding that setting the default subvol DOES NOT
actually do anything except negate the need to use the "subvol=3D<id>"
mount option... the "." subvolume still exists, still can be mounted
independently, still has files in it, and still is a parent the the
now default __active subvol and thus CANNOT be removed.

can i be confirmed on this reasoning?  it seems to me that the
original subvolume is somewhat immutable in its location and relation
to other, "child" subvolumes.  it's the only one that cannot be
"placed" into a different subvolume; it MUST be the ultimate parent.

am i off base here or misinterpreting what "set-default" actually does
(Arch is still on 2.6.33, i can't use set-default yet so i admit i
haven't really played with it yet)?  i wouldn't think that simply
setting a new default is the same as setting a new top-level
subvolume; am i wrong?

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
