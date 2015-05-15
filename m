Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33551 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbbEOSkI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 May 2015 14:40:08 -0400
Received: by wicmx19 with SMTP id mx19so45042054wic.0
        for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2015 11:40:07 -0700 (PDT)
Received: from [10.0.2.15] (p3E9EE5B9.dip0.t-ipconnect.de. [62.158.229.185])
        by mx.google.com with ESMTPSA id n1sm4178362wix.0.2015.05.15.11.40.06
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 May 2015 11:40:06 -0700 (PDT)
From: Philip Seeger <p0h0i0l0i0p@gmail.com>
Message-ID: <55563D86.60901@googlemail.com>
Date: Fri, 15 May 2015 20:40:06 +0200
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Got 10 csum errors according to dmesg but 0 errors according
 to dev stats
References: <554F6D43.2060806@googlemail.com>	<CABR0jERqzkdTJxX_1S5WEZHDzX8=O8P7r+Bk0mesPLsR2n=w8A@mail.gmail.com>	<554F963D.2040209@googlemail.com>	<201505111141.54771.russell@coker.com.au>	<555145EA.6040009@googlemail.com>	<B7F2379062E32745A8651FBDB20F645954A2D259@Server.waterlogic.com.au> <CAJCQCtT-ZdFqwjCjS5sH1zG=xT3Ok4V1VYBf4NeQ3QPxsZgtRA@mail.gmail.com>
In-Reply-To: <CAJCQCtT-ZdFqwjCjS5sH1zG=xT3Ok4V1VYBf4NeQ3QPxsZgtRA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The host filesystem (where the virtual hdd is stored) is ZFS (no 
errors). It's a bit slower recently because I am moving a lot of data 
around while other vms are running. But that shouldn't be a problem.

This Arch vm appears to be the only one having problems. Again, I have 
even scrubbed one other vm, which also uses btrfs (but 3.19, not 4.0) 
and found no errors. This is the vm from which I have copied the 11 GB 
directory, which now keeps getting corrupted in the Arch vm.

I'd just like to repeat that I have copied one directory from an older 
vm, which uses btrfs, to a new Arch vm, which also used btrfs, and while 
that older vm has worked fine (still does), the same files in that 
copied directory are getting corrupted in the new Arch vm...

The bug report mentions Gnome Boxes, but I'm using VirtualBox. Don't 
know if both are affected in the same way.
If it makes a difference: The Arch vm has an IDE controller (host cache 
enabled) for the virtual optical drive and one SATA controller (host 
cache disabled) for the virtual hard drive.

I will try to get this vm in a healthy state again by deleting all 
affected files and copying them back again.

Also, should I try to use a specific mount option, maybe a lower commit 
interval?


Philip

On 05/12/2015 03:37 AM, Chris Murphy wrote:
> There are two file systems involved, guest and host. What are their
> file systems? I know one of them is Btrfs but I can't tell if they're
> both Btrfs.
>
> There is a regression somewhere, I don't know where yet, when libvirt
> cache=none or cache=directsync, and the disk image (qcow2 in my case)
> is on Btrfs. The guest file system doesn't matter, it'll eventually
> spew some corruption related errors.
> https://bugzilla.redhat.com/show_bug.cgi?id=1204569
>
>
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

