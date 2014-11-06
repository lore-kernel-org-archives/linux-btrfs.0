Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:61955 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbaKFPCZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Nov 2014 10:02:25 -0500
Received: by mail-wi0-f169.google.com with SMTP id n3so1705126wiv.0
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Nov 2014 07:02:24 -0800 (PST)
Received: from [192.168.2.15] ([212.103.222.226])
        by mx.google.com with ESMTPSA id hk9sm8096111wjb.46.2014.11.06.07.02.22
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Nov 2014 07:02:23 -0800 (PST)
Message-ID: <545B8D7E.6060606@gmail.com>
Date: Thu, 06 Nov 2014 16:02:22 +0100
From: Francesco Morosinotto <jlord87@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: are btrfs snapshot helpful for backing up kvm qcow2 vm?
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys,

I need to improve the backup strategy of my vms; At the moment I backup the machines once a week by stopping them, making a snapshot, exporting the xml descriptor file and backing up these files.

I would prefer a daily online backup solution that allows me to take a snapshot with a minimum downtime.

That's why I was planning to switch from etx4 to btrfs;
my project will be to  pause the vm, dump the memory and the xml descriptor file, make a snapshot of the subvolume storing the qcow2 file and after that resuming the machine.

does this project makes any sense? What about performance? Am I going to experience bad performance having qcow2 over btrfs?
I read on some old (two years) posts that btrfs was having bad fragmentation when dealing with qcow2 files, is this still happening?

Thank you

Francesco


