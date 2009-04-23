From: Dmitri Nikulin <dnikulin@gmail.com>
Subject: Re: LVM vs btrfs as a "volume manager" for SANs
Date: Thu, 23 Apr 2009 10:13:31 +1000
Message-ID: <3a7f57190904221713p1c923e18ga9f3183741cb00ef@mail.gmail.com>
References: <49EF6DF7.9020406@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49EF6DF7.9020406@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 23, 2009 at 5:20 AM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> - what happens if SAN machine crashes while the iSCSI file images were being
> written to; with LVM and its block devices, I'm somehow more confident it
> wouldn't make more data loss than necessary

I would hope that COW applies to such a setting. It certainly does for
ZFS, making it an excellent backend for iSCSI. At least, having it on
btrfs shouldn't make it any less reliable than on LVM, as long as
btrfs does its job correctly.

-- 
Dmitri Nikulin

Centre for Synchrotron Science
Monash University
Victoria 3800, Australia
