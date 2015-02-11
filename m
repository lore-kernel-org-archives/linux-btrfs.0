Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32202 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752959AbbBKUPL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Feb 2015 15:15:11 -0500
Message-ID: <54DBB848.9030500@fb.com>
Date: Wed, 11 Feb 2015 15:15:04 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Zhaolei <zhaolei@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3] btrfs: Fix out-of-space bug
References: <1423648881-4845-1-git-send-email-zhaolei@cn.fujitsu.com>
In-Reply-To: <1423648881-4845-1-git-send-email-zhaolei@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/11/2015 05:01 AM, Zhaolei wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
>
> Btrfs will report NO_SPACE when we create and remove files for several times,
> and we can't write to filesystem until mount it again.
>
> Steps to reproduce:
>   1: Create a single-dev btrfs fs with default option
>   2: Write a file into it to take up most fs space
>   3: Delete above file
>   4: Wait about 100s to let chunk removed
>   5: goto 2
>
> Script is like following:
>   #!/bin/bash
>
>   # Recommend 1.2G space, too large disk will make test slow
>   DEV="/dev/sda16"
>   MNT="/mnt/tmp"
>
>   dev_size="$(lsblk -bn -o SIZE "$DEV")" || exit 2
>   file_size_m=$((dev_size * 75 / 100 / 1024 / 1024))
>
>   echo "Loop write ${file_size_m}M file on $((dev_size / 1024 / 1024))M dev"
>
>   for ((i = 0; i < 10; i++)); do umount "$MNT" 2>/dev/null; done
>   echo "mkfs $DEV"
>   mkfs.btrfs -f "$DEV" >/dev/null || exit 2
>   echo "mount $DEV $MNT"
>   mount "$DEV" "$MNT" || exit 2
>
>   for ((loop_i = 0; loop_i < 20; loop_i++)); do
>       echo
>       echo "loop $loop_i"
>
>       echo "dd file..."
>       cmd=(dd if=/dev/zero of="$MNT"/file0 bs=1M count="$file_size_m")
>       "${cmd[@]}" 2>/dev/null || {
>           # NO_SPACE error triggered
>           echo "dd failed: ${cmd[*]}"
>           exit 1
>       }
>
>       echo "rm file..."
>       rm -f "$MNT"/file0 || exit 2
>
>       for ((i = 0; i < 10; i++)); do
>           df "$MNT" | tail -1
>           sleep 10
>       done
>   done
>

Excellent find btw, please make sure to turn this into an xfstest.  An 
atomic is a bit heavy handed for this, just use an int and set it to 1, 
we don't need to worry about races since handles will have exited out in 
time.  Thanks,

Josef

