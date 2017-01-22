Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:36580 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750894AbdAVBHf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 21 Jan 2017 20:07:35 -0500
Received: by mail-yw0-f174.google.com with SMTP id v200so116921177ywc.3
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Jan 2017 17:07:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170121183649.GV4155@torres.zugschlus.de>
References: <20170121141641.GS4155@torres.zugschlus.de> <3609c150-5871-9581-50b2-bf1af8882cb4@mendix.com>
 <20170121183649.GV4155@torres.zugschlus.de>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 21 Jan 2017 18:07:33 -0700
Message-ID: <CAJCQCtRbOCRy+MCMgK4n7emKZtqUY5=6w=zQYaoCL_X495zXiQ@mail.gmail.com>
Subject: Re: "not a btrfs filesystem"
To: Marc Haber <mh+linux-btrfs@zugschlus.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 21, 2017 at 11:36 AM, Marc Haber
<mh+linux-btrfs@zugschlus.de> wrote:
> On Sat, Jan 21, 2017 at 03:52:19PM +0100, Hans van Kranenburg wrote:
>> You have to point balance to the mount point of the banana, not to the
>> block device. (balance does its work while the file system is mounted)
>
> Idiot me. I always forget that.
>

Well, in your defense the error message is misleading.


Chris Murphy
