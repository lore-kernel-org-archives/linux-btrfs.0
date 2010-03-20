From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: [PATCH] Btrfs: fix ENOSPC accounting when max_extent is not maxed
	out V2
Date: Sat, 20 Mar 2010 10:40:26 +0800
Message-ID: <3d0408631003191940t79022b7cja6c10fd275f30157@mail.gmail.com>
References: <20100318154730.GA20818@dhcp231-156.rdu.redhat.com>
	 <3d0408631003182009qaca6e9cp6c389dad257b987a@mail.gmail.com>
	 <20100319135948.GA2314@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100319135948.GA2314@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 19, 2010 at 9:59 PM, Josef Bacik <josef@redhat.com> wrote:
> On Fri, Mar 19, 2010 at 11:09:25AM +0800, Yan, Zheng =A0wrote:
>> On Thu, Mar 18, 2010 at 11:47 PM, Josef Bacik <josef@redhat.com> wro=
te:
>> > A user reported a bug a few weeks back where if he set max_extent=3D=
1m and then
>> > did a dd and then stopped it, we would panic. =A0This is because I=
 miscalculated
>> > how many extents would be needed for splits/merges. =A0Turns out I=
 didn't actually
>> > take max_extent into account properly, since we only ever add 1 ex=
tent for a
>> > write, which isn't quite right for the case that say max_extent is=
 4k and we do
>> > 8k writes. =A0That would result in more than 1 extent. =A0So this =
patch makes us
>> > properly figure out how many extents are needed for the amount of =
data that is
>> > being written, and deals with splitting and merging better. =A0I'v=
e tested this ad
>> > nauseum and it works well. =A0This version doesn't depend on my pe=
r-cpu stuff.
>> > Thanks,
>>
>> Why not remove the the max_extent check. The max length of file exte=
nt
>> is also affected by fragmentation level of free space. It doesn't ma=
ke sense
>> to introduce complex code to address one factor while lose sight of =
another
>> factor. I think reserving one unit of metadata for each delalloc ext=
ent in the
>> extent IO tree should be OK. because even a delalloc extent ends up =
with
>> multiple file extents, these file extents are adjacency in the b-tre=
e.
>>
>
> Do you mean remove the option for max_extent altogether, or just remo=
ve all of
> my code for taking it into account? =A0Thanks,
>

all of the code for taking max_extent into account
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
