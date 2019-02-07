Return-Path: <SRS0=taZz=QO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9059C282C2
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 11:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D84B218FE
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 11:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbfBGLER (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Feb 2019 06:04:17 -0500
Received: from mout.gmx.net ([212.227.15.18]:43829 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726549AbfBGLER (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Feb 2019 06:04:17 -0500
Received: from t460-skr.localnet ([194.94.224.254]) by mail.gmx.com (mrgmx001
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0LjIit-1hOZmb1EtD-00dYBC for
 <linux-btrfs@vger.kernel.org>; Thu, 07 Feb 2019 12:04:14 +0100
From:   Stefan K <shadow_7@gmx.net>
To:     linux-btrfs@vger.kernel.org
Subject: Re: btrfs as / filesystem in RAID1
Date:   Thu, 07 Feb 2019 12:04:13 +0100
Message-ID: <2159107.RxXdQBBoNF@t460-skr>
User-Agent: KMail/5.2.3 (Linux/4.9.0-8-amd64; KDE/5.28.0; x86_64; ; )
In-Reply-To: <92ae78af-1e43-319d-29ce-f8a04a08f7c5@mendix.com>
References: <33679024.u47WPbL97D@t460-skr> <92ae78af-1e43-319d-29ce-f8a04a08f7c5@mendix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:Czh0gF5txwDca8JnAJHuk1JlgKKCtLjvl+pwANaOV6ucHk0tGfy
 IJmdYCuNFk4A93V5jUjNJB1twxHXYbGosxAvEyBSysqd8tVgqz8qdNixfffIZFjvswmucfI
 IM3o3qEgy4bBhzVEKT9GaUoiKEql5N6NjMYunEHTeuKSdP22b346p8DT3CrDH22wpKGGQIQ
 P4/xekwabT4rcSmQa/Vvw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:eWwgF2dPbps=:3K83YBiGOGvj2DwzMKLWTb
 v6ntSYUn8ABd+itbopwr1ahvSdO+3bCpfRRRONPOo/ZLTf9Q8sDDxW9rHHYWWFAO9QVjrs2X8
 YPL4I6xTV+7WquNLrlMQK2iyQux9fltJFXTu0Ym62lx2IwMQEvMRhbdJd15cixV5v0w9WmOfD
 Bogs9jThP1zImyNwNldOQbQj7pUCfJGRXbFahzyTZbZEY1RLcxTPk/YSYGcTyW6M0FRzpcbQL
 iozipvUntXbiZ79zW0sRDz1ms+kvK1XAWXDkmmb6xNCaM2FEU4gP0kjV6FDIsy9OQU5UuZUKK
 R6RL67dI1Q2JsknVDHCRkakllPJhiZaX7xXVRbevE3NCJhCXSpoIcPhmKtQpyQQx53lPnqk1M
 qMb9+uPQPZDtQkNQ/6G0FxMJ8CyZ3DcAi4LoUMXZjVjV1OeO9DS1AydaezKqWrovquV47xe1H
 DcQ+x8FsVQYF0WfEJzCAhzdmil23FtQPQKcLDlmuhrGGTqp11+bPF3oKan7qW3UsQDlFg1Yi0
 aTJuvwyiXSwNa0cWosgU359d02ixqLL22CGJXyxancbGWweNJz3mg9tkzrLYEfROtZhKrr6Hf
 rVAYadAQROqyVxjty1tAp/ZfXwwFxTMvymPgw1u4Fm3q83ndgqK9zHPDMnd5SpFuPuSxLILqq
 vuhg8jfD4aj6R6rT4hGmF0A6F1RDc38WcUevJRSAVTKkSnCw/PiIbCk9y26BuEN5cY8CfQv8f
 c0L+Nt31fFtZfu3M4bKCRVI7+o4POCgxR2jCPEyaANbzm19yy19GhKFk2QjZMpEf0qlfKW3ts
 WehGF2lEiOvlEj9FhmcsFAr8Arf5hXWIRloG3GNWedKXtrQMYJgM16PaGtX9/MMrLaF5vKZNi
 niyCW0z4A8yraJDrOT7v9YSPjIhMqIeNGWgvvUxmAln200k9yNagjOFemZhmnHfKVxXI0kS3E
 S5SwpO+C4bA==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Thanks, with degraded  as kernel parameter and also ind the fstab it works like expected

That should be the normal behaviour, cause a server must be up and running, and I don't care about a device loss, thats why I use a RAID1. The device-loss problem can I fix later, but its important that a server is up and running, i got informed at boot time and also in the logs files that a device is missing, also I see that if you use a monitoring program.

So please change the normal behavior

On Friday, February 1, 2019 7:13:16 PM CET Hans van Kranenburg wrote:
> Hi Stefan,
> 
> On 2/1/19 11:28 AM, Stefan K wrote:
> > 
> > I've installed my Debian Stretch to have / on btrfs with raid1 on 2
> > SSDs. Today I want test if it works, it works fine until the server
> > is running and the SSD get broken and I can change this, but it looks
> > like that it does not work if the SSD fails until restart. I got the
> > error, that one of the Disks can't be read and I got a initramfs
> > prompt, I expected that it still runs like mdraid and said something
> > is missing.
> > 
> > My question is, is it possible to configure btrfs/fstab/grub that it
> > still boot? (that is what I expected from a RAID1)
> 
> Yes. I'm not the expert in this area, but I see you haven't got a reply
> today yet, so I'll try.
> 
> What you see happening is correct. This is the default behavior.
> 
> To be able to boot into your system with a missing disk, you can add...
>     rootflags=degraded
> ...to the linux kernel command line by editing it on the fly when you
> are in the GRUB menu.
> 
> This allows the filesystem to start in 'degraded' mode this one time.
> The only thing you should be doing when the system is booted is have a
> new disk present already in place and fix the btrfs situation. This
> means things like cloning the partition table of the disk that's still
> working, doing whatever else is needed in your situation and then
> running btrfs replace to replace the missing disk with the new one, and
> then making sure you don't have "single" block groups left (using btrfs
> balance), which might have been created for new writes when the
> filesystem was running in degraded mode.
> 
> -- 
> Hans van Kranenburg
> 

