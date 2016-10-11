Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:37187 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753425AbcJKRGg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2016 13:06:36 -0400
Received: by mail-it0-f49.google.com with SMTP id z65so25603099itc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Oct 2016 10:06:36 -0700 (PDT)
Subject: Re: RAID system with adaption to changed number of disks
To: Philip Louis Moetteli <Philip.Moetteli@unige.ch>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <D379E551-1272-4548-9601-0CE4C1A8C012@unige.ch>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <6e905424-928c-6e9f-a660-064edd12c37c@gmail.com>
Date: Tue, 11 Oct 2016 12:37:18 -0400
MIME-Version: 1.0
In-Reply-To: <D379E551-1272-4548-9601-0CE4C1A8C012@unige.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-10-11 11:14, Philip Louis Moetteli wrote:
> Hello,
>
>
> I have to build a RAID 6 with the following 3 requirements:
>
> 	• Use different kinds of disks with different sizes.
> 	• When a disk fails and there's enough space, the RAID should be able to reconstruct itself out of the degraded state. Meaning, if I have e. g. a RAID with 8 disks and 1 fails, I should be able to chose to transform this in a non-degraded (!) RAID with 7 disks.
> 	• Also the other way round: If I add a disk of what size ever, it should redistribute the data, so that it becomes a RAID with 9 disks.
>
> I don’t care, if I have to do it manually.
> I don’t care so much about speed either.
>
> Is BTrFS capable of doing that?
In theory yes.  In practice, BTRFS RAID5/6 mode should not be used in 
production due to a number of known serious issues relating to 
rebuilding and reshaping arrays.

