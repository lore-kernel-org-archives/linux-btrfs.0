Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40138 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932683AbdLRIyW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Dec 2017 03:54:22 -0500
Subject: Re: Unexpected raid1 behaviour
To: Chris Murphy <lists@colorremedies.com>,
        Peter Grandi <pg@btrfs.list.sabi.co.uk>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <5A357909.8010206@yandex.ru>
 <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk>
 <CAJCQCtT_vM4d4P0XDqGyhWB2gEjB+A1qQ3PADc0CZBGu8CY8BA@mail.gmail.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <cb05a413-3c1f-d673-06ee-9fb261ac10e1@oracle.com>
Date: Mon, 18 Dec 2017 16:49:58 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT_vM4d4P0XDqGyhWB2gEjB+A1qQ3PADc0CZBGu8CY8BA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> formerly missing device - a very big penalty because the whole array
> has to be done to catch it up for what might be only a few minutes of
> missing time.
  For raid1 [1] cli will pick only new chunks.
   [1]
   btrfs bal start -dprofiles=single -mprofiles=single <mnt>

Thanks, Anand
