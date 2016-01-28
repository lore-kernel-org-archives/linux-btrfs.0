Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:35648 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965872AbcA1Pwu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jan 2016 10:52:50 -0500
Received: by mail-wm0-f48.google.com with SMTP id r129so30967049wmr.0
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jan 2016 07:52:49 -0800 (PST)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com. [74.125.82.54])
        by smtp.googlemail.com with ESMTPSA id w62sm3429233wmg.21.2016.01.28.07.52.48
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 Jan 2016 07:52:48 -0800 (PST)
Received: by mail-wm0-f54.google.com with SMTP id l66so31203508wml.0
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jan 2016 07:52:48 -0800 (PST)
MIME-Version: 1.0
From: Dan Fuhry <dan@fuhry.com>
Date: Thu, 28 Jan 2016 10:52:28 -0500
Message-ID: <CAO8L9g6EpXMNjWVunz2A-EPwGHBo=18T_a+3xovqMbHux3aHsw@mail.gmail.com>
Subject: [PATCH] Add support for RENAME_{EXCHANGE,WHITEOUT}
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add support for the RENAME_WHITEOUT and RENAME_EXCHANGE flags in
renameat2(). This brings us pretty close to having btrfs ready to be
an upper layer for overlayfs. (The last remaining issue is in
btrfs_sync_file, which I'm looking at next if I have time.)

This includes Davide Italiano's implementation of RENAME_EXCHANGE. I
quickly pinged him on github [1] last week to confirm resubmission of
his patch which originally went to this list on 2 April 2015 and
didn't make it in.

This is my first time submitting a kernel patch, I think I've covered
all the style recommendations, and also addressed Filipe David
Manana's review notes [2] on Davide Italiano's patch. Certainly let me
know if there's anything else that should be cleaned up. Thanks!

[1] https://github.com/fuhry/linux/commit/9a7300d973a192193857c595997f292a14c14197#commitcomment-15570553
[2] https://www.marc.info/?l=linux-btrfs&m=142796914520768&w=3

--
Dan Fuhry
Senior Software Engineer, Datto Inc
(203) 529-4949 x402 / dfuhry@datto.com
