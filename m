Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f195.google.com ([209.85.213.195]:35866 "EHLO
	mail-ig0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbcDZPwK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 11:52:10 -0400
Received: by mail-ig0-f195.google.com with SMTP id c3so2536516igl.3
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 08:52:09 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <f7692e58a8e6a7bd28160adfc664e9e8ccfa6fcc.1461681045.git.dsterba@suse.com>
References: <cover.1461681045.git.dsterba@suse.com>
	<f7692e58a8e6a7bd28160adfc664e9e8ccfa6fcc.1461681045.git.dsterba@suse.com>
Date: Tue, 26 Apr 2016 16:52:09 +0100
Message-ID: <CAL3q7H7myUQ6FbkwTcr1Qb0oqyCt2iV=My2k_rf2P606oTWoNQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] btrfs: sysfs: protect reading label by lock
From: Filipe Manana <fdmanana@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 26, 2016 at 3:32 PM, David Sterba <dsterba@suse.com> wrote:
> If the label setting ioctl races with sysfs label handler, we could get
> mixed result in the output, part old part new. We should either get the
> old or new label. The chances to hit this race are low.
>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/sysfs.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index 3d14618ce54b..7b0da1dcb6df 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -367,7 +367,12 @@ static ssize_t btrfs_label_show(struct kobject *kobj,
>  {
>         struct btrfs_fs_info *fs_info = to_fs_info(kobj);
>         char *label = fs_info->super_copy->label;
> -       return snprintf(buf, PAGE_SIZE, label[0] ? "%s\n" : "%s", label);
> +
> +       spin_lock(&fs_info->super_lock);
> +       snprintf(buf, PAGE_SIZE, label[0] ? "%s\n" : "%s", label);
> +       spin_unlock(&fs_info->super_lock);
> +
> +       return buf;

We should return a ssize_t value, not a char *. I.e. return what
snprintf returns. This should make gcc emit a warning.

>  }
>
>  static ssize_t btrfs_label_store(struct kobject *kobj,
> --
> 2.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
