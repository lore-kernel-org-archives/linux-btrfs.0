Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from x1-6-a4-2b-8c-8c-bd-da.cpe.webspeed.dk ([2.104.2.239]:56250
	"EHLO mail.musikcheck.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932756AbcECSiU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 May 2016 14:38:20 -0400
Subject: Re: Subvolumes cannot be mounted after raid1 conversion
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <983F0471-51E8-47EC-B5A0-FBA9040F634B@hagenjohansen.dk>
 <20160503095515.GM7228@carfax.org.uk>
 <B66776EA-68EA-490F-862E-C49A1D51FCE5@hagenjohansen.dk>
 <20160503102746.GN7228@carfax.org.uk>
 <pan$53532$8cf28e4d$10d40c2$bb30f4bb@cox.net>
 <2a657997-6da8-a190-6057-7b5dcb5d70b1@hagenjohansen.dk>
From: hasse@hagenjohansen.dk
Message-ID: <e0f52464-e153-9961-57df-b45c3513ccf8@hagenjohansen.dk>
Date: Tue, 3 May 2016 20:38:14 +0200
MIME-Version: 1.0
In-Reply-To: <2a657997-6da8-a190-6057-7b5dcb5d70b1@hagenjohansen.dk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Den 03/05/16 kl. 20:31 skrev hasse@hagenjohansen.dk:
> Den 03/05/16 kl. 18:30 skrev Duncan:
>> Hugo Mills posted on Tue, 03 May 2016 10:27:46 +0000 as excerpted:
>>
>>> Given those symptoms (mount doesn't report errors, but no mount
>>> happens), I would guess that your problem is with systemd. It has a bug
>>> where it sometimes unmounts things immediately after you've mounted
>>> them.
>>
>> FWIW, I have some personal experience with that "bug" myself.  But I 
>> suspect the systemd devs might call it a "feature", not a bug.  Based on 
>> my own experience and understanding...
.
.
.

> Thanks for the very extensive explanation. I did find out systemd did
> the umount by looking in /var/log/syslog. Now I wil try to fixup systemd
> unit files and I will try not boot in either rescue or emergency mode. I
> believe it is fixable without it. It seems systemd thinks it is my old
> LVM setup(which now are moved to btrfs) which should be used and
> immediately unmounts the filesystem again because it cannot find the
> "LVM device". But I must say I find it a little bit stupid that systemd
> doesn't monitor /etc/fstab now that it behind the users back are
> generating its own unit files (I have actually seen the mount.xxx units
> etc when looking at running units...but have never looked into how it
> works...so I would now have to study that)
>
I have found the easy solution. From
https://bbs.archlinux.org/viewtopic.php?id=192991

    First:

    # systemctl daemon-reload

    followed by:

    # systemctl restart remote-fs.target

    or

    # systemctl restart local-fs.target

    depending on filesystem type

I still think it is pretty stupid that systemd doesn't monitor
/etc/fstab (when choosing to create it own secret files) :)
