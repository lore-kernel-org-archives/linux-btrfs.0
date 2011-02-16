From: Gal Buki <buki@torus.ch>
Subject: combining 2 RAID 10 pools to one filesystem
Date: Wed, 16 Feb 2011 22:50:57 +0200
Message-ID: <4D5C38B1.70202@torus.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I have RAID 10 using 4 times 500GB drives (1TB of storage).
Is it possible to create another RAID 10 with 4 times 250GB drives 
(500GB of storage) and then combine those two RAIDs to one file system 
so that I would be able to get 1.5TB?

If I create one RAID 10 with all 8 drives I would only be able to use 8 
times 250GB /2 = 1TB, right?

Thanks,
Gal
