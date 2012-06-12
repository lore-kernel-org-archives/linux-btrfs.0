Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55851 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab2FLRiU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jun 2012 13:38:20 -0400
Received: by yhmm54 with SMTP id m54so3664577yhm.19
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jun 2012 10:38:19 -0700 (PDT)
Message-ID: <1339522697.2990.10.camel@ayu>
Subject: Re: Massive metadata size increase after upgrade from 3.2.18 to
 3.4.1
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-btrfs@vger.kernel.org
Date: Tue, 12 Jun 2012 13:38:17 -0400
In-Reply-To: <20120609013822.6b06a008@natsu>
References: <20120609013822.6b06a008@natsu>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2012-06-09 at 01:38 +0600, Roman Mamedov wrote:
> Hello,
> 
> Before the upgrade (on 3.2.18):
> 
> Metadata, DUP: total=9.38GB, used=5.94GB
> 
> After the FS has been mounted once with 3.4.1:
> 
> Data: total=3.44TB, used=2.67TB
> System, DUP: total=8.00MB, used=412.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=84.38GB, used=5.94GB
> 
> Where did my 75 GB of free space just went?

Btrfs tries to keep a certain ratio of allocated data space to allocated
metadata space at all times, in order to ensure that there is always
some free metadata space available. In 3.3 (I believe, but haven't
actually checked...) this ratio was increased, since people were still
complaining about btrfs reporting out of space errors too soon.

On a filesystem containing (a relatively small number of) large files,
it probably over-allocates the metadata space, which is what you're
seeing. I'm not sure if the ratio is tunable.

But better to have a bit of unused metadata space than to get 'out of
space' errors once you've filled your disk and you're trying to delete
some files!

-- 
Calvin Walton <calvin.walton@kepstin.ca>

