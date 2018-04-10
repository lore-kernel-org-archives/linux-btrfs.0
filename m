Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f182.google.com ([74.125.82.182]:33759 "EHLO
        mail-ot0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752700AbeDJNI4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Apr 2018 09:08:56 -0400
Received: by mail-ot0-f182.google.com with SMTP id 23-v6so12620381otj.0
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Apr 2018 06:08:56 -0700 (PDT)
MIME-Version: 1.0
From: James Courtier-Dutton <james.dutton@gmail.com>
Date: Tue, 10 Apr 2018 14:08:15 +0100
Message-ID: <CAAMvbhG37R8qTD3u=K7ao1GxmdeH6ieQDw-tpMK1yBoh9nxRRw@mail.gmail.com>
Subject: How to zero errors
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have  disk that in the past had errors on it.
I have fixed up the errors.
btrfs scrub now reports no errors.
How do I reset these counters to zero?

BTRFS info (device sdc2): bdev /dev/sdc2 errs: wr 0, rd 35, flush 0,
corrupt 1, gen 0


Kind Regards


James
