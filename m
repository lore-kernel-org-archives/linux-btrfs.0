Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:35599 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbbHTAoc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Aug 2015 20:44:32 -0400
Received: by iodt126 with SMTP id t126so29042476iod.2
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Aug 2015 17:44:31 -0700 (PDT)
Received: from [10.0.1.243] (172-11-78-36.lightspeed.cicril.sbcglobal.net. [172.11.78.36])
        by smtp.gmail.com with ESMTPSA id j3sm2055921ige.0.2015.08.19.17.44.31
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 19 Aug 2015 17:44:31 -0700 (PDT)
From: Jonathan Panozzo <jonp@lime-technology.com>
Content-Type: text/plain; charset=utf-8
Subject: Questions on use of NOCOW impact to subvolumes and snapshots
Message-Id: <D3CC3E72-929E-4ADF-826F-62DCB6BD827C@lime-technology.com>
Date: Wed, 19 Aug 2015 19:44:29 -0500
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello btrfs mailing list!

I have a two questions regarding the use of the NOCOW bit and how this affects scrub and snapshots.

Question 1:  If I apply the NOCOW attribute to a file or directory, how does that affect my ability to run btrfs scrub?

Question 2:  If I apply the NOCOW attribute recursively to a btrfs subvolume I create, then take a snapshot of that subvolume, make changes to the files in the snapshot, and then make changes to the files in the subvolume, does this cause data in the snapshot to be corrupted?  It doesn’t appear so, but I’m confused how it’s not if COW has been disabled using the NOCOW bit.

Regards,

Jonathan Panozzo
Lime Technology, Inc.