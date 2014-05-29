Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f181.google.com ([209.85.128.181]:45637 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447AbaE2TwG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 May 2014 15:52:06 -0400
Received: by mail-ve0-f181.google.com with SMTP id pa12so969552veb.40
        for <linux-btrfs@vger.kernel.org>; Thu, 29 May 2014 12:52:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1401325356-27683-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1401325356-27683-1-git-send-email-quwenruo@cn.fujitsu.com>
Date: Thu, 29 May 2014 20:52:04 +0100
Message-ID: <CAMU1PDhBuk46VgwNVnO_1JzOgZka1wd8dMvTjECwTRBsfZeghQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: Add dev uuid output for print_dev_item().
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 29 May 2014 02:02, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> The original print_dev_item() only prints device id,total bytes and
> bytes used.
> When it comes to debug things related to duplicated device id, dev uuid
> is needed to distinguish different device since device is is no
> reliable.

At the end of the message I think there is a couple of typos and you meant:
... device id is not reliable.

>
> This patch added dev uuid output.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  print-tree.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)

Thanks,
Mike
