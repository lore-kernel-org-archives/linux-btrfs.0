Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:32862 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752152AbdHAUdJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 16:33:09 -0400
Received: by mail-lf0-f52.google.com with SMTP id d17so11869561lfe.0
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Aug 2017 13:33:08 -0700 (PDT)
Subject: Re: Btrfs incremental send | receive fails with Error: File not found
To: linux-btrfs@vger.kernel.org
Cc: Cerem Cem ASLAN <ceremcem@ceremcem.net>
References: <59b8cc62-66fa-6665-45f9-89c6fe91ceaa@gmail.com>
 <403536b6-2404-8589-3536-3a91ae769cd6@freirad.at>
 <8dc4e2a0-3e83-9e60-c565-c86a924ceaf5@gmail.com>
 <CAN4oSBf1pGAS9e-SM_0NAA0jJthrOADOgapWRT+i3akWAO_h+w@mail.gmail.com>
From: A L <crimsoncottage@gmail.com>
Message-ID: <dfe50824-e77a-d07b-e578-5a8d9e2c7478@gmail.com>
Date: Tue, 1 Aug 2017 22:33:06 +0200
MIME-Version: 1.0
In-Reply-To: <CAN4oSBf1pGAS9e-SM_0NAA0jJthrOADOgapWRT+i3akWAO_h+w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 8/1/2017 10:24 PM, Cerem Cem ASLAN wrote:
> What is that mean? Can't we replicate the same snapshot with `btrfs 
> send | btrfs receive` multiple times, because it will have a "Received 
> UUID" at the first `btrfs receive

You will need to make a new read-write snapshot of the received volume 
to fix it. Any snapshots created from the received subvolume can't be 
used for send-receive again, afaik.

# btrfs subvolume snapshot subvolume.received subvolume
