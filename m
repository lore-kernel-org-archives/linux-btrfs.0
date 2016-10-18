Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21715 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751027AbcJRVee (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Oct 2016 17:34:34 -0400
Subject: Re: Monitoring Btrfs
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Stefan Malte Schumacher <stefan.m.schumacher@gmail.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
References: <CAA3ktqmhhasyk8L+W3jz9ifYw7UMoL4ueg1HQp7Co3L39xYe9Q@mail.gmail.com>
 <05b79b4d-3f8d-7b78-d386-495b1dab1e70@gmail.com>
 <c40e1675-f002-b2e4-b252-c5e17200f72a@oracle.com>
 <a813c70b-e230-726e-e0bc-e8f15848cc44@gmail.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <a12e3815-98c3-5ab6-179b-2c8efb841533@oracle.com>
Date: Wed, 19 Oct 2016 05:36:51 +0800
MIME-Version: 1.0
In-Reply-To: <a813c70b-e230-726e-e0bc-e8f15848cc44@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>>>> I would like to monitor my btrfs-filesystem for missing drives.


>>> This is actually correct behavior, the filesystem reports that it should
>>> have 6 devices, which is how it knows a device is missing.


>>  Missing - means missing at the time of mount. So how are you planning
>> to monitor a disk which is failed while in production ?

> No, in `btrfs fi show` it means that it can't find the device.

  'btrfs fi show' is miss-leading as compared to 'btrfs fi show -m'
  -m tells btrfs-kernel perspective of the devices, as of now
  there is no code in the kernel which changes the device status
  while its mounted (expect for readonly, which is irrelevant in
  raid1 with 1 disk failed).

> 1. Filesystem flags.  These will change when the filesystem goes
> degraded,

   Which flag is in question here. ?
