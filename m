Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36.italiaonline.it ([212.48.25.164]:44682 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751234AbcGGRHx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jul 2016 13:07:53 -0400
Reply-To: kreijack@inwind.it
Subject: Re: 64-btrfs.rules and degraded boot
References: <CAJCQCtRQBGNeCyENzTPT=yiqs3Tcc=aD8v6usKNtTnvyOd0uqw@mail.gmail.com>
 <20160705212706.719397fc@jupiter.sol.kaishome.de>
 <CAJCQCtRyvC6J=KJSVYRd1sOWPoVm69tA--3U8kAVdDynkziwNA@mail.gmail.com>
 <CAJCQCtS7OgKKzstJDz52Sd6+SJygDzoVzMhvwHqGxFmihr6Aqg@mail.gmail.com>
 <CAA91j0VbaRpt46tYf_oqd7fRuRn_ev-=Zxf_Bwiwd=TUHR+2Ow@mail.gmail.com>
 <CAJCQCtSZ=7v5PgD4mYKhayg03UfVqCV0ADBSjTsFDHiVcdxAjw@mail.gmail.com>
 <CAA91j0VEBRDUW+MehjtUqhZHi2dehnbY9w-_quEihRc1D=cpvQ@mail.gmail.com>
 <CAJCQCtTVKA0DEqDhDDduTMMONo7XUrGD-VaDt2Zfsg_mqP762Q@mail.gmail.com>
To: Chris Murphy <lists@colorremedies.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Kai Krakow <hurikhan77@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <99221c4e-0ab4-43c7-8b47-b4fd7ff0c35d@inwind.it>
Date: Thu, 7 Jul 2016 19:07:50 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTVKA0DEqDhDDduTMMONo7XUrGD-VaDt2Zfsg_mqP762Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-06 20:57, Chris Murphy wrote:
[...]
> 
> Seems like we need more granularity by btrfs ioctl for device ready,
> e.g. some way to indicate:
> 
> 0 all devices ready
> 1 devices not ready (don't even try to mount)
> 2 minimum devices ready (degraded mount possible)
> 
> 
> Btrfs multiple device single and raid0 only return code 0 or 1. Where
> raid 1, 5, 6 could return code 2. The systemd default policy for code
> 2 could be to wait some amount of time to see if state goes to 0. At
> the timeout, try to mount anyway. If rootflags=degraded, it mounts. If
> not, mount fails, and we get a dracut prompt.
> 

Pay attention that to return 2, you have to scan all the VGs to check if all the involved devices are available: i.e. a filesystem composed by 5 disks, may have a VG RAID5 with only 3 disks used for data, and a VG RAID1 for metadata for the other two disks....

Think to try to perform this for each disk appearing.... I fear that it is too expensive


> That's better behavior than now.
> 
>> Equivalent of this rule is required under systemd and desired in
>> general to avoid polling. On systemd list I outlined possible
>> alternative implementation as systemd service instead of really
>> hackish udev rule.
> 
> I'll go read it there. Thanks.
> 
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
