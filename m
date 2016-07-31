Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:34998 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbcGaA3f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Jul 2016 20:29:35 -0400
Received: by mail-oi0-f45.google.com with SMTP id l72so151817770oig.2
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Jul 2016 17:29:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ4CXjBzR6eo0zibDCb9_p0jAiS2q_fCRUkUNVWiM9i6g@mail.gmail.com>
References: <CAJCQCtQ4CXjBzR6eo0zibDCb9_p0jAiS2q_fCRUkUNVWiM9i6g@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 30 Jul 2016 18:29:33 -0600
Message-ID: <CAJCQCtQ8yPQf8O2LA92-Gd95GGXQiDp-ZomKZgP4bNv-MmKHYw@mail.gmail.com>
Subject: Re: systemd KillUserProcesses=yes and btrfs scrub
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 30, 2016 at 2:02 PM, Chris Murphy <lists@colorremedies.com> wrote:
> Short version: When systemd-logind login.conf KillUserProcesses=yes,
> and the user does "sudo btrfs scrub start" in e.g. GNOME Terminal, and

Same thing with Xfce, so it's not DE specific. (Unsuprising.)

I inflated the size of the test volume, and it seems pretty clear that
the scrub is not completing, as the kernel threads stop sooner when
logging out vs not logging out. So the status reporting an
interruption appears to be valid for the net operation, not merely the
user space tool being interrupted.



-- 
Chris Murphy
