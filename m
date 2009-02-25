From: Wil Reichert <wil.reichert@gmail.com>
Subject: lots of kernel threads
Date: Tue, 24 Feb 2009 20:09:37 -0800
Message-ID: <7a329d910902242009k6ae3fff7t8711ebc1a8bafea8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I'm a Gentoo user and figured mounting /usr/portage & /var/portage
(distfiles, packages, persistent stuff normally in /usr/portage) and
/tmp moiunted as btrfs.  I figured it would be a decent test & its
nothing I cann't replace readily.  After about 6 hours of uptime and a
couple package merges, I checked ps aux & am getting the following:

$ ps aux | grep btrfs
root      3634  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-worker-0]
root      3635  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-submit-0]
root      3636  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-delalloc-]
root      3637  0.0  0.0      0     0 ?        S<   13:47   0:00 [btrfs-fixup-0]
root      3638  0.0  0.0      0     0 ?        S<   13:47   0:00 [btrfs-endio-0]
root      3639  0.0  0.0      0     0 ?        S<   13:47   0:00 [btrfs-endio-2]
root      3640  0.0  0.0      0     0 ?        S<   13:47   0:00 [btrfs-endio-4]
root      3641  0.0  0.0      0     0 ?        S<   13:47   0:00 [btrfs-endio-6]
root      3642  0.0  0.0      0     0 ?        S<   13:47   0:00 [btrfs-endio-8]
root      3643  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-10]
root      3644  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3645  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3646  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3647  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3648  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3649  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3650  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3651  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3652  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3653  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3654  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3655  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3656  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-wri]
root      3657  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-wri]
root      3658  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-wri]
root      3659  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-wri]
root      3660  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-wri]
root      3661  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-wri]
root      3662  0.0  0.0      0     0 ?        S<   13:47   0:00 [btrfs-cleaner]
root      3663  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-transacti]
root      3666  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-worker-0]
root      3667  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-submit-0]
root      3668  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-delalloc-]
root      3669  0.0  0.0      0     0 ?        S<   13:47   0:00 [btrfs-fixup-0]
root      3670  0.0  0.0      0     0 ?        S<   13:47   0:00 [btrfs-endio-0]
root      3671  0.0  0.0      0     0 ?        S<   13:47   0:00 [btrfs-endio-2]
root      3672  0.0  0.0      0     0 ?        S<   13:47   0:00 [btrfs-endio-4]
root      3673  0.0  0.0      0     0 ?        S<   13:47   0:00 [btrfs-endio-6]
root      3674  0.0  0.0      0     0 ?        S<   13:47   0:00 [btrfs-endio-8]
root      3675  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-10]
root      3676  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3677  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3678  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3679  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3680  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3681  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3682  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3683  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3684  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3685  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3686  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3687  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3688  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-wri]
root      3689  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-wri]
root      3690  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-wri]
root      3691  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-wri]
root      3692  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-wri]
root      3693  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-wri]
root      3694  0.0  0.0      0     0 ?        S<   13:47   0:01 [btrfs-cleaner]
root      3695  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-transacti]
root      3698  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-worker-0]
root      3699  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-submit-0]
root      3700  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-delalloc-]
root      3701  0.0  0.0      0     0 ?        S<   13:47   0:00 [btrfs-fixup-0]
root      3702  0.0  0.0      0     0 ?        S<   13:47   0:00 [btrfs-endio-0]
root      3703  0.0  0.0      0     0 ?        S<   13:47   0:00 [btrfs-endio-2]
root      3704  0.0  0.0      0     0 ?        S<   13:47   0:00 [btrfs-endio-4]
root      3705  0.0  0.0      0     0 ?        S<   13:47   0:00 [btrfs-endio-6]
root      3706  0.0  0.0      0     0 ?        S<   13:47   0:00 [btrfs-endio-8]
root      3707  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-10]
root      3708  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3709  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3710  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3711  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3712  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3713  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3714  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3715  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3716  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3717  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3718  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3719  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-met]
root      3720  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-wri]
root      3721  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-wri]
root      3722  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-wri]
root      3723  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-wri]
root      3724  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-wri]
root      3725  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-endio-wri]
root      3726  0.0  0.0      0     0 ?        S<   13:47   0:00 [btrfs-cleaner]
root      3727  0.0  0.0      0     0 ?        S<   13:47   0:00
[btrfs-transacti]
root      5394  0.0  0.0      0     0 ?        S<   13:51   0:00
[btrfs-worker-1]
root      5395  0.0  0.0      0     0 ?        S<   13:51   0:00
[btrfs-worker-2]
root      5420  0.0  0.0      0     0 ?        S<   13:51   0:00
[btrfs-worker-3]
root      7324  0.0  0.0      0     0 ?        S<   14:06   0:00
[btrfs-worker-4]
root      7325  0.0  0.0      0     0 ?        S<   14:06   0:00
[btrfs-worker-1]
root      7326  0.0  0.0      0     0 ?        S<   14:06   0:00
[btrfs-worker-2]
root     13218  0.0  0.0      0     0 ?        S<   19:58   0:00
[btrfs-worker-5]

Oh yeah, the kernel is mondays's 29-rc6.  So is this irregular?

Wil
