Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:45893 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbaAOHx4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 02:53:56 -0500
Received: by mail-pa0-f48.google.com with SMTP id lf10so800326pab.35
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 23:53:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFP7zVuB=A2Lty275-VdixjzG6twXKmJo0qB3gZEH=9noQbpRQ@mail.gmail.com>
References: <CAFP7zVtDEfDjKA1GvBq_QMs6gKv9t=K_qNyv6dcxawe5iuj8Kw@mail.gmail.com>
	<D942F4C1-471E-476F-BEC1-3090DDAEB115@colorremedies.com>
	<CAFP7zVuB=A2Lty275-VdixjzG6twXKmJo0qB3gZEH=9noQbpRQ@mail.gmail.com>
Date: Wed, 15 Jan 2014 08:53:55 +0100
Message-ID: <CAFP7zVvk_cXfCrdie9CqGpAa2y6=t4L4bn93v3kNJdudH5nDhw@mail.gmail.com>
Subject: Fwd: btrfsck failes
From: Holger Brandsmeier <brandsmeier@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

+linux-btrfs@vger.kernel.org

I am not sure if

# btrfs-image -c9 -t4 /dev/sda5 /some/path
parent transid verify failed on 602529792 wanted 23460 found 23463
parent transid verify failed on 602529792 wanted 23460 found 23463
parent transid verify failed on 602529792 wanted 23460 found 23463
parent transid verify failed on 602529792 wanted 23460 found 23463
Ignoring transid failure
Error going to next leaf -5
create failed (Success)

means this failed or succeeded, it wrote a file which is 1.3mb large.

# mount -orecovery /dev/sda5 data/
or
# mount -orecovery,ro /dev/sda5 data/
didn't succeed with the output after timestamp 8670.468771 in dmesg.out

# btrfs-zero-log /dev/sda5
parent transid verify failed on 602529792 wanted 23460 found 23463
parent transid verify failed on 602529792 wanted 23460 found 23463
parent transid verify failed on 602529792 wanted 23460 found 23463
parent transid verify failed on 602529792 wanted 23460 found 23463
Ignoring transid failure
btrfs-zero-log: disk-io.c:155: readahead_tree_block: Assertion `!(ret)' failed.
Aborted (core dumped)

with not much dmesg output at timestamp 8975.683197

I attached the outputs of

# btrfsck /dev/sda5 > btrfsck_s0.out 2>&1
# btrfsck /dev/sda5 --super=1  > btrfsck_s1.out 2>&1

The two files differ, but to me they both look equally bad. Should I
try `btrfs-select-super` or `btrfsck --repair --init-extent-tree` /
`btrfsck --repair --init-csum-tree`.

Thanks,
Holger

On Wed, Jan 15, 2014 at 5:06 AM, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Jan 14, 2014, at 4:24 PM, Holger Brandsmeier <brandsmeier@gmail.com> wrote:
>
>> Dear Chris,
>>
>> as requested:
>>
>> # btrfs fi show
>> Label: none  uuid: 267f069c-11da-4d2a-88fa-00cab4e28149
>>        Total devices 1 FS bytes used 12.68GiB
>>        devid    1 size 29.82GiB used 24.27GiB path /dev/sdb1
>> Label: none  uuid: f6907d81-f46f-4911-8600-858e8b6bd1a0
>>        Total devices 1 FS bytes used 141.72GiB
>>        devid    1 size 278.00GiB used 212.04GiB path /dev/sda5
>> Btrfs v3.12
>>
>> The problem makes `/dev/sda5`. I attached the output of `smartctl -x /dev/sda5`.
>
> There are some reallocated sectors. dmesg reports
> [ 2023.770828] btrfs read error corrected: ino 1 off 605564928 (dev /dev/sda5 sector 1199128)
>
> That might be metadata on a bad sector that was fixed from duplicate metadata. This is single device Btrfs with default DUP metadata?
>
>>
>> # mount -o clear_cache /dev/sda5 data/
>> mount: wrong fs type, bad option, bad superblock on /dev/sda5,
>>       missing codepage or helper program, or other error
>>
>
> Hmm. So maybe the 1st superblock is no good. But it might be worth trying btrfs-zero-log first. It's possible the repair made this worse.
>
> https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg27613.html
>
>
>
> Chris Murphy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
