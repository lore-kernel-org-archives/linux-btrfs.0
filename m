Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:39866 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965599AbeFSP1L (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 11:27:11 -0400
Received: by mail-it0-f52.google.com with SMTP id p185-v6so942207itp.4
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jun 2018 08:27:11 -0700 (PDT)
MIME-Version: 1.0
From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Date: Tue, 19 Jun 2018 17:26:59 +0200
Message-ID: <CAJH6TXhoL+HLEp8ioMMt06fvykEjM3Usq7OMAk9VwpcsfTBHpA@mail.gmail.com>
Subject: RAID56
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Another kernel release was made.
Any improvements in RAID56?

I didn't see any changes in that sector, is something still being
worked on or it's stuck waiting for something ?

Based on official BTRFS status page, RAID56 is the only "unstable"
item marked in red.
No interested from Suse in fixing that?

I think it's the real missing part for a feature-complete filesystem.
Nowadays parity raid is mandatory, we can't only rely on mirroring.
