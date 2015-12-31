Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:34822 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbbLaURr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 15:17:47 -0500
Received: by mail-io0-f170.google.com with SMTP id 77so70000434ioc.2
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 12:17:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQxFm5L-RtP9Ph8qaYtG0jVo3PfrHj6U35LJSStB5pyuQ@mail.gmail.com>
References: <CAJCQCtQxFm5L-RtP9Ph8qaYtG0jVo3PfrHj6U35LJSStB5pyuQ@mail.gmail.com>
Date: Thu, 31 Dec 2015 13:17:46 -0700
Message-ID: <CAJCQCtQVqL=DYPQNGUUQGJhhGv1_GbgicZk2kqHzh0jozXefng@mail.gmail.com>
Subject: Re: btrfs fail behavior when a device vanishes
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 31, 2015 at 1:11 PM, Chris Murphy <lists@colorremedies.com> wrote:

> Also, is there a command to make a block device go away?

Maybe?
echo 1 > /sys/block/device-name/device/delete



-- 
Chris Murphy
