Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:32942 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbcHHLqh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Aug 2016 07:46:37 -0400
Received: by mail-wm0-f43.google.com with SMTP id p129so19589151wmp.0
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Aug 2016 04:46:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK7rSWKrquTN3TbJgcri21VAfuR_wE4nC-TRDn_eGeF+8VJdRQ@mail.gmail.com>
References: <CAK7rSWKrquTN3TbJgcri21VAfuR_wE4nC-TRDn_eGeF+8VJdRQ@mail.gmail.com>
From: Justin Kilpatrick <jkilpatr@redhat.com>
Date: Mon, 8 Aug 2016 07:46:34 -0400
Message-ID: <CANhjow8an2qzrKy7fuKSr1vdgPOHfgatqhOx0vmPiChMWK4P=g@mail.gmail.com>
Subject: Re: Save way to migrate from raid 5/6?
To: Karl Herler <karl.herler@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Do not run device delete, the issue is with parity and disk-failure
recovery, manually
incurring disk failure is a very bad idea.

I would suggest running a full backup of all the files before touching
anything and then
an in place conversion should be fine as its just reading from
undegraded disks and
writing in a few format. I did the same thing converting from 5 to 1
several months ago.
I did end up with a couple of files I had to pull from backups as they
where marked as
corrupted and unrecoverable.

On Sat, Aug 6, 2016 at 2:58 AM, Karl Herler <karl.herler@gmail.com> wrote:
> Hello,
>
> What is the safest way to migrate an existing raid 5/6 setup, to say raid 10?
>
> Will simply running `btrfs filesystem balance start -dconvert=10
> -mconvert=10` work or is it sensitive to the parity calculation issue?
>
> Can I `btrfs device delete` some of the drives, format them and copy
> over the data from the raid 5/6, or will delete risk running into the
> issue?
>
>
> Best regards,
> Karl Herler
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
