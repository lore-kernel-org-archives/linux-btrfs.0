Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51512 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbaIPVxn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 17:53:43 -0400
Message-ID: <5418B15C.1070907@oracle.com>
Date: Wed, 17 Sep 2014 05:53:32 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: lists@xunil.at
CC: linux-btrfs@vger.kernel.org
Subject: Re: Unable to mount multiple subvolumes of a single disk
References: <5417022A.5000101@codethink.co.uk> <54170BCA.7070900@fb.com> <54170F35.4040103@oracle.com> <54171E51.2020709@codethink.co.uk> <54172018.1050300@oracle.com> <5417250B.9030105@oracle.com> <5418A6B9.6090003@xunil.at>
In-Reply-To: <5418A6B9.6090003@xunil.at>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Stefan,

  Can you pls send me the output for

    cat /etc/fstab  | egrep btrfs
    cat /proc/self/mounts | egrep btrfs
    mount | egrep btrfs

Thanks, Anand



On 17/09/2014 05:08, Stefan G. Weichinger wrote:
> Am 15.09.2014 um 19:42 schrieb Anand Jain:
>
>> Sam,
>>
>>    In the above context, Can you pls share the btrfs fi show output ?
>
>
> unsure if it helps:
>
> I applied the patch as well, running gentoo on latest git-sources here.
>
> My "btrfs fi show" misses my SSD now:
>
> # btrfs fi show
> Label: 'btrfs_evo'  uuid: ea95dbd1-ef4e-48a4-9732-54e6c80b31df
> 	Total devices 1 FS bytes used 80.91GiB
> 	*** Some devices missing
>
> .. although all the btrfs-subvols on /dev/sda2 are mounted correctly and
> everything works fine so far.
>
> Stefan
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
