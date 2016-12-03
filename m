Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:47289 "EHLO
        hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750766AbcLCOgP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Dec 2016 09:36:15 -0500
Received: from homiemail-a13.g.dreamhost.com (sub3.mail.dreamhost.com [69.163.253.7])
        by hapkido.dreamhost.com (Postfix) with ESMTP id 221BCDF424
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Dec 2016 18:35:18 -0800 (PST)
Received: from homiemail-a13.g.dreamhost.com (localhost [127.0.0.1])
        by homiemail-a13.g.dreamhost.com (Postfix) with ESMTP id 579A6334075
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Dec 2016 18:35:17 -0800 (PST)
Received: from [192.168.0.96] (89-70-178-52.dynamic.chello.pl [89.70.178.52])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: liori@exroot.org)
        by homiemail-a13.g.dreamhost.com (Postfix) with ESMTPSA id E48FF33406C
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Dec 2016 18:35:16 -0800 (PST)
To: linux-btrfs@vger.kernel.org
From: Tomasz Melcer <liori@exroot.org>
Subject: `btrfs check --repair` stuck in a loop // filesystem repair case
 study
Message-ID: <ffe12396-dea8-80aa-7268-9cf3325ffc56@exroot.org>
Date: Sat, 3 Dec 2016 03:35:14 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a btrfs filesystem on a 4TB HDD connected with USB 2.0. Some time 
ago I accidentally disconnected the drive while doing heavy writes. 
After reconnecting it seemed like the filesystem still works (it mounted 
fine and I could read some files chosen at random), but I ran `btrfs 
scrub` to be sure.

`btrfs scrub` aborted itself after ~20 hours, after reading ~3.5TB of 
data. `dmesg` contained a single line:

#v+
BTRFS error (device dm-0): bad tree block start 0 3527021166592
#v-

I couldn't find any further details anywhere in logs. I assume this 
means that some data have actually been lost from this filesystem. I 
have backups of data from this drive, so I decided to play a little 
trying out btrfs recovery strategies.

I checked whether there are any bad blocks on the raw device — all 
blocks were read successfully.

I created a devicemapper snapshot/overlay to keep the raw device data 
read only and track the changes made by any recovery procedures.

I ran `btrfstune -u` on the overlay to avoid having two devices with the 
same uuid. This was done using a dedicated VM which did not see the raw 
device (suggested by `Ke` on IRC). BTW, this command resulted in the 
overlay device growing by ~25GB, which IIUC means that around 6M 
4096-byte blocks were changed in the process (is that expected?).

I was recommended to run `btrfs check`. The result is here: [1] (323 
lines of output), and IIRC it finished in few hours.

  [1] https://gist.github.com/liori/f8c5e69677e8c9d6038d2e3e4db9aa42

(5 data checksum errors are a preexisting condition, I knew about them 
before the incident).

I then started `btrfs check --repair`. This was about a week ago, and it 
is still going. The partial output is here: [2] (already almost 18k 
lines). The same problems are being found again and again in a loop, as 
if it was stuck.

  [2] https://gist.github.com/liori/01494afbe63cd19ba49be663be937d84

I do observe that the ctime of the overlay file is updated every once a 
while, but the file itself does not grow anymore after some initial 
change of ~70k blocks. My interpretation is that even if the repair 
process writes anything, it only keeps writing in the same places again 
and again.

I did not have any snapshots on this filesystem. I did have some 
deduplicated content, but no more than 4 copies of any data block, and 
deduplication resulted in saving ~1TB of space total. The device was 
never a part of a multi-device setup.

Is there anything more I can do with this filesystem to bring it to a 
state where I can `btrfs scrub` it, know what have been lost, etc? Is 
this behavior of `btrfs scrub --repair` expected and will it ever finish?

Thank you,


-- 
Tomasz Melcer
