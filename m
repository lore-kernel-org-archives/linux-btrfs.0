Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:34597 "EHLO
        mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753278AbdARVHv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jan 2017 16:07:51 -0500
Received: by mail-lf0-f46.google.com with SMTP id v186so22193119lfa.1
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jan 2017 13:07:50 -0800 (PST)
Received: from Jons-MacBook-Pro.local (ip-213-124-168-107.ip.prioritytelecom.net. [213.124.168.107])
        by smtp.gmail.com with ESMTPSA id 96sm829729lfp.18.2017.01.18.13.07.47
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Jan 2017 13:07:48 -0800 (PST)
To: linux-btrfs@vger.kernel.org
From: Jon <jmoroney@hawaii.edu>
Subject: Raid 1 recovery
Message-ID: <cd74d77f-bba5-6301-f0dc-6b2323adebdb@hawaii.edu>
Date: Wed, 18 Jan 2017 22:07:41 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So, I had a raid 1 btrfs system setup on my laptop. Recently I upgraded
the drives and wanted to get my data back. I figured I could just plug
in one drive, but I found that the volume simply would not mount. I
tried the other drive alone and got the same thing. Plugging in both at
the same time and the volume mounted without issue.

I used raid 1 because I figured that if one drive failed I could simply
use the other. This recovery scenario makes me think this is incorrect.
Am I misunderstanding btrfs raid? Is there a process to go through for
mounting single member of a raid pool?

Thanks,
Jon
