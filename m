Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:42408 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751790AbdDKD4X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 23:56:23 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cxmuc-0000nw-9N
        for linux-btrfs@vger.kernel.org; Tue, 11 Apr 2017 05:56:14 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfs filesystem keeps allocating new chunks for no apparent
 reason
Date: Tue, 11 Apr 2017 05:56:14 +0200
Message-ID: <20170411055614.57cb6402@jupiter.sol.kaishome.de>
References: <572D0C8B.8010404@mendix.com>
        <89a684c7-364e-f409-5348-bc0077fd438c@cn.fujitsu.com>
        <5b642448-951e-5b5e-1343-0299a950089c@mendix.com>
        <51778c0f-2720-1c2d-aba2-e22e5f4d3a3a@mendix.com>
        <4532f6ee-2a6e-412a-7230-edb76735d55f@mendix.com>
        <07a7f59e-64e0-4d09-5d32-01bc933fe38d@gmail.com>
        <20170410144533.664fc304@jupiter.sol.kaishome.de>
        <5488ea5a-b41c-5987-e664-ec17cf2d5e01@gmail.com>
        <20170410184444.08ced097@jupiter.sol.local>
        <20170410185437.235b3b86@jupiter.sol.kaishome.de>
        <7ea65b63-d399-c049-d466-681c1df2d025@gmail.com>
        <20170410201842.216893be@jupiter.sol.kaishome.de>
        <CANznX5Gu+TGUt83noijQA9r_m+d_pWPM2kuozFEGSZBRYvt9wQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Tue, 11 Apr 2017 01:45:32 +0200
schrieb "Janos Toth F." <toth.f.janos@gmail.com>:

> >> The command-line also rejects a number of perfectly legitimate
> >> arguments that BTRFS does understand too though, so that's not much
> >> of a test.  
> >
> > Which are those? I didn't encounter any...  
> 
> I think this bug still stands unresolved (for 3+ years, probably
> because most people use init-rd/fs without ever considering to omit it
> in case they don't really need it at all):
> Bug 61601 - rootflags=noatime causes kernel panic when booting
> without initrd. The last time I tried it applied to Btrfs as well:
> https://bugzilla.kernel.org/show_bug.cgi?id=61601#c18

Ah okay, so the difference is with the mount handler. I can only use
initrd here because I have multi-device btrfs ontop of bcache as rootfs.

-- 
Regards,
Kai

Replies to list-only preferred.

