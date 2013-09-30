Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:48614 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab3I3WDH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Sep 2013 18:03:07 -0400
Received: by mail-la0-f52.google.com with SMTP id ev20so5019460lab.39
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Sep 2013 15:03:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130930215802.GB10831@lenny.home.zabbo.net>
References: <CAOEw3RbDhA9_VhkuiewMWCXg5z4jqM9hR_=Uvq61a2A-w0vZxA@mail.gmail.com>
	<20130930215802.GB10831@lenny.home.zabbo.net>
Date: Tue, 1 Oct 2013 00:03:05 +0200
Message-ID: <CAOEw3Ratb6S_ddzvFwBG4cuk_20chFKwcXqQ9M4RNOdtSbC4Ng@mail.gmail.com>
Subject: Re: [PATCH] btrfs: init device stats for new devices
From: =?ISO-8859-2?Q?Ond=F8ej_Kunc?= <kunc88@gmail.com>
To: Zach Brown <zab@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Zach,

thank you for your answer and clarification. I cannot just unmount and
mount that filesystem, because it is running busy NFS server now, so I
will just try it on some testbench server. Can mount -o remount be
sufficient (to prevent stopping service, umount, mount and starting
service) ?

Thank you

Ondøej

2013/9/30 Zach Brown <zab@redhat.com>:
>> I discovered one minor bug in BTRFS filesystem.
>
> You sure did.
>
>> ERROR: ioctl(BTRFS_IOC_GET_DEV_STATS) on /dev/sde failed: No such device
>>
>> But this is not true ... all specified devices exist and are members
>> of btrfs filesystem. In dmesg I see this:
>> ...
>> [973077.099118] btrfs: get dev_stats failed, not yet valid
>> ....
>>
>> What makes device statistics valid ? I tried doing full filesystem
>> scrub ... but it did not fix that issue.
>
> The stats are only initialized (considered valid) for devices that are
> known at mount.  You could unmount and mount after adding (or replacing)
> new devices and they'd start returning stats.
>
> The following (bad) patch illustrates the problem, but the code should
> be restructured so stats are reliably read as devices are added.
>
> - z
>
> From: Zach Brown <zab@redhat.com>
> Date: Mon, 30 Sep 2013 17:48:05 -0400
> Subject: [PATCH] btrfs: init device stats for new devices
>
> Device stats are only initialized (read from tree items) on mount.
> Trying to read device stats after adding or replacing new devices will
> return errors.
>
> This cheesy patch demonstrates the problem, but this should really be a
> natural side-effect of adding devices to the fs_devices list.  We have
> evidence that trying to do it by hand doesn't work.
>
> Any preferences for how to restructure this?
> ---
>  fs/btrfs/dev-replace.c | 4 +++-
>  fs/btrfs/volumes.c     | 6 ++++++
>  2 files changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 5d84443..7309096 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -556,7 +556,9 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>
>         mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
>
> -       return 0;
> +       ret = btrfs_init_dev_stats(root->fs_info);
> +
> +       return ret;
>  }
>
>  static void btrfs_dev_replace_update_device_in_mapping_tree(
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 0431147..e4ccc9b 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2126,6 +2126,9 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
>                 ret = btrfs_commit_transaction(trans, root);
>         }
>
> +       if (!ret)
> +               ret = btrfs_init_dev_stats(root->fs_info);
> +
>         return ret;
>
>  error_trans:
> @@ -6060,6 +6063,9 @@ int btrfs_init_dev_stats(struct btrfs_fs_info *fs_info)
>                 int item_size;
>                 struct btrfs_dev_stats_item *ptr;
>
> +               if (device->dev_stats_valid)
> +                       continue;
> +
>                 key.objectid = 0;
>                 key.type = BTRFS_DEV_STATS_KEY;
>                 key.offset = device->devid;
> --
> 1.7.11.7



-- 
Ondøej Kunc
