Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:36005 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaDVSQQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Apr 2014 14:16:16 -0400
Received: by mail-ee0-f53.google.com with SMTP id b57so4890433eek.40
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Apr 2014 11:16:15 -0700 (PDT)
Received: from [192.168.1.188] (188-194-185-233-dynip.superkabel.de. [188.194.185.233])
        by mx.google.com with ESMTPSA id q41sm115132833eez.7.2014.04.22.11.16.14
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Apr 2014 11:16:14 -0700 (PDT)
Message-ID: <5356B1ED.8060608@gmail.com>
Date: Tue, 22 Apr 2014 20:16:13 +0200
From: Andreas Reis <andreas.reis@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Bug: "corrupt leaf. slot offset bad": root subvolume unmountable,
 "btrfs check" crashes
References: <53554469.5070503@gmail.com> <53556DCC.3000108@gmail.com>
In-Reply-To: <53556DCC.3000108@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Same failure with btrfs-progs from integration-20140421 (apart from the 
line number 1156).

Can I get a bit of input on this? Is it safe to just ignore the error 
for now (as I'm doing atm), ie. remount as rw to skip the orphan cleanup?

Might it even be safe to call btrfs check --repair on the partition? I'm 
not keen on that failing mid-process at the same assertion and thus 
breaking it over a bunch of minor files, just like it happened with my 
previous btrfs partitions.

On 21.04.2014 21:13, Andreas Reis wrote:
> Alright, turns out the partition does actually mount on 3.15-rc2 (error
> messages remain, of course).
>
> But systemd will fail to continue booting as /bin/mount returns "exit
> status 32" and / thus ends as ro, yet can be manually remounted as rw.
>
> Another error message I've spotted with 3.15 is
>
> BTRFS error (device sdc5): error loading props for ino 1810424 (root
> 257): -5
>
> I've now tried to mount with -o recovery and clear_cache, no effect.
