Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:38631 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbaATPoA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jan 2014 10:44:00 -0500
Received: by mail-la0-f49.google.com with SMTP id y1so5593037lam.8
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jan 2014 07:43:59 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 20 Jan 2014 10:43:59 -0500
Message-ID: <CANjusZdjBTzreOTc3xvNeiu-LOBzbO2kLCOmjn=m19B-76m67w@mail.gmail.com>
Subject: Confirmation on how btrfs works with RAID and single.
From: "G. Michael Carter" <mikey@carterfamily.ca>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm pretty sure I know the answers but just wanted confirmation.


RAID1:  When it reads does it read from only one disk or does it try
to read from multiple disks?

Single:  When it writes does it simple fill up one drive then move to
the next or does it write in a round robin type fashion?
