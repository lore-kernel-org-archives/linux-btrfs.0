Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20866 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751226AbdJXBsc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Oct 2017 21:48:32 -0400
Subject: Re: [PATCH 2/2] btrfs-progs: fi: enable fi usage for filesystem top
 of seed device
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <01e66c4f-9f8d-0bf2-1f7a-bc5784a907f3@jp.fujitsu.com>
 <b9bb00ed-ff7c-df17-2228-60a3a36507f2@jp.fujitsu.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <b49930eb-e971-da94-c554-1b2f1107aae0@oracle.com>
Date: Tue, 24 Oct 2017 09:48:25 +0800
MIME-Version: 1.0
In-Reply-To: <b9bb00ed-ff7c-df17-2228-60a3a36507f2@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/23/2017 12:45 PM, Misono, Tomohiro wrote:
> Currently "fi usage" (and "dev usage") cannot run for the filesystem using
> seed device.
> 
> This is because FS_INFO ioctl returns the number of devices excluding
> seeds, but load_device_info() tries to access valid device from devid 0
> to max_id, and results in accessing seeds too (thus causing mismatching
> of number of devices).

  A long time back I tried to fix this by fixing the FS_INFO num_devs
  itself, but the concern was backward compatibility of the ioctl.
  However there is no such a concern here. I am ok with this approach.

> Since only the size of non-seed devices is matter, fix this by just
> skipping seed device by checking device's fsid and comparing it to the fsid
> obtained by FS_INFO ioctl.
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand


> ---
>   cmds-fi-usage.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
> 
> diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
> index a72fb4e..50c7e51 100644
> --- a/cmds-fi-usage.c
> +++ b/cmds-fi-usage.c
> @@ -545,6 +545,7 @@ static int load_device_info(int fd, struct device_info **device_info_ptr,
>   	struct btrfs_ioctl_fs_info_args fi_args;
>   	struct btrfs_ioctl_dev_info_args dev_info;
>   	struct device_info *info;
> +	__u8 fsid[BTRFS_UUID_SIZE];
>   
>   	*device_info_count = 0;
>   	*device_info_ptr = NULL;
> @@ -568,6 +569,7 @@ static int load_device_info(int fd, struct device_info **device_info_ptr,
>   		if (ndevs >= fi_args.num_devices) {
>   			error("unexpected number of devices: %d >= %llu", ndevs,
>   				(unsigned long long)fi_args.num_devices);
> +			error("if seed device is used, try run as root.");
>   			goto out;
>   		}
>   		memset(&dev_info, 0, sizeof(dev_info));
> @@ -580,6 +582,19 @@ static int load_device_info(int fd, struct device_info **device_info_ptr,
>   			goto out;
>   		}
>   
> +		/*
> +		 * Skip seed device by cheking device's fsid (require root).
> +		 * Ignore EACCES since if seed is not used this function works
> +		 * correctly without root privilege.
> +		 */
> +		ret = dev_to_fsid((const char *)dev_info.path, fsid);
> +		if (ret != -EACCES) {
> +			if (ret)
> +				goto out;
> +			if (memcmp(fi_args.fsid, fsid, BTRFS_FSID_SIZE) != 0)
> +				continue;
> +		}
> +
>   		info[ndevs].devid = dev_info.devid;
>   		if (!dev_info.path[0]) {
>   			strcpy(info[ndevs].path, "missing");
> 
