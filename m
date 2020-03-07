Return-Path: <SRS0=o+k5=4Y=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1F3CC10F00
	for <linux-btrfs@archiver.kernel.org>; Sat,  7 Mar 2020 21:23:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC6062070A
	for <linux-btrfs@archiver.kernel.org>; Sat,  7 Mar 2020 21:23:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgCGVVz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 7 Mar 2020 16:21:55 -0500
Received: from smtp.radex.nl ([178.250.146.7]:55032 "EHLO radex-web.radex.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726180AbgCGVVz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 7 Mar 2020 16:21:55 -0500
Received: from [10.8.0.6] (cust-178-250-146-69.breedbanddelft.nl [178.250.146.69])
        by radex-web.radex.nl (Postfix) with ESMTPS id 63C5924065
        for <linux-btrfs@vger.kernel.org>; Sat,  7 Mar 2020 22:21:53 +0100 (CET)
From:   Ferry Toth <fntoth@gmail.com>
Subject: Howto take a snapshot from an image as ordinary user?
To:     linux-btrfs@vger.kernel.org
X-Mozilla-News-Host: news://news://nntp.lore.kernel.org:119
Message-ID: <58ad5d52-425a-a89d-d042-e9941088828a@gmail.com>
Date:   Sat, 7 Mar 2020 22:21:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I am generating a btrfs system image using Yocto.

I want to take a snapshot from the image preferably inside a Yocto 
recipe. The snapshot I can send 'over the air' to the remote (IoT) device.

Now I am able to loop mount the image file using udisksctl as an 
ordinary user, which mounts the image under /media/ferry.

However, the owner of the mount point is root, and it appears I am not 
allowed to take a snapshot as an ordinary user.

I think it is obvious that I don't want to run bitbake as root.

So what is the recommended way to generate a snapshot without becoming root?

Thanks,

Ferry

