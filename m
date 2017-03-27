Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:32865 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751740AbdC0D0f (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 26 Mar 2017 23:26:35 -0400
Received: by mail-lf0-f45.google.com with SMTP id h125so13939147lfe.0
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Mar 2017 20:26:34 -0700 (PDT)
Subject: Re: Qgroups are not applied when snapshotting a subvol?
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Moritz Sichert <moritz+linux@sichert.me>, linux-btrfs@vger.kernel.org
References: <4428fdc3-157a-a98e-8ca3-e3701c6c1c80@sichert.me>
 <279513f7-5297-cf2f-aa94-35bef1f674aa@cn.fujitsu.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <2e816c46-7a6a-7db9-a2c3-663dc7d8e6c9@gmail.com>
Date: Mon, 27 Mar 2017 06:26:31 +0300
MIME-Version: 1.0
In-Reply-To: <279513f7-5297-cf2f-aa94-35bef1f674aa@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

27.03.2017 03:39, Qu Wenruo пишет:
> 
> 
> At 03/26/2017 06:03 AM, Moritz Sichert wrote:
>> Hi,
>>
>> I tried to configure qgroups on a btrfs filesystem but was really
>> surprised that when you snapshot a subvolume, the snapshot will not be
>> assigned to the qgroup the subvolume was in.
>>
>> As an example consider the small terminal session in the attachment: I
>> create a subvol A, assign it to qgroup 1/1 and set a limit of 5M on
>> that qgroup. Then I write a file into A and eventually get "disk quota
>> exceeded". Then I create a snapshot of A and call it B. B will not be
>> assigned to 1/1 and writing a file into B confirms that no limits at
>> all are imposed for B.
>>
>> I feel like I must be missing something here. Considering that
>> creating a snapshot does not require root privileges this would mean
>> that any user can just circumvent any quota and therefore make them
>> useless.
>>
>> Is there a way to enforce quotas even when a user creates snapshots?
>>
> 
> Yes, there is always method to attach the subvolume/snapshot to
> specified higher level qgroup.
> 
> Just use "btrfs subvolume snapshot -i 1/1".
> 

This requires cooperation from whoever creates subvolume, while the
question was - is it possible to enforce it, without need for explicit
option/action when snapshot is created.

To reiterate - if user omits "-i 1/1" (s)he "escapes" from quota
enforcement.


