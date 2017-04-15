Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:33656 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751616AbdDOTMW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Apr 2017 15:12:22 -0400
Subject: Re: [PATCH] btrfs: drop the nossd flag when remounting with -o ssd
To: dsterba@suse.cz, Adam Borowski <kilobyte@angband.pl>,
        David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
References: <0939c5df-3abd-ec68-16ef-538ad04251aa@mendix.com>
 <20170331151904.4091-1-kilobyte@angband.pl>
 <b289c1a8-d0d4-c147-ca65-7c954f05a7e5@mendix.com>
 <20170331171016.GN4781@twin.jikos.cz>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <81bd0c72-32bb-560c-1129-33d4f13255c5@mendix.com>
Date: Sat, 15 Apr 2017 21:12:20 +0200
MIME-Version: 1.0
In-Reply-To: <20170331171016.GN4781@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/31/2017 07:10 PM, David Sterba wrote:
> On Fri, Mar 31, 2017 at 06:00:08PM +0200, Hans van Kranenburg wrote:
>> On 03/31/2017 05:19 PM, Adam Borowski wrote:
>>> The opposite case was already handled right in the very next switch entry.
>>>
>>> Reported-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
>>> Signed-off-by: Adam Borowski <kilobyte@angband.pl>
>>> ---
>>> Not sure if setting NOSSD should also disable SSD_SPREAD, there's currently
>>> no way to disable that option once set.
> 
> Missing inverse of ssd_spread is probably unintentional, as we once
> added all complementary no* options, this one was forgotten.
> 
> And yes, nossd should turn off ssd and ssd_spread, as ssd_spread without
> ssd does not nothing anyway.

ssd_spread is tested exactly one time, in free-space-cache.c in
btrfs_find_space_cluster

As far as I can quickly find out, that code is reached regardless of
which other options are set.

So, it *does* something anyway if ssd is not set. And I think it
prevents all writes from being split into multiple extents.

So, nossd,ssd_spread (no ssd) is right now something that you can end up
with (when the patch here is not applied) when playing with -o remount.

> 
>>>
>>>  fs/btrfs/super.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>>> index 06bd9b332e18..7342399951ad 100644
>>> --- a/fs/btrfs/super.c
>>> +++ b/fs/btrfs/super.c
>>> @@ -549,11 +549,13 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>>>  		case Opt_ssd:
>>>  			btrfs_set_and_info(info, SSD,
>>>  					   "use ssd allocation scheme");
>>> +			btrfs_clear_opt(info->mount_opt, NOSSD);
>>>  			break;
>>>  		case Opt_ssd_spread:
>>>  			btrfs_set_and_info(info, SSD_SPREAD,
>>>  					   "use spread ssd allocation scheme");
>>>  			btrfs_set_opt(info->mount_opt, SSD);
>>> +			btrfs_clear_opt(info->mount_opt, NOSSD);
>>>  			break;
>>>  		case Opt_nossd:
>>>  			btrfs_set_and_info(info, NOSSD,
>>
>> How did you test this?
>>
>> This was also my first thought, but here's a weird thing:
>>
>> -# mount -o nossd /dev/sdx /mnt/btrfs/
>>
>> BTRFS info (device sdx): not using ssd allocation scheme
>>
>> -# mount -o remount,ssd /mnt/btrfs/
>>
>> BTRFS info (device sdx): use ssd allocation scheme
>>
>> -# mount -o remount,nossd /mnt/btrfs/
>>
>> BTRFS info (device sdx): use ssd allocation scheme
>>
>> That means that the case Opt_nossd: is never reached when doing this?
>>
>> And... what should be the result of doing:
>> -# mount -o remount,nossd,ssd /mnt/btrfs/
>>
>> I guess it should be that the last one in the sequence wins?
> 
> The last one wins.
> 
>> The fact that nossd,ssd,ssd_spread are different options complicates the
>> whole thing, compared to e.g. autodefrag, noautodefrag.
> 
> I think the the ssd flags reflect the autodetection of ssd, unlike
> autodefrag and others.
> 
> The ssd options says "enable the ssd mode", but it could be also
> auto-detected if the non-rotational device is detected.
> 
> nossd says, "do not do the autodetection, even if it's a non-rot
> device, also disable all ssd modes".
> 
> The manual page is not entirely clear about that, I'll update it.
> 
> So Adam's patch needs to be updated so NOSSD also disables SSD_SPREAD.
> Adding the 'nossd_spread' would be good to have, even if it might be
> just a marginal usecase.
> 


-- 
Hans van Kranenburg
