Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58419 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752384AbeF1DOD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 23:14:03 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 6A00921B18
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2018 23:14:03 -0400 (EDT)
Message-Id: <1530155643.1842027.1422969944.6697CF24@webmail.messagingengine.com>
From: remi@georgianit.com
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
References: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com>
 <5cb96201-e856-e780-7382-dae2ca68f445@gmx.com>
 <3cac9d11-27f4-2d1f-c980-09cfeafa6003@georgianit.com>
 <4852d583-4bdb-bb43-76a3-d14c9ef3f66e@gmx.com>
Date: Wed, 27 Jun 2018 23:14:03 -0400
In-Reply-To: <4852d583-4bdb-bb43-76a3-d14c9ef3f66e@gmx.com>
Subject: Re: Major design flaw with BTRFS Raid,
 temporary device drop will corrupt nodatacow files
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Wed, Jun 27, 2018, at 10:55 PM, Qu Wenruo wrote:

> 
> Please get yourself clear of what other raid1 is doing.

A drive failure, where the drive is still there when the computer reboots, is a situation that *any* raid 1, (or for that matter, raid 5, raid 6, anything but raid 0) will recover from perfectly without raising a sweat. Some will rebuild the array automatically, others will automatically kick out the misbehaving drive.  *none* of them will take back the the drive with old data and start commingling that data with good copy.)\ This behaviour from BTRFS is completely abnormal.. and defeats even the most basic expectations of RAID.

I'm not the one who has to clear his expectations here.

