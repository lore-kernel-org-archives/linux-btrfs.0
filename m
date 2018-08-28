Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:34269 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727192AbeH1PBf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 11:01:35 -0400
Received: by mail-io0-f181.google.com with SMTP id c22-v6so1090673iob.1
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Aug 2018 04:10:26 -0700 (PDT)
Subject: Re: BTRFS support per-subvolume compression, isn't it?
To: Eugene Bright <eugene@bright.gdn>, linux-btrfs@vger.kernel.org
References: <9433856.DUzOFri1R6@linux.local>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <6ce9fe54-71ac-4fbe-4423-2a7a1df4087b@gmail.com>
Date: Tue, 28 Aug 2018 07:10:23 -0400
MIME-Version: 1.0
In-Reply-To: <9433856.DUzOFri1R6@linux.local>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-08-27 17:05, Eugene Bright wrote:
> Greetings!
> 
> BTRFS wiki says there is no per-subvolume compression option [1].
> 
> At the same time next command allow me to set properties per-subvolume:
>          btrfs property set /volume compression zstd
> 
> Corresponding get command shows distinct properties for every subvolume.
> Should wiki be updated?
> 
The wiki should be updated, but it's not technically wrong.

What the wiki is talking about is per-subvolume mount options to control 
compression (so, mounting individual subvolumes from the same volume 
with different `compress=` or `compress-force=` mount options), which is 
not currently supported.

You are correct though that properties can be used to achieve a similar 
result (compressing differently for different subvolumes.
