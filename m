Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36436 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbaEWSJ0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 May 2014 14:09:26 -0400
Message-ID: <537F8ED3.1010505@suse.com>
Date: Fri, 23 May 2014 14:09:23 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: dsterba@suse.cz, Chris Mason <clm@fb.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: don't remove raid type sysfs entries until unmount
References: <537D40EB.60906@fb.com> <537D5136.4050007@suse.com> <537DEB3F.5020303@fb.com> <537E1242.1010109@suse.com> <537E313E.8050906@fb.com> <20140523123849.GE5346@suse.cz> <537F4566.2000907@suse.com> <20140523143246.GF5346@suse.cz> <537F5C85.9000000@suse.com>
In-Reply-To: <537F5C85.9000000@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 5/23/14, 10:34 AM, Jeff Mahoney wrote:
> On 5/23/14, 10:32 AM, David Sterba wrote:
>> On Fri, May 23, 2014 at 08:56:06AM -0400, Jeff Mahoney wrote:
>>> Sigh. Yep. kobject_cleanup caches ->name before the release 
>>> function and ignores the cleared value. It seems the "free
>>> name if we alloced it" comment in there was leftover from the
>>> middle of a patch series Kay applied in late 2007. Commit
>>> 0f4dafc05 adds the comment while adding a flag to indicate
>>> that kobject_set_name_vargs set the name. The commit af5ca3f4e
>>> says kobject names must be dynamic but didn't update the
>>> comment.
>>> 
>>> Ok, so we can't save the strdup.
> 
>> The tests have been running fine for more than 40 minutes, 
>> previously it took a few minutes to trigger the bug.
> 
>> my quick fix:
> 
>> --- a/fs/btrfs/extent-tree.c +++ b/fs/btrfs/extent-tree.c @@ 
>> -8354,7 +8354,8 @@ static void __link_block_group(struct 
>> btrfs_space_info *space_info, int ret;
> 
>> kobject_get(&space_info->kobj); /* put in release */ - kobj->name
>> = get_raid_name(index); +               kobj->name = 
>> kstrdup(get_raid_name(index), GFP_ATOMIC); + BUG_ON(!kobj->name);
>> ret = kobject_init_and_add(kobj, &btrfs_raid_ktype,
>> &space_info->kobj, NULL); if (ret) { diff --git 
>> a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c index 
>> d742d7973d3e..ac26f91968a7 100644 --- a/fs/btrfs/sysfs.c +++ 
>> b/fs/btrfs/sysfs.c @@ -288,7 +288,7 @@ static struct attribute 
>> *raid_attributes[] = {
> 
>> static void release_raid_kobj(struct kobject *kobj) { - 
>> kobj->name = NULL; +       /* kobj->name = NULL; */ 
>> kobject_put(kobj->parent); }
> 
> 
> I'm testing as well. I'm seeing: kobject (ffff88033f847e78): tried
> to init an initialized object, something is seriously wrong.
> 
> .. as well. A memset would clear this up, but perhaps that's not
> the right solution after all.

For background, the reason the kobjects are statically allocated is
because they cover all of the block group caches for that raid type
and it seemed silly to have a special structure that only contains a
kobject and an int. So it uses its index in that array to determine
which raid type it covers. Putting the kobject, list head, and type in
a single structure ends up introducing more complexity for little gain
since we end up with that lockdep alloc during reclaim problem again
(or end up allocating every time and freeing if it's not needed.) In
retrospect, we waste less memory allocating a special structure
on-demand anyway and it eliminates the questions.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)

iQIcBAEBAgAGBQJTf47SAAoJEB57S2MheeWyJrAP/RLfyy90y+6pARBi1bseMW0d
maQcNk6DkWYt4DYenMe+lvJJf+RPBotsFaDzq1Eblq8DDi1r7hb2wZvpS0AaCbCg
hRLAWXpRi4cXLfjt5fQp+chymE6QUc3PYCFa9DvqcCjKBv3Wm2ArVAUbL4V1mucJ
klLwI1O2Y8i1EbBifPIHzClK6xeiAYhe7yOs+CoH9Q2oZA+vuHtAuNyUTOMXS0sY
88/2o/cnqX762fxT6J8DPPMqKiu3YwoiNGOW2gEpHyujKmY66BnfHsrx07lR3atj
eOD5VmUsHKYWvEWqbmGoCTHmT3wJbaWw1tGlcOIS2LVdbq538HUzsEk3ENhB9kfU
ANz7b4X7iGSzAeLdkLzMKGt5ApAqqEOGO5BBtcQhmPaMtLXNXgEraSjEkd4dO1Xs
lyte4PQ+FICI/hKwOVcZPt/64mC1ABfmdnAwBx4zSECsWv7HuXTtVAX5MhZX1vGQ
l9sdkwq1nfGhcY4Zf/KIF8Q2ljRH/k1I9XCdFJpyUSnk5NBvV7qLBw+9C8rQzirs
J5DTYWDAq1h1W0vn3JRzPi9AmO7DGPBeJIyGlR8JAxxjw29PX9j0mzB6T2Hc3zZe
jzIzjBnBdJRc2fiFIJXkKc1QpdJ6J6DKQaMGv6Yz58TYu3/juAKRD2C9DuKvPWWb
FvK4VPhhsCQhZzJvQsko
=MwZr
-----END PGP SIGNATURE-----
