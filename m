Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35130 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754832AbcJRDU4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Oct 2016 23:20:56 -0400
Subject: Re: Monitoring Btrfs
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Stefan Malte Schumacher <stefan.m.schumacher@gmail.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
References: <CAA3ktqmhhasyk8L+W3jz9ifYw7UMoL4ueg1HQp7Co3L39xYe9Q@mail.gmail.com>
 <05b79b4d-3f8d-7b78-d386-495b1dab1e70@gmail.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <c40e1675-f002-b2e4-b252-c5e17200f72a@oracle.com>
Date: Tue, 18 Oct 2016 11:23:12 +0800
MIME-Version: 1.0
In-Reply-To: <05b79b4d-3f8d-7b78-d386-495b1dab1e70@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>> I would like to monitor my btrfs-filesystem for missing drives.

> This is actually correct behavior, the filesystem reports that it should
> have 6 devices, which is how it knows a device is missing.

  Missing - means missing at the time of mount. So how are you planning 
to monitor a disk which is failed while in production ?


Good luck

Anand
