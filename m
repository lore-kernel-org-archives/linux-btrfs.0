Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22964 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab3KRCIb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Nov 2013 21:08:31 -0500
Message-ID: <528978AF.3020806@oracle.com>
Date: Mon, 18 Nov 2013 10:17:19 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Gene Czarcinski <gene@czarc.net>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs fi show
References: <528787FB.4040100@czarc.net>
In-Reply-To: <528787FB.4040100@czarc.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




There is a fix for this (which David has integrated into the branch
recently). This also needs the kernel side patch which is listed below.

[PATCH v4 1/3] btrfs-progs: mechanism to fetch fsinfo from btrfs-control
[PATCH v4 2/3] btrfs-progs: fs show should handle if subvol(s) mounted

[PATCH v2] btrfs: add framework to read fs info from btrfs-control


Thanks, Anand



On 11/16/2013 10:58 PM, Gene Czarcinski wrote:
> I am on Fedora 20-Beta and we just updated to btrfs-progs
> 0.20.rc1-20131114git9f0c53f
>
> Previously, when you did a btrfs fi show, you got a list with one output
> for each btrfs storage volume whether it was a single device or
> multi-device volume.
>
> Now, I get multiple outputs for each storage volume.  For example, I
> have a system with two SSDs as one btrfs storage volume and two USB
> round-and-brown disks as a second btrfs storage volume.  Each has three
> subvols defined and mounted.
>
> Previously, I got two outputs; one for each volume.
>
> Now I get three outputs for the SSD storage volume and SIX outputs for
> the out volume.
>
> Is this a bug or a feature?  If it is a feature, what is it telling me?
>
> Gene
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
