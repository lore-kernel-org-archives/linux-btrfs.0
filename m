Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:34710 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236Ab2JECYb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Oct 2012 22:24:31 -0400
Message-ID: <506E4598.60307@oracle.com>
Date: Fri, 05 Oct 2012 10:27:36 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Dong Robin <robin.k.dong@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add parent uuid for snapshots
References: <50584E6D.8000602@cn.fujitsu.com> <1349345524-2822-1-git-send-email-Anand.Jain@oracle.com> <CANsebLGUZE6VL_gGavjr=wLQKQ5BrhkSDOdskxo-Uc63DK4LKw@mail.gmail.com>
In-Reply-To: <CANsebLGUZE6VL_gGavjr=wLQKQ5BrhkSDOdskxo-Uc63DK4LKw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Dong,

>> +       if (puuid)
>> +               memcpy(&ri->uuid, uuid, BTRFS_UUID_SIZE);
>
> I think here is "&ri->puuid"

  Sorry my mistake. Thanks for the review.

-Anand
