Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:43224 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932309AbdJZRlv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Oct 2017 13:41:51 -0400
Date: Thu, 26 Oct 2017 22:41:48 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Cheyenne Wills <cheyenne.wills@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Need some assistance/direction in determining a system hang
 during heavy IO
Message-ID: <20171026224148.57e4d035@natsu>
In-Reply-To: <CAHpsFVc8a-2ARN+ESza8e1MYhDk5okww9b0K2DAy9QXeiPQsBw@mail.gmail.com>
References: <CAHpsFVc8a-2ARN+ESza8e1MYhDk5okww9b0K2DAy9QXeiPQsBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 26 Oct 2017 09:40:19 -0600
Cheyenne Wills <cheyenne.wills@gmail.com> wrote:

> Briefly when I upgraded a system from 4.0.5 kernel to 4.9.5 (and
> later) I'm seeing a blocked task timeout with heavy IO against a
> multi-lun btrfs filesystem.  I've tried a 4.12.12 kernel and am still
> getting the hang.

There is now 4.9.58 (fifty three versions later!) and 4.12 series is long
abandoned and gone from the charts altogether. So just in case, did you check
with the latest kernels?

Also, keep in mind the 120 second warnings are just that, and not an error
condition by themselves. You can disable them or increase the maximum timeout
in sysctl settings. And it is not clear from your reports if you only get
warnings and after the load subsides everything is back to normal, or the FS
locks out "for good", i.e. with all access attempts hanging indefinitely and
no way to unmount the FS or otherwise recover.

-- 
With respect,
Roman
