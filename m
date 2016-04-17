Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:36181 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbcDQWgH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Apr 2016 18:36:07 -0400
Received: by mail-ig0-f174.google.com with SMTP id f1so59335448igr.1
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Apr 2016 15:36:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC8+__7+ALM5WK-+aCkH0Nc1GUTV5v=7R0SB9LFFE48YM3NLeg@mail.gmail.com>
References: <CAC8+__7+ALM5WK-+aCkH0Nc1GUTV5v=7R0SB9LFFE48YM3NLeg@mail.gmail.com>
Date: Sun, 17 Apr 2016 16:36:05 -0600
Message-ID: <CAJCQCtTh_nDmjf+5MMkHoi6oe4wM51o709m24xZpagT5PMWuQw@mail.gmail.com>
Subject: Re: [resend] btrfs-send -c fails: reproduction case
From: Chris Murphy <lists@colorremedies.com>
To: Zachary Vance <vanceza@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 17, 2016 at 3:55 PM, Zachary Vance <vanceza@gmail.com> wrote:

> To recap, the basic problem is that you can get into a state where
> "btrfs-send -c" fails for a subvolume, with "ERROR: parent
> determination failed for 9622". It appears the problem happens when
> the 'parent_uuid' does not exist.
>
> I'm pretty sure this isn't the intended behavior, and it's certainly
> preventing me from copying my backups right now.

Duncan replied to the original post.
http://www.spinics.net/lists/linux-btrfs/msg54275.html



-- 
Chris Murphy
