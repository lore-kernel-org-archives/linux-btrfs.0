From: Josef Bacik <josef@redhat.com>
Subject: =?ISO-8859-1?Q?Re=3A_btrfs=3A_failed_to_load_free_sp?=
 =?ISO-8859-1?Q?ace_cache_for_block_group_on__rsync=B4ing_?=
 =?ISO-8859-1?Q?to_space=5Fcache_BTRFS_with_subvolume?=
Date: Fri, 24 Jun 2011 09:04:41 -0400
Message-ID: <4E048B69.7050509@redhat.com>
References: <201106231937.12848.Martin@lichtvoll.de> <20110623200526.GB21007@dhcp231-156.rdu.redhat.com> (sfid-20110623_220639_720071_D83B5044) <201106241446.30504.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201106241446.30504.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/24/2011 08:46 AM, Martin Steigerwald wrote:
> Am Donnerstag, 23. Juni 2011 schrieb Josef Bacik:
>> On Thu, Jun 23, 2011 at 07:37:12PM +0200, Martin Steigerwald wrote:
>>> Hi!
>>>
>>> Short summary: I suspect that rsync=B4ing files to a newly created
>>> BTRFS partition with a subvolume *and* enabled space_cache triggers
>>> the error mentioned in the subject line of this mail. I reported
>>> this also as:
>>>
>>> Bug 38112 -  btrfs: failed to load free space cache for block group
>>> on rsync=B4ing to space_cache BTRFS with subvolume
>>>
>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D38112
>>>
>>> I will add a reference to my post here to the bug report, so feel
>>> free to use whatever suits you best to follow up.
>>>
>>>
>>> This happened on a ThinkPad T520 with 3.0.0-rc3-amd64 Debian/GNU
>>> Linux kernel. The issue happened on a 2.5 inch external eSATA/USB
>>> harddisk which I changed to BTRFS. On the repoot after the rsync
>>> process was stalled the unrelated non space cache using root
>>> filesystem did not mount anymore with 3.0.0-rc3-amd64 and
>>> 2.6.39-2-amd64 kernel. But thankfully it did mount with a 2.6.38
>>> grml 2011 amd64 kernel and now work again.
>>>
>>>
>>> Thus I did
>>>
>>> merkaba:~>  mkfs.btrfs -L daten /dev/sdc2
>>>
>>> WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
>>> WARNING! - see http://btrfs.wiki.kernel.org before using
>>>
>>> fs created label daten on /dev/sdc2
>>>
>>>          nodesize 4096 leafsize 4096 sectorsize 4096 size 447.13GB
>>>
>>> Btrfs Btrfs v0.19
>>>
>>> merkaba:~>  mount -o space_cache,compress=3Dlzo /dev/sdc2
>>> /mnt/amazon-daten merkaba:~>  dmesg | tail -3
>>> [137440.930038] device label daten devid 1 transid 7 /dev/sdc2
>>> [137440.930507] btrfs: enabling disk space caching
>>> [137440.930518] btrfs: use lzo compression
>>>
>>>
>>> Then I unmounted, added a fstab entry without space_cache option
>>> since I read that once BTRFS created a space_cache it would use it
>>> anyway it is mounted with clear_cache to clear the cache again.
>>>
>>> I created a sub volume for movies, cause I wanted to be able to not
>>> snapshot the movie files:
>>>
>>> merkaba:~>  btrfs subvolume create /mnt/amazon-daten/Filme
>>> Create subvolume '/mnt/amazon-daten/Filme'
>>>
>>> I then did my rsync from the backup which BTW was a BTRFS with
>>> space_cache as well - created today:
>>>
>>> merkaba:~>  rsync -a -H --acls --xattrs --sparse
>>> /mnt/steigerwald-daten/ /mnt/amazon-daten
>>
>>> A short while after starting the rsync I got:
>> I've just posted a patch for this, sorry about that I've fixed this
>> before but there has been recent work in this area to make it more
>> generic and we lost that particular fix.  Thanks,
>
> Is it:
>
> [PATCH] Btrfs: make sure to update total_bitmaps when freeing cache V=
2
>
> ?
>
> Do you need testing? Is this scheduled for 3.0.0-rc5 or something lik=
e
> this? Then I could wait for the Debian kernel 3.0.0-rc5 to become
> available. I can do without space_cache for the time being.
>

Nope I don't need testing, you don't have to try and reproduce, I know=20
exactly what this is as I've fixed it before :).  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
