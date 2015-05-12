Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:34047 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbbELAOn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 20:14:43 -0400
Received: by wgic8 with SMTP id c8so119507793wgi.1
        for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2015 17:14:42 -0700 (PDT)
Received: from [10.0.2.15] (p3E9EE011.dip0.t-ipconnect.de. [62.158.224.17])
        by mx.google.com with ESMTPSA id gy8sm199413wib.13.2015.05.11.17.14.41
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 May 2015 17:14:41 -0700 (PDT)
From: Philip Seeger <p0h0i0l0i0p@gmail.com>
Message-ID: <555145EA.6040009@googlemail.com>
Date: Tue, 12 May 2015 02:14:34 +0200
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Got 10 csum errors according to dmesg but 0 errors according
 to dev stats
References: <554F6D43.2060806@googlemail.com> <CABR0jERqzkdTJxX_1S5WEZHDzX8=O8P7r+Bk0mesPLsR2n=w8A@mail.gmail.com> <554F963D.2040209@googlemail.com> <201505111141.54771.russell@coker.com.au>
In-Reply-To: <201505111141.54771.russell@coker.com.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Sounds like you are having errors in your RAM, CPU, motherboard, or hard drive
> cabling.  Turn the machine off ASAP and plug the disks into a different system,
> if you keep it running you will make it worse.
>
I know it sounds like it, but the host is fine. The host filesystem (on 
which the vm virtual hdd resides) is healthy. Other vms are running on 
the same host, no problems there. Just to be sure, I will run memtest, 
but I'm pretty sure that's not it. The system is under high load a lot, 
but I don't think btrfs would fail because of a slow system.

So I have deleted all those corrupted files in this Arch vm, ran a 
scrub, 0 errors, all fixed. I restored them, fixed some other things and 
now - I get checksum errors again. Interestingly, it looks like the 
corruption is not happening randomly, because the same sqlite files are 
affected under ~/.mozilla/ and exactly one library file (ghostscript).
Meanwhile, other vms (not Arch but Fedora and Debian) are running 
without a problem (one of them using btrfs as well).

Is it possible that systemd isn't unmounting the filesystem properly, so 
it gets corrupted on shutdown? (Juest a wild guess.) Although I'm not 
sure if all this happened between reboots.


Philip
