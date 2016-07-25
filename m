Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:33766 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbcGYVPI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jul 2016 17:15:08 -0400
Received: by mail-io0-f173.google.com with SMTP id 38so176207532iol.0
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jul 2016 14:15:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTUGxfTgjLAqCC7_k-8PK9dYZHFJMchih-zQBxApvURRA@mail.gmail.com>
References: <CAAcuexAaxha03vnwAC1bW6hcjEpH4GoQr2YBps=vWAu3RS8FJg@mail.gmail.com>
 <CAJCQCtTUGxfTgjLAqCC7_k-8PK9dYZHFJMchih-zQBxApvURRA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 25 Jul 2016 15:15:07 -0600
Message-ID: <CAJCQCtSzxrxYsWf5kryKAMN+yD1FAwyNNYwTeJaiZyLzsBLR3w@mail.gmail.com>
Subject: Re: Any suggestions for thousands of disk image snapshots ?
To: Chris Murphy <lists@colorremedies.com>
Cc: Kurt Seo <tiger.anam.manager@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 25, 2016 at 2:49 PM, Chris Murphy <lists@colorremedies.com> wrote:

> 1. mdadm raid10 + LVM thinp + either XFS or Btrfs.

You probably want to use LVM thin provisioning because its snapshot
implementation is much faster and more hands off than thick
provisioning.

And you'll need to use mdadm raid10 instead of LVM raid10 because
thinp doesn't support RAID.



-- 
Chris Murphy
