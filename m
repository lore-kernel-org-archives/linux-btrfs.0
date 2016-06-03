Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:33391 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675AbcFCUaN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jun 2016 16:30:13 -0400
Received: by mail-io0-f169.google.com with SMTP id t40so88367286ioi.0
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jun 2016 13:30:12 -0700 (PDT)
Received: from [169.254.77.254] ([70.51.159.130])
        by smtp.gmail.com with ESMTPSA id v40sm3475380ioi.3.2016.06.03.13.30.11
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Fri, 03 Jun 2016 13:30:11 -0700 (PDT)
Message-ID: <5751E8D2.7070001@gmail.com>
Date: Fri, 03 Jun 2016 16:30:10 -0400
From: "B. S." <bs27975@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Pointers to mirroring partitions (w/ encryption?) help?
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo. I'm continuing on sinking in to btrfs, so pointers to concise 
help articles appreciated. I've got a couple new home systems, so 
perhaps it's time to investigate encryption, and given the bit rot I've 
seen here, perhaps time to mirror volumes so the wonderful btrfs 
self-healing facilities can be taken advantage of.

Problem with today's hard drives, a quick look at Canada Computer shows 
the smallest drives 500GB, 120GB SSDs, far more than the 20GB or so an 
OS needs. Yet not looking to put in a 2nd HD, either. It feels like 
mirroring volumes makes sense.

(EFI [partitions] also seem to be sticking their fingers in here.]

Assume a CD sized (680MB) /boot, and perhaps a 200MB (?) sized EFI 
partition, it seems to me one sets up / as usual (less complex install), 
then creates another partition for mirroring, later. IIUC, btrfs add 
device /dev/sda4 / is appropriate, then. Then running a balance seems 
recommended.

Confusing, however, is having those (both) partitions encrypted. Seems 
some work is needed beforehand. But I've never done encryption. I have 
come across https://github.com/gebi/keyctl_keyscript, so I understand 
there will be gotchas to deal with - later. But not there yet, and not 
real sure how to start.

The additional problem is most articles reference FDE (Full Disk 
Encryption) - but that doesn't seem to be prudent. e.g. Unencrypted 
/boot. So having problems finding concise links on the topics, -FDE 
-"Full Disk Encryption".

Any good links to concise instructions on building / establishing 
encrypted btrfs mirror volumes? dm_crypt seems to be the basis, and not 
looking to add LVM, seems an unnecessary extra layer of complexity.

It also feels like I could mkfs.btrfs /dev/sda3 /dev/sda4, then mirror 
subvolumes (or it inherently comes along for the ride?) - so my 
confusion level increases. Especially if encryption is added to the mix.

So, I could take an HD, create partitions as above (how? e.g. Set up 
encryption / btrfs mirror volumes), then clonezilla (?) partitions from 
a current machine in. I assume mounting a live cd then cp -a from old 
disk partition to new disk partition won't 'just work'. (?)

Article suggestions?
