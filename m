From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH/RFC] Btrfs: Add conditional ENOSPC debugging.
Date: Sun, 12 Feb 2012 17:49:40 -0600
Message-ID: <CAKcLGm9mUyT8uSzeFo6KgBedcCs4xrL2tFSuUFVVMHvpAcVeaw@mail.gmail.com>
References: <1328823521-8487-1-git-send-email-mitch.harder@sabayonlinux.org>
	<4F34E46B.8030109@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F34E46B.8030109@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 10, 2012 at 3:33 AM, Jan Schmidt <list.btrfs@jan-o-sch.net>=
 wrote:
> Hi Mitch,
>
> having this patch on the list is a good idea. I've two remarks, just =
in
> case it will be included sometimes:
>
> On 09.02.2012 22:38, Mitch Harder wrote:
>> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
>> index fe4cd0f..31b717f 100644
>> --- a/fs/btrfs/delayed-inode.c
>> +++ b/fs/btrfs/delayed-inode.c
>> @@ -656,8 +656,18 @@ static int btrfs_delayed_inode_reserve_metadata=
(
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* EAGAIN to make us stop the transact=
ion we have, so return
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* ENOSPC instead so that btrfs_dirty_=
inode knows what to do.
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> +#ifdef BTRFS_DEBUG_ENOSPC
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(ret =3D=3D -EAGAIN)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -ENOSPC;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (printk_ratelimit())
>
> From linux/printk.h:
> /*
> =A0* Please don't use printk_ratelimit(), because it shares ratelimit=
ing state
> =A0* with all other unrelated printk_ratelimit() callsites. =A0Instea=
d use
> =A0* printk_ratelimited() or plain old __ratelimit().
> =A0*/
>
> printk_ratelimited() seems the right choice, here.
>

OK, I'll change those.  Apparently, I was looking at some out-of-date e=
xamples.

>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KER=
N_WARNING
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0"btrfs: ENOSPC set in "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0"btrfs_delayed_inode_reserve_metadata\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> +#else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret =3D=3D -EAGAIN)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -ENOSPC;
>> +#endif
>
> I don't like the #if placements throughout the patch. Copying all the
> conditions is error prone (especially when changes are made later on)=
=2E
>
> I'd rather leave all the conditions as they stand (possibly adding th=
e
> unlikely() macro if you wish). Same for the following return statemen=
t
> or assignment. Simply put printk_ratelimited() into the #if ... #endi=
f.
>

The reason my #if macros became so large is that I often needed to
replace a simple if statement like:

if (condition)
        ret =3D -ENOSPC;

with a more complex if statement that required brackets

if (condition) {
        printk_ratelimited();
        ret =3D -ENOSPC;
}

I injected the 'unlikely' macro to minimize the impact of the expanded
if statements.  I've noticed that some Btrfs errors depend on speed
(or possibly lack thereof).

I'll review my #if macros, and see if I can tighten them up.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
