Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:40589 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbaHDDDQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Aug 2014 23:03:16 -0400
Received: by mail-we0-f178.google.com with SMTP id w61so7042649wes.9
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Aug 2014 20:03:14 -0700 (PDT)
Received: from [192.168.1.196] ([87.112.226.108])
        by mx.google.com with ESMTPSA id lh15sm36026844wic.10.2014.08.03.20.03.13
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 03 Aug 2014 20:03:14 -0700 (PDT)
Message-ID: <53DEF7DD.5070002@peter-r.co.uk>
Date: Mon, 04 Aug 2014 04:02:53 +0100
From: Peter Roberts <me@peter-r.co.uk>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Scan not being performed properly on boot
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I've just recently started testing btrfs on my server but after just 24 
hours problems have started. I get booted to a busybox prompt user 
ubuntu 14.04. I have a multi device FS setup and I can't say for sure if 
it managed to boot initially or not but it worked fine in regular usage.

I cannot mount my root with anything other than an explicit /dev/sdx 
reference until I manually run a scan. Then UUID etc all work. I've 
tried setting the /etc/fstab to use that type of reference but it 
doesn't work. In all cases there is some sort of mention of a scan being 
run before mounting fails but it clearly isn't effective.

I would be really appreciative of ant pointers to try and get this going 
again

Thanks

Peter
