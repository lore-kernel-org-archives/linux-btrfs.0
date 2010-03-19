From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: fix ENOSPC accounting when max_extent is not
	maxed out V2
Date: Fri, 19 Mar 2010 09:59:48 -0400
Message-ID: <20100319135948.GA2314@localhost.localdomain>
References: <20100318154730.GA20818@dhcp231-156.rdu.redhat.com> <3d0408631003182009qaca6e9cp6c389dad257b987a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408631003182009qaca6e9cp6c389dad257b987a@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 19, 2010 at 11:09:25AM +0800, Yan, Zheng  wrote:
> On Thu, Mar 18, 2010 at 11:47 PM, Josef Bacik <josef@redhat.com> wrot=
e:
> > A user reported a bug a few weeks back where if he set max_extent=3D=
1m and then
> > did a dd and then stopped it, we would panic. =A0This is because I =
miscalculated
> > how many extents would be needed for splits/merges. =A0Turns out I =
didn't actually
> > take max_extent into account properly, since we only ever add 1 ext=
ent for a
> > write, which isn't quite right for the case that say max_extent is =
4k and we do
> > 8k writes. =A0That would result in more than 1 extent. =A0So this p=
atch makes us
> > properly figure out how many extents are needed for the amount of d=
ata that is
> > being written, and deals with splitting and merging better. =A0I've=
 tested this ad
> > nauseum and it works well. =A0This version doesn't depend on my per=
-cpu stuff.
> > Thanks,
>=20
> Why not remove the the max_extent check. The max length of file exten=
t
> is also affected by fragmentation level of free space. It doesn't mak=
e sense
> to introduce complex code to address one factor while lose sight of a=
nother
> factor. I think reserving one unit of metadata for each delalloc exte=
nt in the
> extent IO tree should be OK. because even a delalloc extent ends up w=
ith
> multiple file extents, these file extents are adjacency in the b-tree=
=2E
>=20

Do you mean remove the option for max_extent altogether, or just remove=
 all of
my code for taking it into account?  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
