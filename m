From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
Subject: Rename BTRfs to MuchSlowerFS ?
Date: Mon, 05 Sep 2011 15:51:17 +0200
Message-ID: <4E64D3D5.7020407@petaramesh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi list,

I don't trust theoretical benchmarks that much and prefer "real-life 
benchs" on the occasion, so here's mine:

Given 4 laptops, the most powerful of which was running BTRFS and the 
others ext3 or ext4, all machines running Ubuntu 11.04 Natty 32-bit with 
a stock Ubuntu 2.6.38-11 kernel, all machines were given the following 
FS-intensive task :

- Upgrade O.S. from Ubuntu 11.04 Natty to 11.10 Oneiric (beta), using a 
local packages apt-cacher.

Machines :

1/ Acer Aspire 3104 WLMi, AMD Sempron Mobile 3500+ @1.8 GHz, 1.5 GB RAM, 
80 GB SATA HD, ext4 over standard partitions

2/ Asus EeePC 1005PE, Intel Atom N450 @1.66 GHz, 2 GB RAM, 250 GB SATA 
HD, ext3 over AES-128 encrypted LVM

3/ Compaq Mini CQ10-740SF, Intel Atom N455 @1.66 GHz, 1 GB RAM, 250 GB 
SATA HD, ext4 over standard partitions

4/ Dell XPS M1330, Intel Core 2 Duo T9300 @2.5 GHz, 2 GB RAM, 160 B SATA 
HD, BTRFS over AES-128 encrypted LVM

Results :

All 3 ext3 /  ext4 machines took between 60 and 90 minutes to complete 
their upgrade.

BTRFS machine took 20 HOURS so far, still counting (ETA 15 minutes left).

Wow. Impressive.
