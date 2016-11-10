Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from snt004-omc2s17.hotmail.com ([65.55.90.92]:53694 "EHLO
        SNT004-OMC2S17.hotmail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751427AbcKJE0n (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 Nov 2016 23:26:43 -0500
From: Kyle Gates <kylegates@live.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: df missing filesystem when run on subvolume
Date: Thu, 10 Nov 2016 04:21:38 +0000
Message-ID: <CY4PR06MB2726BB2ECD2A2F1758CB7A08B0B80@CY4PR06MB2726.namprd06.prod.outlook.com>
References: <CY4PR06MB27260F46B45E0ABFF9A18C8AB0A00@CY4PR06MB2726.namprd06.prod.outlook.com>
In-Reply-To: <CY4PR06MB27260F46B45E0ABFF9A18C8AB0A00@CY4PR06MB2726.namprd06.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Resending, hopefully correct formatting.

As the title suggests, running the df command on a subvolume doesn't return a filesystem. I'm not sure where the problem lies or if anyone else has noticed this. Some programs fail to detect free space as a result.

Example for clarification:
kyle@home:~$ sudo mount -o subvol=@data /mnt/btrfs/
kyle@home:~$ mkdir /mnt/btrfs/directory
kyle@home:~$ btrfs subvolume create /mnt/btrfs/subvolume
Create subvolume '/mnt/btrfs/subvolume'
kyle@home:~$ sudo btrfs subvolume list /mnt/btrfs/
ID 258 gen 2757271 top level 5 path @data
ID 5684 gen 2718215 top level 258 path subvolume
kyle@home:~$ df /mnt/btrfs/
Filesystem      1K-blocks       Used Available Use% Mounted on
/dev/sdc2      1412456448 1170400072 240688008  83% /mnt/btrfs
kyle@home:~$ df /mnt/btrfs/directory
Filesystem      1K-blocks       Used Available Use% Mounted on
/dev/sdc2      1412456448 1170400072 240688008  83% /mnt/btrfs
kyle@home:~$ df /mnt/btrfs/subvolume
Filesystem      1K-blocks       Used Available Use% Mounted on
-              1412456448 1170400072 240688008  83% /mnt/btrfs/subvolume

Thanks,
Kyle