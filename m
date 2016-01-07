Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:37089 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbcAGWFn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jan 2016 17:05:43 -0500
Received: by mail-ig0-f176.google.com with SMTP id h5so23966135igh.0
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jan 2016 14:05:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAL3q7H5VsDHfwwnoHc9_N9cg1KrtFro6gW59-XRoPj_orUyKVw@mail.gmail.com>
References: <568EB86F.7070800@gmail.com>
	<CAL3q7H5VsDHfwwnoHc9_N9cg1KrtFro6gW59-XRoPj_orUyKVw@mail.gmail.com>
Date: Thu, 7 Jan 2016 15:05:42 -0700
Message-ID: <CAJCQCtTCx4MBQyxNTyq1EpbxHTvuQrjJPehNR4jqw=9ZZu98Tg@mail.gmail.com>
Subject: Re: btrfs trim erases bootloader area
From: Chris Murphy <lists@colorremedies.com>
To: fdmanana@gmail.com
Cc: Andrei Borzenkov <arvidjaar@gmail.com>,
        The development of GNU GRUB <grub-devel@gnu.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 7, 2016 at 12:16 PM, Filipe Manana <fdmanana@gmail.com> wrote:
> On Thu, Jan 7, 2016 at 7:11 PM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
>> As discussed on opensuse-factory list, running fstrim on btrfs erases
>> bootloader area, rendering system unbootable. See
>>
>> https://lists.opensuse.org/opensuse-factory/2016-01/msg00067.html
>> https://lists.opensuse.org/opensuse-factory/2016-01/msg00090.html
>>
>> and follow-ups that demonstrate that beginning of device gets zeroed out.
>>
>> Not sure what we can do, but from GRUB side I can only see disabling
>> embedding support on btrfs entirely.
>
> Try this (sent to the btrfs mailing list yesterday):
>
> http://git.kernel.org/cgit/linux/kernel/git/fdmanana/linux.git/commit/?h=integration-4.5&id=7b6cb6618b45bb383f9336ec89df5f1f31f9935b
>
> thanks

The description is a bit confusing by referring to MBR, which mainly
exists only at LBA 0. In the case of extended partitions, the EBR
(using the same MBR format) is still outside the LBA range for Btrfs
to apply fitrim ioctl. The VBR however, would be inside that range,
and it's that 64KiB bootloader pad Btrfs reserves that's being
inadvertently obliterated. Correct?



Chris Murphy
