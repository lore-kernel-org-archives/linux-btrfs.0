From: "krzf83@gmail.com " <krzf83@gmail.com>
Subject: btrfs subvolume snapshot syntax too "smart"
Date: Mon, 4 Apr 2011 21:09:12 +0200
Message-ID: <BANLkTikvyUH2Dhm2p=N-GSzy7r4_nj=bNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I understand btrfs intent but same command run twice should not give
diffrent results. This really makes snapshot automation hard


root@sv12 [/ssd]# btrfs subvolume snapshot /ssd/sub1 /ssd/5
Create a snapshot of '/ssd/sub1' in '/ssd/5'
root@sv12 [/ssd]# btrfs subvolume snapshot /ssd/sub1 /ssd/5
Create a snapshot of '/ssd/sub1' in '/ssd/5/sub1'
root@sv12 [/ssd]# btrfs subvolume snapshot /ssd/sub1 /ssd/5
Create a snapshot of '/ssd/sub1' in '/ssd/5/sub1'
ERROR: cannot snapshot '/ssd/sub1'
