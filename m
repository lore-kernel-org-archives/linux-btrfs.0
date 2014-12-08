Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f172.google.com ([209.85.216.172]:50533 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487AbaLHOQq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Dec 2014 09:16:46 -0500
Received: by mail-qc0-f172.google.com with SMTP id m20so3591630qcx.3
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Dec 2014 06:16:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5485A145.9010004@gmail.com>
References: <547C6922.6030206@gmail.com> <CAH-HCWW4vUXzM6S1fCzwxdPiWHBZaf5ZNZexjRmND2WkzNK-qg@mail.gmail.com>
 <20141201184621.5dd7fcd9@natsu> <CAH-HCWV7mAz0cqO9r910aNa+wzufauvc_nOOpoB9ogDPdf7RsA@mail.gmail.com>
 <20141202031403.GZ17395@hungrycats.org> <CAH-HCWWnxqExQOexPF3jY6F1=jJA35Se5RkVw87u52F6BSic2g@mail.gmail.com>
 <20141202125610.GS12140@twin.jikos.cz> <CAH-HCWUm1CiapmHjy66DRKHa6NRegEW03es1DkK1SWv0159ZMw@mail.gmail.com>
 <20141203185311.GX12140@twin.jikos.cz> <CAH-HCWUj-3PAPDPnQcSvBm7DidzfFfiOB+v-LTOi08uTMZQaWw@mail.gmail.com>
 <20141205174601.GM9754@twin.jikos.cz> <CAH-HCWVAuiAsL_XNBH_GM1zB38KqOZfjMP3ORz3=XOjADu1t1w@mail.gmail.com>
 <CAH-HCWVKKHs3EpxucCbF-quii3hciBfrfTyVaEJOYn5o5MLAeg@mail.gmail.com> <5485A145.9010004@gmail.com>
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Mon, 8 Dec 2014 19:46:24 +0530
Message-ID: <CAH-HCWU2twhtVOOguxVpe7mGhJ5hod3dLDSFCEJArGjz=1mdyA@mail.gmail.com>
Subject: Re: Possible to undo subvol delete?
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: dsterba <dsterba@suse.cz>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 8, 2014 at 6:31 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> Personally, I prefer a somewhat hybrid approach where everyone has *sbin in
> their path, but file permissions are used to control what non-administrators
> can run.

This is exactly the same approach as Ubuntu, since non-superuser can't
really do anything active (whether creating or deleting) with */sbin
commands, but only querying (like ifconfig, btrfs subvol list etc). So
this is not really hybrid of anything it seems.

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
