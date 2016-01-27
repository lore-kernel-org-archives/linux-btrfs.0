Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:33016 "EHLO
	mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbcA0LUt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jan 2016 06:20:49 -0500
Received: by mail-vk0-f41.google.com with SMTP id e64so3033851vkg.0
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jan 2016 03:20:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1453889679-25588-1-git-send-email-dsterba@suse.com>
References: <1453889679-25588-1-git-send-email-dsterba@suse.com>
Date: Wed, 27 Jan 2016 12:20:48 +0100
Message-ID: <CAHji150m=sgHJ4SLB7YYD6DzkrSgcBfheqoDr=uwJm4LDuwtwA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: sysfs: check initialization state before updating features
From: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 27, 2016 at 11:14 AM, David Sterba <dsterba@suse.com> wrote:
> If the mount phase is not finished, we can't update the sysfs files.
>
> Reported-by: Chris Mason <clm@fb.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/sysfs.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index 6986886243bf..1ae146a8093c 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -804,6 +804,9 @@ void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
>         fs_devs = fs_info->fs_devices;
>         fsid_kobj = &fs_devs->fsid_kobj;
>
> +       if (!fsid_kobj.state_initialized)
> +               return;
> +

uhm..

fs/btrfs/sysfs.c: In function 'btrfs_sysfs_feature_update':
fs/btrfs/sysfs.c:807:16: error: request for member 'state_initialized'
in something not a structure or union
  if (!fsid_kobj.state_initialized)
                ^

I think this should be fsid_kobj->state_initialized, no?

-h
