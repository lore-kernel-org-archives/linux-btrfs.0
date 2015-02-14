Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:33745 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbbBNAgH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Feb 2015 19:36:07 -0500
Received: by mail-yk0-f180.google.com with SMTP id 131so9090614ykp.11
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Feb 2015 16:36:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOQhA5Xpv=tgHmvvDp22pBtdoku1JOuuymUJZbPsMhPjn4MJ8g@mail.gmail.com>
References: <CAOQhA5Xpv=tgHmvvDp22pBtdoku1JOuuymUJZbPsMhPjn4MJ8g@mail.gmail.com>
Date: Fri, 13 Feb 2015 17:36:05 -0700
Message-ID: <CAJCQCtSU_mW85uU9euAqM5Uhc8Z2z5V72EuTJcm5ZCfSQrJNcg@mail.gmail.com>
Subject: Re: Kernel bug when deleting snapshot?
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So the volume mounts OK initially, and then some seconds or minutes
later you get the traces posted above? Consider posting the output
from btrfs check (without --repair) and we'll see if that's
enlightening and if someone who knows more suggests trying repair. I
suggest using btrfs-progs 3.18+ for this.

Chris Murphy
