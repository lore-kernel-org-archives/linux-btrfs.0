Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:42487 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbcGKOMc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 10:12:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 11 Jul 2016 23:12:28 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs won't mount to /home
In-Reply-To: <20160711185613.0f03d47b@natsu>
References: <b44f915ca2d728f0fde9848f09524ecb@admin.virtall.com>
 <20160711185613.0f03d47b@natsu>
Message-ID: <9e72fca1a009ae3e0cd97ad34a3fcb38@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-11 22:56, Roman Mamedov wrote:
> On Mon, 11 Jul 2016 22:45:13 +0900
> Tomasz Chmielewski <tch@virtall.com> wrote:
> 
>> So, weird, isn't it?
>> 
>> What's wrong there?
> 
> Your systemd unmounts it immediately from /home, search the archives 
> there's
> been a funny story like that recently.

Yes, could be similar to this one: https://bugs.archlinux.org/task/44658

In my case, the entry did exist in /etc/fstab, but was different than at 
the time of booting the system.



Tomasz Chmielewski
https://wpkg.org
