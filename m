Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f50.google.com ([209.85.216.50]:41023 "EHLO
	mail-vn0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932213AbbGPBfa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jul 2015 21:35:30 -0400
Received: by vnbf62 with SMTP id f62so6505173vnb.8
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2015 18:35:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0CF53779-ED80-4311-864F-CEF960C45ABA@gmail.com>
References: <0CF53779-ED80-4311-864F-CEF960C45ABA@gmail.com>
Date: Wed, 15 Jul 2015 19:35:29 -0600
Message-ID: <CAJCQCtSTkt-NN3YMnTcdCr3vUy+EwG19VBUaHyaMi8uQiSquZg@mail.gmail.com>
Subject: Re: I'd like a -r flag on btrfs subvolume delete
From: Chris Murphy <lists@colorremedies.com>
To: Johannes Ernst <johannes.ernst@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 15, 2015 at 6:11 PM, Johannes Ernst
<johannes.ernst@gmail.com> wrote:

> Cleaning this all up is a bit of pain, and
>         btrfs subvolume delete -r dir
> would solve it nicely.

It's come up before:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg42455.html
http://lists.freedesktop.org/archives/systemd-devel/2015-April/030297.html

I'm concerned about the interaction of machinectl snapshots of its own
subvolumes, and rpm-ostree, and snapper snapshots.

The only really convincing argument for tested subvolumes I've read is
as an explicit break from being included in the snapshotting above it
in the hierarchy.

So the /var/lib/machines organization burdens other projects or users
with the problem of how / or /var is snapshot and then a rollback
happens, how to properly reassemble the system that includes
/var/lib/machines subvolumes that are now in a different tree. How
does this all get located and assembled properly at boot time?

How is all of this backed up properly? How is it restored properly? I
think recursive snapshotting and subvolume deletion is not a good
idea. I think it's a complicated and inelegant work around for
improper subvolume organization.


-- 
Chris Murphy
