Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:35440 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbcGASZS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jul 2016 14:25:18 -0400
Received: by mail-oi0-f42.google.com with SMTP id r2so121845759oih.2
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jul 2016 11:25:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTeUUj1W+xG4JmQHBH6JGYEr-V3hJmSA3cJzK1XmP-3Pg@mail.gmail.com>
References: <dc10db83-ce23-161e-0307-9011f4ed4ec7@chefmail.de> <CAJCQCtTeUUj1W+xG4JmQHBH6JGYEr-V3hJmSA3cJzK1XmP-3Pg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 1 Jul 2016 12:25:17 -0600
Message-ID: <CAJCQCtTOV2LDOSO54KVW3bHqyQO6=V4yMYONmFtqGW9zR3t0zQ@mail.gmail.com>
Subject: Re: FYI: *buntu - btrfs kernel error
To: Chris Murphy <lists@colorremedies.com>
Cc: g6094199@freenet.de, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 1, 2016 at 12:24 PM, Chris Murphy <lists@colorremedies.com> wrote:
> This probably needs two more pieces of information:
> 1. What's the workload going on at the time? There's stuff being
> written and cleaned up.
> 2. Issue sysrq+w

echo w > /proc/sysrq-trigger


-- 
Chris Murphy
