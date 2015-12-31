Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:37360 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbbLaJBz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 04:01:55 -0500
Received: by mail-wm0-f44.google.com with SMTP id f206so104735746wmf.0
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 01:01:54 -0800 (PST)
Received: from orione.localnet (183.Red-83-50-202.dynamicIP.rima-tde.net. [83.50.202.183])
        by smtp.gmail.com with ESMTPSA id e62sm60615550wma.11.2015.12.31.01.01.52
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 31 Dec 2015 01:01:53 -0800 (PST)
From: =?ISO-8859-1?Q?fugazzi=AE?= <fugazzi99@gmail.com>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: BTRFS - Write Barriers
Date: Thu, 31 Dec 2015 09:01:51 +0000
Message-ID: <4794805.EoAJ2iVUQK@orione>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone :-)

Just one question for the gurus here. 

I was wondering: if I disable write barriers in btrfs with the mount option 
nobarrier I just disable the periodic flushes of the hardware disk cache or 
I'm disabling also the order of the writes directed to the hard disk?

What I mean is: is it safe to disable write barrier with a UPS with which I 
will likely have the hardware always powered even in the event of a kernel 
crash, freeze, etc?

I'm asking because if also the ordering of the write is no more guaranteed I 
guess it would not be safe to disable write barrier even if the possibility of 
an unexpected power down of the HD was remote because in the case of a crash 
the order of the write would be messed up anyway and we could boot up with a 
completely corrupted fs.

Thank you very much for your kinds answers.
Warm Regards,
Mario
