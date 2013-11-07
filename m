Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:51351 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab3KGLdt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Nov 2013 06:33:49 -0500
Received: by mail-oa0-f51.google.com with SMTP id o6so734993oag.10
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Nov 2013 03:33:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <527B541D.5000101@giantdisaster.de>
References: <CAMajw1N4bqFyHA4V8SkEzQFZF8adN0xQDShRq7bC2Of+nxsJGA@mail.gmail.com>
	<CAMajw1O2xsqKK2VRcz1JjwaH0d9G_602snooNUpBhdDegt_yGA@mail.gmail.com>
	<527B541D.5000101@giantdisaster.de>
Date: Thu, 7 Nov 2013 11:33:48 +0000
Message-ID: <CAMajw1MVmO5dbkDB7Wj1J-O0mTE-q6xyo1Do83gQk8RLX2dnpQ@mail.gmail.com>
Subject: Re: Fwd: unable to delete files after kernel upgrade from 3.8.10 to 3.12
From: Bartosz Kulicki <bartosz.kulicki@gmail.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Stefan,

Yes, I realise that.
As I pointed out in bug report I have tried workarounds suggested in
wiki and more. To be precise: partial balancing didn't work (completed
without error but no change), balacing fs failed with ENOSPC,
clobbering a file didn't work (ENOSPC), btrfs-zero-log completed but
no change.

The filesystem was quite full 98% but I could still write to it before
rebooting with new kernel.
I had to nuke the fs since then and restore from backup but I captured
image with btrfs-image before running btrfs-zero-log.


regards,
Bart


On Thu, Nov 7, 2013 at 8:49 AM, Stefan Behrens
<sbehrens@giantdisaster.de> wrote:
> On Wed, 6 Nov 2013 21:53:25 +0000, Bartosz Kulicki wrote:
>> As per subject. Seems UUID tree creation failed after upgrade. I could
>> not mount filesystem under 3.12. Going back to 3.8.10 allowed me to
>> mount fs but I could no longer perform any deletes, writes etc.
>>
>> I've opened a bug report here.
>> https://bugzilla.kernel.org/show_bug.cgi?id=64461
>>
>> I've included link to image captured with btrfs-image.
>>
>> Please CC me if further information is needed as I'm not subscribed to
>> the mailing list.
>>
>
> ENOSPC means you're out of disk space. A copy-on-write filesystem needs
> disk space for delete operations, that's not a bug.
>
> What does 'btrfs fi df /mountpoint' say?
> How much disk space do you have, how much is allocated?
>
> And try the procedure that is described in the wiki:
>
> https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_get_.22No_space_left_on_device.22_errors.2C_but_df_says_I.27ve_got_lots_of_space
>
>
