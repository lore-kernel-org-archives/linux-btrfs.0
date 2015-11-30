Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8767 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753070AbbK3CQs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Nov 2015 21:16:48 -0500
Subject: Re: BTRFS: could not find root 8
To: <kreijack@inwind.it>, Chris Murphy <lists@colorremedies.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        Imran Geriskovan <imran.geriskovan@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAK5rZE7_f6cypBPTR8UX-7t=OnRE595XBw__kN6Gy2cNowGFgA@mail.gmail.com>
 <20151127204305.GE24333@carfax.org.uk>
 <CAJCQCtQgjbR77eei2-srOofBLpWp-avj_2OMCRa_4Ffby8eL5g@mail.gmail.com>
 <565B06AF.9020806@inwind.it>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <565BB17E.7010708@cn.fujitsu.com>
Date: Mon, 30 Nov 2015 10:16:30 +0800
MIME-Version: 1.0
In-Reply-To: <565B06AF.9020806@inwind.it>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Goffredo Baroncelli wrote on 2015/11/29 15:07 +0100:
> On 2015-11-27 23:51, Chris Murphy wrote:
>> But from github I'm not finding any indication that systemd enables
>> quota. This issue suggests that quota disabled is tolerated.
>> https://github.com/systemd/systemd/issues/1809
>
> Looking at the systemd source, it seems that it could enable quota when playing with the "machine":
>
>
> See src/shared/machine-pool.c:
>
> int setup_machine_directory(uint64_t size, sd_bus_error *error) {
>          _cleanup_release_lock_file_ LockFile lock_file = LOCK_FILE_INIT;
>          struct loop_info64 info = {
>                  .lo_flags = LO_FLAGS_AUTOCLEAR,
> [...]
>          r = check_btrfs();
>          if (r < 0)
>                  return sd_bus_error_set_errnof(error, r, "Failed to determine whether /var/lib/machines is located on btrfs: %m");
>          if (r > 0) {
>                  (void) btrfs_subvol_make_label("/var/lib/machines");
>
>                  r = btrfs_quota_enable("/var/lib/machines", true);
> [...]
>
> But I was unable to understand if:
> - enabling quota is a "per filesystem" attribute or per "subvolume attribute"

Not a systemd dev, so I can only answer this one.

Btrfs quota is a "per filesystem" attribute.
Yeah, it's filesystem level.



And the root reason for the "could not find root" error message is,
btrfs doesn't have a good enough ioctl API for btrfs qgroup.

Currently, btrfs already has several IOCTLs, but only covers the 
following operations:
1) Enable/disable quota -> IOC_QUOTA_CTL
2) Rescan and rescan status -> IOC_QUOTA_RESCAN* (3 ioctls)
3) Qgroup create/remove/assign -> IOC_QGROUP_* (3 ioctls)

It does *NOT* include the most used operation, show qgroup accounting.

And "btrfs qgroup show" commands uses the generic tree search facility 
to manually get needed qgroup info.

Unfortunately, generic tree search will output such error if one is 
searching for a non-exist tree.


So the result is, either we find a good idea to create a dedicated 
qgroup ioctl(either new ioctl number or integrate it into existing one), 
or just ignore the error message.

Thanks,
Qu


> - when systemd invokes setup_machine_directory()
>
> Does someone have more information ?
>
> BR
>
>


