Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60805 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbaEWOes (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 May 2014 10:34:48 -0400
Message-ID: <537F5C85.9000000@suse.com>
Date: Fri, 23 May 2014 10:34:45 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: dsterba@suse.cz, Chris Mason <clm@fb.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: don't remove raid type sysfs entries until unmount
References: <537D40EB.60906@fb.com> <537D5136.4050007@suse.com> <537DEB3F.5020303@fb.com> <537E1242.1010109@suse.com> <537E313E.8050906@fb.com> <20140523123849.GE5346@suse.cz> <537F4566.2000907@suse.com> <20140523143246.GF5346@suse.cz>
In-Reply-To: <20140523143246.GF5346@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 5/23/14, 10:32 AM, David Sterba wrote:
> On Fri, May 23, 2014 at 08:56:06AM -0400, Jeff Mahoney wrote:
>> Sigh. Yep. kobject_cleanup caches ->name before the release
>> function and ignores the cleared value. It seems the "free name
>> if we alloced it" comment in there was leftover from the middle
>> of a patch series Kay applied in late 2007. Commit 0f4dafc05 adds
>> the comment while adding a flag to indicate that
>> kobject_set_name_vargs set the name. The commit af5ca3f4e says
>> kobject names must be dynamic but didn't update the comment.
>> 
>> Ok, so we can't save the strdup.
> 
> The tests have been running fine for more than 40 minutes,
> previously it took a few minutes to trigger the bug.
> 
> my quick fix:
> 
> --- a/fs/btrfs/extent-tree.c +++ b/fs/btrfs/extent-tree.c @@
> -8354,7 +8354,8 @@ static void __link_block_group(struct
> btrfs_space_info *space_info, int ret;
> 
> kobject_get(&space_info->kobj); /* put in release */ -
> kobj->name = get_raid_name(index); +               kobj->name =
> kstrdup(get_raid_name(index), GFP_ATOMIC); +
> BUG_ON(!kobj->name); ret = kobject_init_and_add(kobj,
> &btrfs_raid_ktype, &space_info->kobj, NULL); if (ret) { diff --git
> a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c index
> d742d7973d3e..ac26f91968a7 100644 --- a/fs/btrfs/sysfs.c +++
> b/fs/btrfs/sysfs.c @@ -288,7 +288,7 @@ static struct attribute
> *raid_attributes[] = {
> 
> static void release_raid_kobj(struct kobject *kobj) { -
> kobj->name = NULL; +       /* kobj->name = NULL; */ 
> kobject_put(kobj->parent); }
> 

I'm testing as well. I'm seeing:
kobject (ffff88033f847e78): tried to init an initialized object,
something is seriously wrong.

.. as well. A memset would clear this up, but perhaps that's not the
right solution after all.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)

iQIcBAEBAgAGBQJTf1yEAAoJEB57S2MheeWyZCkQAK09TN//RPDTlTidMwg76LOh
As1Q+dHPvCnIa3nvlI4XpCtVaIdOHiaDzGLHOSA/Dfq3PpNvETg/9R5eqcnMEXN+
W74Wr+ZJ5iwSq5jeMP4p73Ph+Dwzmc6OVr7mD4+CqVkdMuPBzWBl+aKA6d1UEWFb
2J/nUTS4EQz9I7O6UBgXt0pkZXavwp0gqqpHn4YV848gAnNyz6qhHe3nXLS/3XCW
LX3WUS1HROoD2fTzKMSxlw1xHiHFZ2XItOMgP9Ma1pr/cQA1InGxTCIVshtkx8Hq
uxgSorK/6H0iRsCVRuXX6JowYodX3UJ9x3VUQQbpI5sm5X6OlPzcwS9C4MqjjVNn
3Qqx7CJk79+CZBcBYMdK2borjrmCzQeyGQb49cH4eVNKUYLL2ja/ygoFq7aKOMgc
dTuZbcwQc43uVm768fAxTYEDqJEdHI+LUKoK05XDEm6SbaDt81T2to0wxyJjpiE3
rbNmS1ubjE+WvoZzyYREd2WRUqZsuJV27017CGkJSHqj4OjfG3lvhkrVtM5Tu+jw
8f+KlgAHHN674mRXqUDU4a8Twc7aC5Y36v5mscXAIm2wQKh5EKdPAxedUOqHmMT9
t3WJG8ErmitEuZ8Hb4FzIeL1U3ztnULg+K7vYLCuQS1/C4p3xXU6jtOgPngIuGmj
BGMMRo82DAEc+pxHJI7w
=RN4K
-----END PGP SIGNATURE-----
