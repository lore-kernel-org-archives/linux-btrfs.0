Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-eopbgr40052.outbound.protection.outlook.com ([40.107.4.52]:1554
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729705AbeHOCXe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Aug 2018 22:23:34 -0400
Subject: Re: How to ensure that a snapshot is not corrupted?
To: Cerem Cem ASLAN <ceremcem@ceremcem.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAN4oSBd9aVn9Ruv83fd=oE4hJhGw7y3f1EbJ+SNbHMZZyZo=Mw@mail.gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <e7f68ff6-fc0f-a2ca-06d1-f364c378f8fc@mendix.com>
Date: Wed, 15 Aug 2018 01:33:56 +0200
MIME-Version: 1.0
In-Reply-To: <CAN4oSBd9aVn9Ruv83fd=oE4hJhGw7y3f1EbJ+SNbHMZZyZo=Mw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/10/2018 12:07 PM, Cerem Cem ASLAN wrote:
> Original question is here: https://superuser.com/questions/1347843
> 
> How can we sure that a readonly snapshot is not corrupted due to a disk failure?
> 
> Is the only way calculating the checksums one on another and store it
> for further examination, or does BTRFS handle that on its own?

It's no different than any other data stored in your filesystem.

So when just reading things from the snapshot, or when using the btrfs
scrub functionality, it will tell you if data that is read back matches
the checksums.

-- 
Hans van Kranenburg
