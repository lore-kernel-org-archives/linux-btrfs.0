Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22454 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaIJX03 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Sep 2014 19:26:29 -0400
Message-ID: <5410DE1E.8090401@oracle.com>
Date: Thu, 11 Sep 2014 07:26:22 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Johannes Hirte <johannes.hirte@datenkhaos.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: "Btrfs: device_list_add() should not update list when mounted"
 breaks subvol mount
References: <20140911002241.201bc6c2@datenkhaos.de>
In-Reply-To: <20140911002241.201bc6c2@datenkhaos.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  that's shocking. Let me take a look.

Thanks for reporting.
Anand


On 09/11/14 06:22 AM, Johannes Hirte wrote:
> commit b96de000bc8bc9688b3a2abea4332bd57648a49f breaks subvolume mount
> on one of my systems. I've bisected a mount problem to this commit.
> Situation is:
>
> - one hdd with btrfs
> - default subvolume (rootfs) is different from subovlid=0
> - at boot, several subvols are mounted at /home/$DIR
>
> after commit b96de000bc8bc9688b3a2abea4332bd57648a49f this is not
> possible anymore. Trying to mount results in (example):
>
> mount: /dev/sda1 is already mounted or /home/video busy
>
> The output of btrfs show is curious too:
>
> btrfs fi show
> Label: none  uuid: 43438ef5-adac-46a9-823e-14951ee6866a
>          Total devices 1 FS bytes used 150.05GiB
>          *** Some devices missing
>
> Btrfs v3.16
>
> As this is a laptop with only one drive bay, this was never a multi
> device setup. I've two more systems with kernel version >3.17-rc3
> running and no problem like this.
>
> regards,
>    Johannes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
