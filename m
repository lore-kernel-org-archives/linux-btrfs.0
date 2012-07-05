Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52433 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab2GEROd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jul 2012 13:14:33 -0400
Received: by yhmm54 with SMTP id m54so8430346yhm.19
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jul 2012 10:14:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FF5C9F2.903@zabbo.net>
References: <1341409108-13567-1-git-send-email-ablock84@googlemail.com>
	<1341409108-13567-5-git-send-email-ablock84@googlemail.com>
	<4FF5C9F2.903@zabbo.net>
Date: Thu, 5 Jul 2012 19:14:32 +0200
Message-ID: <CAB9VWqAoKXCU4T93_aMSC_2rgcQT7MVWVVaVPMhvHrG7sDVStQ@mail.gmail.com>
Subject: Re: [RFC PATCH 4/7] Btrfs: introduce subvol uuids and times
From: Alexander Block <ablock84@googlemail.com>
To: Zach Brown <zab@zabbo.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 5, 2012 at 7:08 PM, Zach Brown <zab@zabbo.net> wrote:
>> +static long btrfs_ioctl_set_received_subvol(struct file *file,
>> +                                           void __user *arg)
>> +{
>> +       struct btrfs_ioctl_received_subvol_args *sa = NULL;
>
>
>> +       ret = copy_to_user(arg, sa, sizeof(*sa));
>
>
>> +struct btrfs_ioctl_received_subvol_args {
>> +       char    uuid[BTRFS_UUID_SIZE];  /* in */
>> +       __u64   stransid;               /* in */
>> +       __u64   rtransid;               /* out */
>> +       struct timespec stime;          /* in */
>> +       struct timespec rtime;          /* out */
>> +       __u64   reserved[16];
>> +};
>
>
> Careful, timespec will be different sizes in 32bit userspace and a 64bit
> kernel.  I'd use btrfs_timespec to get a fixed size timespec and avoid
> all the compat_timespec noise.  (I'd then also worry about padding and
> might pack the struct.. I always lose track of the best practice across
> all archs.)
Hmm we currently don't have ctree.h in ioctl.h. Can I include it there
or are there problems with that? As an alternative I could define my
own struct for that.
>
> - z
