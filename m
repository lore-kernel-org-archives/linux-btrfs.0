Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:44530 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751668AbdIKMtW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 08:49:22 -0400
Received: by mail-it0-f50.google.com with SMTP id r131so6890002itc.1
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Sep 2017 05:49:22 -0700 (PDT)
Subject: Re: Please help with exact actions for raid1 hot-swap
To: Marat Khalili <mkh@rqc.ru>, Patrik Lundquist <patrik.lundquist@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <01258ddc-1d34-4cc9-d668-21cbe88ab1d0@rqc.ru>
 <9D2B6B65-7DE9-4922-82DC-08BF3A3A2E09@rqc.ru>
 <CAA7pwKMuv69dsXZGXEASN=qarSv3tCYU=-k1sHquL_tm4FU0kw@mail.gmail.com>
 <BB503B0C-5A1A-4ADE-9EDA-B07D9C6DA138@rqc.ru>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <dba3c5d5-b196-ddac-dcd2-01dee95a6f38@gmail.com>
Date: Mon, 11 Sep 2017 08:49:16 -0400
MIME-Version: 1.0
In-Reply-To: <BB503B0C-5A1A-4ADE-9EDA-B07D9C6DA138@rqc.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-10 02:33, Marat Khalili wrote:
> It doesn't need replaced disk to be readable, right? Then what prevents same procedure to work without a spare bay?
> 
In theory, nothing.

In practice, there are reliability issues with mounting a filesystem 
degraded (and you should be avoiding running any array degraded, 
regardless of if it's BTRFS or actual RAID (be that LVM, MD, or 
hardware)).  It's also significantly faster to do it with a spare drive 
bay because that will just read from the device being replaced and copy 
data directly, while pulling the device to be replaced requires 
rebuilding the data (there is more involved than just copying, even with 
a raid1 profile).
