From: Mario Lopez <mario.lopez@techsym.com>
Subject: Understanding Default RAID Behavior
Date: Mon, 06 Feb 2012 23:58:49 -0500
Message-ID: <4F30AF89.4090402@techsym.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The Wiki does not make it clear as to why adding a secondary device 
defaults to RAID1 metadata and RAID0 data. I bought two SSDs with the 
intention of doing a BTRFS RAID0 for my root.

What is the difference between forcing RAID0 on metadata and data as 
opposed to the default behavior? Can anyone clarify that?

Thank you for your time,
Mario
