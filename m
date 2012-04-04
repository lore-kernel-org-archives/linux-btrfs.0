From: James Courtier-Dutton <james.dutton@gmail.com>
Subject: Re: [PATCH] Btrfs: do not mount when we have a sectorsize larger than PAGE_SIZE
Date: Wed, 4 Apr 2012 10:17:59 +0100
Message-ID: <CAAMvbhFCB6X2urJr3kcUxnB1VoZMeW66rS_dYmPbJrSkvOgBZQ@mail.gmail.com>
References: <1333366098-32341-1-git-send-email-liubo2009@cn.fujitsu.com>
	<20120402121724.GD14256@twin.jikos.cz>
	<4F7A4F3B.3010108@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F7A4F3B.3010108@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 3 April 2012 02:15, Liu Bo <liubo2009@cn.fujitsu.com> wrote:
> On 04/02/2012 08:17 PM, David Sterba wrote:
>> On Mon, Apr 02, 2012 at 07:28:18PM +0800, Liu Bo wrote:
>>> --- a/fs/btrfs/disk-io.c
>>> +++ b/fs/btrfs/disk-io.c
>>> @@ -2104,6 +2104,14 @@ int open_ctree(struct super_block *sb,
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D -EINVAL;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto fail_alloc;
>>> =C2=A0 =C2=A0 =C2=A0}
>>> + =C2=A0 =C2=A0if (btrfs_super_sectorsize(disk_super) > PAGE_CACHE_=
SIZE) {
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printk(KERN_ERR "BTRFS: =
couldn't mount because sectorsize(%d)"
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 " =
was larger than PAGE_SIZE(%lu)\n",
>>
>> %llu
>>
>
> err, thanks for caching it.
>
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bt=
rfs_super_sectorsize(disk_super),
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (u=
nsigned long long)PAGE_CACHE_SIZE);
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D -EINVAL;
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto fail_alloc;
>>> + =C2=A0 =C2=A0}
>>>
>>> =C2=A0 =C2=A0 =C2=A0features =3D btrfs_super_incompat_flags(disk_su=
per);
>>> =C2=A0 =C2=A0 =C2=A0features |=3D BTRFS_FEATURE_INCOMPAT_MIXED_BACK=
REF;
>>
>> We have the opposite check a few lines below
>>
>> 2257 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (sectorsize < PAGE_SIZE) {
>> 2258 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(=
KERN_WARNING "btrfs: Incompatible sector size "
>> 2259 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0"found on %s\n", sb->s_id);
>> 2260 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto fa=
il_sb_buffer;
>> 2261 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> 2262
>>
>> so sectorsize must be equal to PAGE_SIZE always and one check can ca=
tch
>> both cases.
>>
>
> But this check is _useless_ when we have a sectorsize which is larger=
 than PAGE_SIZE,
> we're not ready for that, too.
>
> We already have one check, so I'll modify this instead. :)
>

Minor observation.
One is "PAGE_SIZE" and one is "PAGE_CACHE_SIZE".
Might those be different?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
