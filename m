Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49757 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753959AbcJLHA0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 03:00:26 -0400
Subject: Re: RAID system with adaption to changed number of disks
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <D379E551-1272-4548-9601-0CE4C1A8C012@unige.ch>
 <20161011160601.GI7683@carfax.org.uk>
 <CAJCQCtSY2Y5AsW2FC5FGP3x3Vaz6Y10=EbAE-0FKFQAqg0oGkg@mail.gmail.com>
 <3da9a459-c63b-570c-5b42-c7186b3a74fd@cn.fujitsu.com>
 <20161012043718.GW21290@hungrycats.org>
Cc: Chris Murphy <lists@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Austin Hemmelgarn <ahferroin7@gmail.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <80e7ca39-b221-6930-052e-de920b1c10d1@oracle.com>
Date: Wed, 12 Oct 2016 15:02:03 +0800
MIME-Version: 1.0
In-Reply-To: <20161012043718.GW21290@hungrycats.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




> Missing device is the _only_ thing the current design handles.

Right. below patches in the ML added two more device states
offline and failed. It is tested with raid1.

[PATCH 11/13] btrfs: introduce device dynamic state transition to 
offline or failed

[PATCH 12/13] btrfs: check device for critical errors and mark failed

Thanks, Anand
