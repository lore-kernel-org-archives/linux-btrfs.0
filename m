Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35406 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbeHLGqR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 Aug 2018 02:46:17 -0400
Received: by mail-oi0-f66.google.com with SMTP id m11-v6so22147517oic.2
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Aug 2018 21:09:47 -0700 (PDT)
MIME-Version: 1.0
References: <20180812013358.16431-1-wqu@suse.com>
In-Reply-To: <20180812013358.16431-1-wqu@suse.com>
From: Dan Merillat <dan.merillat@gmail.com>
Date: Sun, 12 Aug 2018 00:09:35 -0400
Message-ID: <CAPL5yKcaZWy-kknXfZ0dfxdJ6NYrBeAe0bWUzHmG1joaQPW=oQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: rescue: Add ability to disable quota offline
To: wqu@suse.com, BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 11, 2018 at 9:34 PM Qu Wenruo <wqu@suse.com> wrote:
>
> Provide an offline tool to disable quota.
>
> For kernel which skip_balance doesn't work, there is no way to disable
> quota on huge fs with balance, as quota will cause balance to hang for a
> long long time for each tree block switch.
>
> So add an offline rescue tool to disable quota.
>
> Reported-by: Dan Merillat <dan.merillat@gmail.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

That fixed it, thanks.

Tested-By: Dan Merillat <dan.merillat@gmail.com>
