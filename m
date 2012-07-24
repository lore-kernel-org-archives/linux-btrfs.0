Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:44005 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754736Ab2GXFzz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jul 2012 01:55:55 -0400
Message-ID: <500E38E8.60609@gmx.net>
Date: Tue, 24 Jul 2012 07:55:52 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Alexander Block <ablock84@googlemail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 4/7] Btrfs: introduce subvol uuids and times
References: <1341409108-13567-1-git-send-email-ablock84@googlemail.com>	<1341409108-13567-5-git-send-email-ablock84@googlemail.com>	<50042BB8.4060904@gmx.net> <CAB9VWqAqiVKC3rBEYcUzF58UVYtnniOTQQ_gLAEAOUOWofArXw@mail.gmail.com>
In-Reply-To: <CAB9VWqAqiVKC3rBEYcUzF58UVYtnniOTQQ_gLAEAOUOWofArXw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 23.07.2012 21:41, Alexander Block wrote:
> On Mon, Jul 16, 2012 at 4:56 PM, Arne Jansen <sensille@gmx.net> wrote:
>> On 04.07.2012 15:38, Alexander Block wrote:
>>> +
>>> +     ret = btrfs_update_root(trans, root->fs_info->tree_root,
>>> +                             &root->root_key, &root->root_item);
>>> +     if (ret < 0) {
>>> +             goto out;
>>
>> are you leaking a trans handle here?
>>
> btrfs_update_root is aborting the transaction in case of failure. Do I
> still need to call end_transaction?

It's your handle, you should free it.

...

>>>
>>> +struct btrfs_ioctl_received_subvol_args {
>>> +     char    uuid[BTRFS_UUID_SIZE];  /* in */
>>> +     __u64   stransid;               /* in */
>>> +     __u64   rtransid;               /* out */
>>> +     struct timespec stime;          /* in */
>>> +     struct timespec rtime;          /* out */
>>> +     __u64   reserved[16];
>>
>> What is this reserved used for? I don't see a mechanism that could be
>> used to signal that there are useful information here, other than
>> using a different ioctl.
>>
> The reserved is a result of a suggestion made by David. I can remove
> it again if you want...

I don't argue against some reserved space, I only have problems to
see how you can make use of them in the future when there's no way
to signal that they contain valid information. I should be sufficient
to define the reserved values to be 0 at the moment.

>>> +};
>>> +
>>>  #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
>>>                                  struct btrfs_ioctl_vol_args)
>>>  #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
>>> @@ -359,6 +368,10 @@ struct btrfs_ioctl_get_dev_stats {
>>>                                       struct btrfs_ioctl_ino_path_args)
>>>  #define BTRFS_IOC_LOGICAL_INO _IOWR(BTRFS_IOCTL_MAGIC, 36, \
>>>                                       struct btrfs_ioctl_ino_path_args)
>>> +
>>> +#define BTRFS_IOC_SET_RECEIVED_SUBVOL _IOWR(BTRFS_IOCTL_MAGIC, 37, \
>>> +                             struct btrfs_ioctl_received_subvol_args)
>>> +
>>>  #define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
>>>                                     struct btrfs_ioctl_get_dev_stats)
>>>  #define BTRFS_IOC_GET_AND_RESET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 53, \
>>> diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
>>> index 24fb8ce..17d638e 100644
>>> --- a/fs/btrfs/root-tree.c
>>> +++ b/fs/btrfs/root-tree.c
>>> @@ -16,6 +16,7 @@
>>>   * Boston, MA 021110-1307, USA.
>>>   */
>>>
>>> +#include <linux/uuid.h>
>>>  #include "ctree.h"
>>>  #include "transaction.h"
>>>  #include "disk-io.h"
>>> @@ -25,6 +26,9 @@
>>>   * lookup the root with the highest offset for a given objectid.  The key we do
>>>   * find is copied into 'key'.  If we find something return 0, otherwise 1, < 0
>>>   * on error.
>>> + * We also check if the root was once mounted with an older kernel. If we detect
>>> + * this, the new fields coming after 'level' get overwritten with zeros so to
>>> + * invalidate the fields.
>>
>> ... "This is detected by a mismatch of the 2 generation fields" ... or something
>> like that.
>>
> The current version (found in git only) has this new function which is
> called in find_last_root:
> void btrfs_read_root_item(struct btrfs_root *root,
> 			 struct extent_buffer *eb, int slot,
> 			 struct btrfs_root_item *item)
> 
> The comment above this function explains what happens.

ok. Please regard most of my comments as an expression of my thoughts while
reading it. So they mark places where it might be useful to add comments
to make it easier for the next reader :)
