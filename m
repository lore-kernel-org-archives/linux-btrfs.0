Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:38573 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbbFIIpe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jun 2015 04:45:34 -0400
Received: by wibdq8 with SMTP id dq8so8581337wib.1
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jun 2015 01:45:32 -0700 (PDT)
Received: from [136.225.129.30] (sessfw99-sesbfw99-94.ericsson.net. [192.176.1.94])
        by mx.google.com with ESMTPSA id u7sm1683711wif.3.2015.06.09.01.45.31
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Tue, 09 Jun 2015 01:45:32 -0700 (PDT)
From: Trollkarlen Marklund <robbelibobban@gmail.com>
Content-Type: text/plain; charset=us-ascii
Subject: superblock recovery raid0
Message-Id: <20EA23B4-B6B7-45A8-B045-917BEA32F0E2@gmail.com>
Date: Tue, 9 Jun 2015 10:39:49 +0200
To: =?utf-8?Q?=22=E2=80=9Clinux-btrfs=40vger=2Ekernel=2Eorg=E2=80=9D?=
	 =?utf-8?Q?=22?= <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi!

I have a two disk in raid0 where one of the disks have failed. Approximately  17Mb cant be read from the disk, due to hardware issues. I made a clone of the disk but all 3 superblocks are in the non-readable areas :( 

So my question is, is there any tool to recreate the superblock from the content of the disk and the superblock from the non-failing disk in the array ?
Any other suggestions is also welcome so solve the situation.


/R 