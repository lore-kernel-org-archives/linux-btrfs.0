Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:34604 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751622AbdG1JtH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Jul 2017 05:49:07 -0400
Received: by mail-qk0-f196.google.com with SMTP id q66so20598775qki.1
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Jul 2017 02:49:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170727192446.27158-1-hans.van.kranenburg@mendix.com>
References: <20170727192446.27158-1-hans.van.kranenburg@mendix.com>
From: Henk Slager <eye1tm@gmail.com>
Date: Fri, 28 Jul 2017 11:49:04 +0200
Message-ID: <CAPmG0jbrCvVFjiDtZizSR9awLEFPHgQRkwcqX06Rdu6pJsFMDg@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: eliminate bogus IOC_DEV_INFO call
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 27, 2017 at 9:24 PM, Hans van Kranenburg
<hans.van.kranenburg@mendix.com> wrote:
> Device ID numbers always start at 1, not at 0. The first IOC_DEV_INFO
> call does not make sense, since it will always return ENODEV.

When there is a btrfs-replace ongoing, there is a Device ID 0

> ioctl(3, BTRFS_IOC_DEV_INFO, {devid=0}) = -1 ENODEV (No such device)
>
> Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
> ---
>  cmds-fi-usage.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
> index 101a0c4..52c4c62 100644
> --- a/cmds-fi-usage.c
> +++ b/cmds-fi-usage.c
> @@ -535,7 +535,7 @@ static int load_device_info(int fd, struct device_info **device_info_ptr,
>                 return 1;
>         }
>
> -       for (i = 0, ndevs = 0 ; i <= fi_args.max_id ; i++) {
> +       for (i = 1, ndevs = 0 ; i <= fi_args.max_id ; i++) {
>                 if (ndevs >= fi_args.num_devices) {
>                         error("unexpected number of devices: %d >= %llu", ndevs,
>                                 (unsigned long long)fi_args.num_devices);
> --
> 2.11.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
