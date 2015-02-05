Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f47.google.com ([209.85.213.47]:32832 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbbBEU6g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Feb 2015 15:58:36 -0500
Received: by mail-yh0-f47.google.com with SMTP id z6so4446831yhz.6
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Feb 2015 12:58:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <mb0jp0$pnd$1@ger.gmane.org>
References: <mau7vs$pjj$1@ger.gmane.org>
	<CAJCQCtSXJZ4paKiZBNDOp-yKccrLbizmGDj_8y5k5EC-9DFjXg@mail.gmail.com>
	<54D2E62E.7080208@pobox.com>
	<CAJCQCtSLBg7-XoVjTfDq5PbZ-dk1WXeXGT2YEbQYNNc0VoSu-A@mail.gmail.com>
	<mb0jp0$pnd$1@ger.gmane.org>
Date: Thu, 5 Feb 2015 13:58:35 -0700
Message-ID: <CAJCQCtT1pSrFEU7Q0qspNkqzY9naDHxzzyE5y3fyqgZqqkT_vA@mail.gmail.com>
Subject: Re: Btrfs subvolume question
From: Chris Murphy <lists@colorremedies.com>
To: Markus Moeller <huaraz@moeller.plus.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 5, 2015 at 1:28 PM, Markus Moeller <huaraz@moeller.plus.com> wrote:
> Thank you for looking at this.  I did post the fstab  in the original post.

Yep! No aware for my observation skills on this thread...

> Here it is again:

Hmm, it's using UUIDs for the Btrfs volumes rather than using the
VG/LV. If you use

# lvs

that'll show the LVM LV's. But Robert already got this figured out.


> The only thing I intended was to separate /,  /var, /opt, /usr and /boot as
> I was used to, to avoid for example /var/log filling up the root filesystem
> ( but now this fails :-( )

/var/log is on system_13.2/root_lv along with a bunch of other things.
According to your first df though, this 5GB root_lv is far from full,
not even 1/2 full. So I don't have a good explanation.

Anyway, long term this layout has maintenance problems, I would start
over. Backing up, restoring, even updating will pose problematic.



-- 
Chris Murphy
