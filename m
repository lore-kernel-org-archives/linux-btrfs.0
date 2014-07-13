Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:47577 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbaGMPpe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Jul 2014 11:45:34 -0400
Date: Sun, 13 Jul 2014 08:45:14 -0700
From: Marc MERLIN <marc@merlins.org>
To: "Andrew E. Mileski" <andrewm@isoar.ca>, Duncan <1i5t5.duncan@cox.net>,
        Russell Coker <russell@coker.com.au>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Message-ID: <20140713154514.GP10641@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140704011938.GO11539@merlins.org>
 <1937402.nCIA16QR35@xev>
 <20140704060409.GW11539@merlins.org>
 <53B6486D.9010006@jp.fujitsu.com>
 <20140704142416.GI26932@merlins.org>
 <3262371.bchVJ2xl3c@xev>
 <20140704150710.GM26932@merlins.org>
 <pan$949f5$8b3f51a1$835d96eb$bb9ec3bc@cox.net>
 <53B801DD.5040704@isoar.ca>
 <20140705144318.GT26932@merlins.org>
 <53B816FB.7080909@isoar.ca>
 <20140706145815.GD15009@merlins.org>
 <20140713142918.GH10641@merlins.org>
 <20140713153734.GO10641@merlins.org>
Subject: Re: btrfs quotas related to OOM death problems on my 8GB server with
 both 3.15.1 and 3.14?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 13, 2014 at 08:37:34AM -0700, Marc MERLIN wrote:
> On Sun, Jul 13, 2014 at 07:29:18AM -0700, Marc MERLIN wrote:
> > Is /proc/slabinfo supposed to show anything useful?
> > 
> > This is the filesystem in question:
> > gargamel:~# btrfs fi df /mnt/btrfs_pool2/
> > Data, single: total=3.34TiB, used=3.32TiB
> > System, DUP: total=8.00MiB, used=400.00KiB
> > System, single: total=4.00MiB, used=0.00
> > Metadata, DUP: total=77.50GiB, used=59.87GiB
> > Metadata, single: total=8.00MiB, used=0.00
> 
> Mmmh, now that I think of it, I do have quota enabled on that
> filesystem.
> Due to the many many files, this may be what's causing the problem.
> I thought quotas were supposed to work with 3.15, but maybe there is
> still a leak?
> 
> I just turned quotas off and I'm going to let my server run for a while to
> see if the leak stops.

Mmmh, look what I found in my quota output before I turned it off.
Many many unknown subvolumes.

If I were to guess, when I rotate snapshots and delete them, their quota
does not, and a lot of crap stays behind. Not sure if that is causing
the memory leak, but that can't be good.
Hopefully quota disable will have deleted all that cruft and will stop the leak.

gargamel:/mnt/btrfs_pool2# btrfs-quota.py .
subvol                                          group         total    unshared
-------------------------------------------------------------------------------
(unknown)                                       0/5           0.00G       0.00G
backup                                          0/257        -0.00G       0.00G
Soft                                            0/258        59.27G       0.00G
Win                                             0/259       112.60G       0.00G
backup/debian32                                 0/262      -166.13G      -8.72G
backup/debian64                                 0/263       644.62G       0.00G
backup/ubuntu                                   0/264       326.59G      -0.49G
backup-test                                     0/265         0.00G       0.00G
backup/0Notmachines                             0/266       268.16G      -0.13G
backup/1Appliances                              0/566         2.09G       0.00G
backup/win                                      0/570       461.61G       0.00G
(unknown)                                       0/1039        0.00G       0.00G
(unknown)                                       0/1041        0.00G       0.00G
(unknown)                                       0/1044        0.00G       0.00G
(unknown)                                       0/1045        0.00G       0.00G
(unknown)                                       0/1046        0.00G       0.00G
(unknown)                                       0/1047        0.00G       0.00G
(unknown)                                       0/1048        0.00G       0.00G
(unknown)                                       0/1049        0.00G       0.00G
(unknown)                                       0/1050        0.00G       0.00G
(unknown)                                       0/1051        0.00G       0.00G
(unknown)                                       0/1052        0.00G       0.00G
(unknown)                                       0/1053        0.00G       0.00G
(unknown)                                       0/1054      300.95G       0.00G
(unknown)                                       0/1055      300.95G       0.00G
(unknown)                                       0/1056        2.09G       0.00G
(unknown)                                       0/1057        2.09G       0.00G
(unknown)                                       0/1058      461.61G       0.00G
(unknown)                                       0/1059      461.61G       0.00G
(unknown)                                       0/1518        0.00G      -0.00G
(unknown)                                       0/1519        0.00G       0.00G
(unknown)                                       0/1520       59.26G       0.00G
(unknown)                                       0/1521       59.27G       0.00G
(unknown)                                       0/1522      112.60G       0.00G
(unknown)                                       0/1523      112.60G       0.00G
(unknown)                                       0/1524        0.00G       0.00G
(unknown)                                       0/1525        0.00G       0.00G
(unknown)                                       0/1526      278.62G      -2.52G
(unknown)                                       0/1527      282.31G       0.00G

(1600 lines of unknown snipped)

legolas/tmp_ggm_daily_ro.20140527_10:03:17      0/4125        0.22G       0.00G
legolas/tmp_ggm_daily_ro.20140527_10:03:17_daily_20140528_00:03:01      0/4258        0.22G       0.00G
legolas/var_ggm_daily_ro.20140529_10:19:37      0/4565      297.75G       0.00G
legolas/var_ggm_daily_ro.20140530_10:10:24      0/4599      301.64G       0.01G
legolas/var_ggm_daily_ro.20140603_10:22:18      0/4710      303.93G       0.94G
legolas/var_ggm_daily_ro.20140605_10:20:02      0/4764      304.09G       0.00G
legolas/var_ggm_daily_ro.20140606_10:23:59      0/4792      305.97G       0.41G
legolas/tmp_ggm_daily_ro.20140611_10:40:08      0/4938        0.29G       0.01G
legolas/var_ggm_daily_ro.20140613_10:30:23      0/4997      288.92G       0.00G
legolas/var_ggm_daily_ro.20140614_10:26:37      0/5030      289.02G       0.00G
legolas/var_ggm_daily_rw.20140614_10:26:37      0/5032      289.02G       0.00G
backup_weekly_20140615_00:04:01                 0/5051       -0.00G       0.00G
Soft_weekly_20140615_00:04:01                   0/5052       59.27G       0.00G
Win_weekly_20140615_00:04:01                    0/5053      112.60G       0.00G
backup/debian32_weekly_20140615_00:04:01        0/5054       77.47G       0.44G
backup/debian64_weekly_20140615_00:04:01        0/5055      787.45G       0.00G
backup/ubuntu_weekly_20140615_00:04:01          0/5056      340.51G       0.11G
backup/0Notmachines_weekly_20140615_00:04:01    0/5057      271.30G       0.15G
backup/1Appliances_weekly_20140615_00:04:01     0/5058        2.09G       0.00G
backup/win_weekly_20140615_00:04:01             0/5059      461.61G       0.00G
legolas/var_ggm_daily_ro.20140615_11:17:36      0/5068      288.89G       0.00G
legolas/var_ggm_daily_rw.20140615_11:17:36      0/5069      288.89G       0.00G
legolas/var_ggm_daily_ro.20140616_11:59:11      0/5095      288.28G       0.00G
legolas/var_ggm_daily_rw.20140616_11:59:11      0/5096      288.28G       0.00G
legolas/var_ggm_daily_rw.20140617_10:26:39      0/5124      288.42G       0.00G
legolas/var_ggm_daily_ro.20140618_10:27:06      0/5151      288.97G       1.05G
legolas/var_ggm_daily_ro.20140619_10:18:57      0/5178      289.15G       1.26G
legolas/var_ggm_daily_ro.20140621_11:00:21      0/5229      288.12G       0.30G
backup_weekly_20140622_00:04:01                 0/5248       -0.00G       0.00G
Soft_weekly_20140622_00:04:01                   0/5249       59.27G       0.00G
Win_weekly_20140622_00:04:01                    0/5250      112.60G       0.00G
backup/debian32_weekly_20140622_00:04:01        0/5251       20.62G       0.18G
backup/debian64_weekly_20140622_00:04:01        0/5252      716.66G       0.00G
backup/ubuntu_weekly_20140622_00:04:01          0/5253      336.38G       0.04G
backup/0Notmachines_weekly_20140622_00:04:01    0/5254      270.47G       0.01G
backup/1Appliances_weekly_20140622_00:04:01     0/5255        2.09G       0.00G
backup/win_weekly_20140622_00:04:01             0/5256      461.61G       0.00G
legolas/var_ggm_daily_ro.20140622_10:16:05      0/5265      287.50G       0.20G
legolas/var_ggm_daily_ro.20140624_10:17:10      0/5310      299.05G       0.00G
legolas/var_ggm_daily_rw.20140624_10:17:10      0/5311      299.05G       0.00G
legolas/var_ggm_daily_ro.20140625_10:21:06      0/5343      299.50G       1.46G
legolas/var_ggm_daily_ro.20140627_12:14:51      0/5382      295.13G       3.17G
legolas/var_ggm_daily_ro.20140628_11:16:05      0/5420      299.93G       2.05G
backup_weekly_20140629_00:04:01                 0/5438       -0.00G       0.00G
Soft_weekly_20140629_00:04:01                   0/5440       59.27G       0.00G
Win_weekly_20140629_00:04:01                    0/5442      112.60G       0.00G
backup/debian32_weekly_20140629_00:04:01        0/5445      -33.15G       0.77G
backup/debian64_weekly_20140629_00:04:01        0/5446      709.35G       0.00G
backup/ubuntu_weekly_20140629_00:04:01          0/5447      333.13G       0.26G
backup/0Notmachines_weekly_20140629_00:04:01    0/5448      269.65G       0.00G
backup/1Appliances_weekly_20140629_00:04:01     0/5449        2.09G       0.00G
backup/win_weekly_20140629_00:04:01             0/5450      461.61G       0.00G
legolas/var_ggm_daily_ro.20140629_10:28:56      0/5459      300.07G       2.30G
legolas/home_ggm_daily_ro.20140630_10:02:02     0/5478       77.76G       0.00G
legolas/var_ggm_daily_ro.20140630_10:19:42      0/5486      300.08G       2.31G
legolas/home_ggm_daily_rw.20140701_10:02:05     0/5506       78.30G       0.00G
legolas/var_ggm_daily_ro.20140701_10:49:22      0/5513      299.19G       0.40G
legolas/home_ggm_daily_ro.20140702_10:02:06     0/5532       78.38G       0.00G
legolas/home_ggm_daily_rw.20140702_10:02:06     0/5533       78.38G       0.00G
legolas/root_ggm_daily_ro.20140702_10:20:09     0/5534        1.66G       0.00G
legolas/root_ggm_daily_rw.20140702_10:20:09     0/5535        1.66G       0.00G
legolas/tmp_ggm_daily_ro.20140702_10:20:50      0/5536        0.08G       0.00G
legolas/tmp_ggm_daily_rw.20140702_10:20:50      0/5537        0.08G       0.00G
legolas/usr_ggm_daily_ro.20140702_10:21:11      0/5538       10.36G       0.00G
legolas/usr_ggm_daily_rw.20140702_10:21:11      0/5539       10.36G       0.00G
legolas/var_ggm_daily_ro.20140702_10:21:31      0/5540      299.19G       0.41G
backup_hourly_20140703_00:03:01                 0/5541       -0.00G       0.00G
backup_daily_20140703_00:03:01                  0/5542       -0.00G       0.00G
Soft_hourly_20140703_00:03:01                   0/5543       59.27G       0.00G
Soft_daily_20140703_00:03:01                    0/5544       59.27G       0.00G
Win_hourly_20140703_00:03:01                    0/5545      112.60G       0.00G
Win_daily_20140703_00:03:01                     0/5546      112.60G       0.00G
backup/debian32_hourly_20140703_00:03:01        0/5547     -103.86G       0.00G
backup/debian32_daily_20140703_00:03:01         0/5548     -103.86G       0.00G
backup/debian64_daily_20140703_00:03:01         0/5549      643.32G       0.00G
backup/debian64_hourly_20140703_00:03:01        0/5550      643.32G       0.00G
backup/ubuntu_hourly_20140703_00:03:01          0/5551      328.48G       0.00G
backup/ubuntu_daily_20140703_00:03:01           0/5552      328.48G       0.00G
backup/0Notmachines_hourly_20140703_00:03:01    0/5553      268.91G       0.00G
backup/0Notmachines_daily_20140703_00:03:01     0/5554      268.91G       0.00G
backup/1Appliances_hourly_20140703_00:03:01     0/5555        2.09G       0.00G
backup/1Appliances_daily_20140703_00:03:01      0/5556        2.09G       0.00G
backup/win_hourly_20140703_00:03:01             0/5557      461.61G       0.00G
backup/win_daily_20140703_00:03:01              0/5558      461.61G       0.00G
legolas/home_ggm_daily_ro.20140703_10:02:03     0/5559       78.41G       0.00G
legolas/home_ggm_daily_rw.20140703_10:02:03     0/5560       78.41G       0.00G
legolas/root_ggm_daily_ro.20140703_10:19:21     0/5561        1.66G       0.00G
legolas/root_ggm_daily_rw.20140703_10:19:21     0/5562        1.66G       0.00G
legolas/tmp_ggm_daily_ro.20140703_10:20:12      0/5563        0.08G       0.00G
legolas/tmp_ggm_daily_rw.20140703_10:20:12      0/5564        0.08G       0.00G
legolas/usr_ggm_daily_ro.20140703_10:21:08      0/5565       10.36G       0.00G
legolas/usr_ggm_daily_rw.20140703_10:21:08      0/5566       10.36G       0.00G
legolas/var_ggm_daily_ro.20140703_10:21:56      0/5567      301.30G       4.01G
backup_hourly_20140704_00:03:01                 0/5568       -0.00G       0.00G
backup_daily_20140704_00:03:01                  0/5569       -0.00G       0.00G
Soft_daily_20140704_00:03:01                    0/5570       59.27G       0.00G
Soft_hourly_20140704_00:03:01                   0/5571       59.27G       0.00G
Win_daily_20140704_00:03:01                     0/5572      112.60G       0.00G
Win_hourly_20140704_00:03:01                    0/5573      112.60G       0.00G
backup/debian32_daily_20140704_00:03:01         0/5574     -101.81G       0.00G
backup/debian32_hourly_20140704_00:03:01        0/5575     -101.81G       0.00G
backup/debian64_hourly_20140704_00:03:01        0/5576      643.32G       0.00G
backup/debian64_daily_20140704_00:03:01         0/5577      643.32G       0.00G
backup/ubuntu_daily_20140704_00:03:01           0/5578      328.48G       0.00G
backup/ubuntu_hourly_20140704_00:03:01          0/5579      328.48G       0.00G
backup/0Notmachines_daily_20140704_00:03:01     0/5580      268.90G       0.00G
backup/0Notmachines_hourly_20140704_00:03:01    0/5581      268.90G       0.00G
backup/1Appliances_hourly_20140704_00:03:01     0/5582        2.09G       0.00G
backup/1Appliances_daily_20140704_00:03:01      0/5583        2.09G       0.00G
backup/win_hourly_20140704_00:03:01             0/5584      461.61G       0.00G
backup/win_daily_20140704_00:03:01              0/5585      461.61G       0.00G
legolas/home_ggm_daily_ro.20140704_10:02:03     0/5586       77.52G       0.00G
legolas/home_ggm_daily_rw.20140704_10:02:03     0/5587       77.52G       0.00G
legolas/root_ggm_daily_ro.20140704_10:16:59     0/5588        1.66G       0.00G
legolas/root_ggm_daily_rw.20140704_10:16:59     0/5589        1.66G       0.00G
legolas/tmp_ggm_daily_ro.20140704_10:17:07      0/5590        0.08G       0.00G
legolas/tmp_ggm_daily_rw.20140704_10:17:07      0/5591        0.08G       0.00G
legolas/usr_ggm_daily_ro.20140704_10:17:24      0/5592       10.36G       0.00G
legolas/usr_ggm_daily_rw.20140704_10:17:24      0/5593       10.36G       0.00G
legolas/var_ggm_daily_ro.20140704_10:17:39      0/5594      304.28G      19.49G
backup_hourly_20140705_00:03:00                 0/5595       -0.00G       0.00G
backup_daily_20140705_00:03:00                  0/5596       -0.00G       0.00G
Soft_daily_20140705_00:03:00                    0/5597       59.27G       0.00G
Soft_hourly_20140705_00:03:00                   0/5598       59.27G       0.00G
Win_hourly_20140705_00:03:00                    0/5599      112.60G       0.00G
Win_daily_20140705_00:03:00                     0/5600      112.60G       0.00G
backup/debian32_daily_20140705_00:03:00         0/5601     -118.33G       0.00G
backup/debian32_hourly_20140705_00:03:00        0/5602     -118.33G       0.00G
backup/debian64_daily_20140705_00:03:00         0/5603      643.76G       0.00G
backup/debian64_hourly_20140705_00:03:00        0/5604      643.76G       0.00G
backup/ubuntu_daily_20140705_00:03:00           0/5605      328.12G       0.00G
backup/ubuntu_hourly_20140705_00:03:00          0/5606      328.12G       0.00G
backup/0Notmachines_daily_20140705_00:03:00     0/5607      268.78G       0.00G
backup/0Notmachines_hourly_20140705_00:03:00    0/5608      268.78G       0.00G
backup/1Appliances_daily_20140705_00:03:00      0/5609        2.09G       0.00G
backup/1Appliances_hourly_20140705_00:03:00     0/5610        2.09G       0.00G
backup/win_daily_20140705_00:03:00              0/5611      461.61G       0.00G
backup/win_hourly_20140705_00:03:00             0/5612      461.61G       0.00G
legolas/home_ggm_daily_ro.20140705_10:02:09     0/5613       77.54G       0.10G
legolas/root_ggm_daily_ro.20140705_14:07:48     0/5614        1.66G       0.00G
legolas/root_ggm_daily_rw.20140705_14:07:48     0/5615        1.66G       0.00G
legolas/tmp_ggm_daily_ro.20140705_14:08:41      0/5616        0.08G       0.00G
legolas/tmp_ggm_daily_rw.20140705_14:08:41      0/5617        0.08G       0.00G
legolas/usr_ggm_daily_ro.20140705_14:09:13      0/5618       10.36G       0.00G
legolas/usr_ggm_daily_rw.20140705_14:09:13      0/5619       10.36G       0.00G
legolas/var_ggm_daily_ro.20140705_14:10:09      0/5620      299.50G       0.79G
backup_daily_20140706_00:03:01                  0/5621       -0.00G       0.00G
backup_hourly_20140706_00:03:01                 0/5622       -0.00G       0.00G
Soft_daily_20140706_00:03:01                    0/5623       59.27G       0.00G
Soft_hourly_20140706_00:03:01                   0/5624       59.27G       0.00G
Win_daily_20140706_00:03:01                     0/5625      112.60G       0.00G
Win_hourly_20140706_00:03:01                    0/5626      112.60G       0.00G
backup/debian32_daily_20140706_00:03:01         0/5627     -129.94G       0.00G
backup/debian32_hourly_20140706_00:03:01        0/5628     -129.94G       0.00G
backup/debian64_daily_20140706_00:03:01         0/5629      644.62G       0.00G
backup/debian64_hourly_20140706_00:03:01        0/5630      644.62G       0.00G
backup/ubuntu_hourly_20140706_00:03:01          0/5631      328.12G       0.00G
backup/ubuntu_daily_20140706_00:03:01           0/5632      328.12G       0.00G
backup/0Notmachines_daily_20140706_00:03:01     0/5633      268.65G       0.00G
backup/0Notmachines_hourly_20140706_00:03:01    0/5634      268.65G       0.00G
backup/1Appliances_daily_20140706_00:03:01      0/5635        2.09G       0.00G
backup/1Appliances_hourly_20140706_00:03:01     0/5636        2.09G       0.00G
backup/win_daily_20140706_00:03:01              0/5637      461.61G       0.00G
backup/win_hourly_20140706_00:03:01             0/5638      461.61G       0.00G
backup_weekly_20140706_00:04:01                 0/5639       -0.00G       0.00G
Soft_weekly_20140706_00:04:01                   0/5640       59.27G       0.00G
Win_weekly_20140706_00:04:01                    0/5641      112.60G       0.00G
backup/debian32_weekly_20140706_00:04:01        0/5642     -129.94G       0.00G
backup/debian64_weekly_20140706_00:04:01        0/5643      644.62G       0.00G
backup/ubuntu_weekly_20140706_00:04:01          0/5644      328.12G       0.00G
backup/0Notmachines_weekly_20140706_00:04:01    0/5645      268.65G       0.00G
backup/1Appliances_weekly_20140706_00:04:01     0/5646        2.09G       0.00G
backup/win_weekly_20140706_00:04:01             0/5647      461.61G       0.00G
legolas/home_ggm_daily_ro.20140706_10:02:01     0/5648       77.53G       0.00G
legolas/home_ggm_daily_rw.20140706_10:02:01     0/5649       77.53G       0.00G
legolas/root_ggm_daily_ro.20140706_11:08:26     0/5650        1.67G       0.00G
legolas/root_ggm_daily_rw.20140706_11:08:26     0/5651        1.67G       0.00G
legolas/tmp_ggm_daily_ro.20140706_11:09:31      0/5652        0.08G       0.00G
legolas/tmp_ggm_daily_rw.20140706_11:09:31      0/5653        0.08G       0.00G
legolas/usr_ggm_daily_ro.20140706_11:10:34      0/5654       10.36G       0.00G
legolas/usr_ggm_daily_rw.20140706_11:10:34      0/5655       10.36G       0.00G
legolas/var_ggm_daily_ro.20140706_11:11:30      0/5656      301.21G       4.53G
gargamel:/mnt/btrfs_pool2# btrfs quota disable .


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
