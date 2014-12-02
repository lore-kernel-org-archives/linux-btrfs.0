Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:46554 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbaLBPL4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 10:11:56 -0500
Received: by mail-qg0-f51.google.com with SMTP id l89so9163960qgf.24
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 07:11:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141202132842.GT12140@twin.jikos.cz>
References: <CAH-HCWVcu9FW0c3zwEg_KR_yaPGRQ58yHbXsUx1JCKRu4s7NXQ@mail.gmail.com>
 <CAJCQCtT3EeGUOpZ9q78BcWv_Cc_5UGY=uPVJX+bqex9Zo_bWYg@mail.gmail.com>
 <CAH-HCWUSX+N2Byo4vpCxac89TSX2YGoP39VgFsq6952k9V9cmQ@mail.gmail.com> <20141202132842.GT12140@twin.jikos.cz>
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Tue, 2 Dec 2014 20:41:35 +0530
Message-ID: <CAH-HCWVubkp+viAEVqGoJFxJ_t1chTVC08xm6A15ucosqbWqxQ@mail.gmail.com>
Subject: Re: Moving an entire subvol?
To: dsterba@suse.cz, Shriramana Sharma <samjnaa@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 2, 2014 at 6:58 PM, David Sterba <dsterba@suse.cz> wrote:
>
> A subvolume is also a snapshotting barrier, so it's convenient to create
> subvolumes in well-known paths that contain data that should not be
> rolled back (/var/log, /srv, bootloader).

Hi David -- a real honour to meet one of the core Btrfs/SuSE (heh,
when that was the spelling!) guys!

That makes sense. Is there anywhere that the "official" SuSE
recommended subvol layout is mentioned that I can refer to without
having to start up an installer? (I currently chose ext4 for / for
other reasons so I can't refer to my layout.)

I am now reading a SuSECon 2013 presentation by Nyers and Schnell but
they are very generic about the recommendations.

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
