Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:33081 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230AbaGUOBC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jul 2014 10:01:02 -0400
Received: by mail-wg0-f43.google.com with SMTP id l18so6423818wgh.26
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Jul 2014 07:00:58 -0700 (PDT)
MIME-Version: 1.0
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Mon, 21 Jul 2014 17:00:37 +0300
Message-ID: <CAGqmi77KNXYSM_jV-4b_4+nazMxDaFTmSo0Zdw+NZ4Hk8=MCgQ@mail.gmail.com>
Subject: Q: BTRFS_IOC_DEFRAG_RANGE and START_IO
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I working on readahead in systemd and try to complete todo for it.
One of todos it is:
 readahead: use BTRFS_IOC_DEFRAG_RANGE instead of BTRFS_IOC_DEFRAG
ioctl, with START_IO

Can someone explain what start_io flag in BTRFS_IOC_DEFRAG_RANGE do?
Just force write data after defragment or do something else?
This flag mean what btrfs can guarantee data consistency after defragment?

Thanks for any explanation!

-- 
Best regards,
Timofey.
