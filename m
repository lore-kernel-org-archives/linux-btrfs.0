Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:64723 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab2JMUKy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Oct 2012 16:10:54 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so850106eaa.19
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Oct 2012 13:10:53 -0700 (PDT)
Message-ID: <5079CADA.4050604@gmail.com>
Date: Sat, 13 Oct 2012 22:11:06 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
MIME-Version: 1.0
To: Anand jain <Anand.Jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] Add show sub command to btrfs subvolume
References: <1350019254-22036-1-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1350019254-22036-1-git-send-email-Anand.Jain@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Anad,

On 2012-10-12 07:20, Anand jain wrote:
> From: Anand Jain<anand.jain@oracle.com>
>
> This set of patch will add show sub-command to
> btrfs subvolume, which is to show more information
> about a given subvol or snapshot. At present it shows
> 3 info, I hope this will be further useful if enhanced
> as needed.

Thanks for working on that; do you think that is it feasible to merge 
the works on "btrfs sub list" and "btrfs sub show" ?
To date the output of "btrfs sub list" is quite cryptic: a lot of 
information on only on row, which is difficult to read. However it has 
the capability to traverse the filesystem to list the subvolumes, to 
sort the output, to filter it...
Instead your work has not the capability to traverse/filter/sort but has 
a very nice output.

The ideal is to extend the actual command (btrfs sub list) to have your 
output (as default) and the current one (as option) when used in script...

BR
G.Baroncelli


>
> eg:
> # btrfs su show /btrfs/sssv3
> /btrfs/sssv3
> 	uuid: 		c5d646b5-a749-c646-b082-6d9a3ca870be
> 	Parent uuid: 	34bc8edd-113f-5141-a814-f6dfae069b01
> 	Creation time: 	2012-10-12 11:37:00
>
>
> Thanks
>
> Anand Jain (4):
>    Btrfs-progs: introduce btrfs_get_subvols function
>    Btrfs-progs: need struct root_info to be accesible
>    Btrfs-progs: method to fetch root info for subvol
>    Btrfs-progs: add btrfs subvol show cli
>
>   btrfs-list.c     |  119 ++++++++++++++++++++++++++---------------------------
>   btrfs-list.h     |   49 ++++++++++++++++++++++-
>   cmds-subvolume.c |  113 +++++++++++++++++++++++++++++++++++++++++++++++++++
>   man/btrfs.8.in   |    6 +++
>   4 files changed, 225 insertions(+), 62 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

