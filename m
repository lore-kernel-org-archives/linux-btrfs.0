Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:38081 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752884AbcIEV3M (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Sep 2016 17:29:12 -0400
Received: by mail-wm0-f49.google.com with SMTP id 1so157993870wmz.1
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Sep 2016 14:29:11 -0700 (PDT)
Subject: Re: btrfs send extremely slow (almost stuck)
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <03b9d0b0-7001-7dd9-75cd-69d58b94d553@googlemail.com>
 <6bebd709-8fdd-5e88-650d-f1c551946505@cn.fujitsu.com>
 <2926d118-6a2f-2066-529d-1dd8335200dc@googlemail.com>
 <a7ead62b-38f5-2ed6-c24b-1960a8fc6ba8@cn.fujitsu.com>
 <5e6e606d-e75c-b7f1-0a9f-4e36090659eb@googlemail.com>
 <2ae7659b-ebb2-200b-174e-9ca186cb22cd@cn.fujitsu.com>
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
Message-ID: <22d296fa-7673-780a-0171-d87f2d7bbce6@googlemail.com>
Date: Mon, 5 Sep 2016 23:29:08 +0200
MIME-Version: 1.0
In-Reply-To: <2ae7659b-ebb2-200b-174e-9ca186cb22cd@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 05.09.2016 um 07:21 schrieb Qu Wenruo:
> Did you get the half way send stream?

Luckily, yes! 
 
> If the send stream has something, please use "--no-data" option to send the subvolume again to get the metadata only dump, and upload it for debug.

Also the metadata-only dump fails with the same ioctl error (-2: No such file or directory). 
So I could only upload the stream up the occurence of that failure... 

> 
> Also, please paste "btrfs-debug-tree -t <your subvolume id>" output for debug.
> WARN: above "btrfs-debug-tree" command will contain file names.
> You could use the following sed to wipe filename:
> 
> "btrfs-debug-tree  -t 5 /dev/sda6  | sed "s/name:.*//"

This indeed runs through without failure. 


It seems though that "btrfs send --no-data" which contains full metadata anyways contains all filenames (just from a quick look with 'strings'). 
I can probably not remove these without invalidating the stream, though... So I'd not like to upload this to some public location. 

However, you gave me an idea. I had a look at the output of running the file created by "btrfs send --no-data" piping that through "strings". 
This revealed the last files which btrfs send was able to treat before running into the ioctl failure. 
Indeed, this is my thunderbird profile directory, always a place with a lot of activity. 

Now the interesting part begins: Since of course I have a backup of this directory, I decided to move that profile to another FS and back. 
Turns out I can not run
rm -rf ~/.thunderbird
since it claims "directory not empty". Kernel log does no bug-on or OOPS or anything like that. 

That's reproducible not only in the snapshots, but also in my "home" subvolume for this folder. 

"stat -c %s" of the supposed-to-be-empty profile directory reveals indeed:
2482

So I guess I should refresh my backups soon and either run "btrfs check --repair" or, if that fails, redo the FS... 
Likely btrfs check --repair will fail for me since (due to duperemove usage) I'll for sure also be hit by https://bugzilla.kernel.org/show_bug.cgi?id=155791 
since I'm still using 4.7.1 so I'd like to update to 4.7.2 before trying out that repair strategy. 

I sadly can't do that in the next few days since I actively need the machine in question, so I'll rename that folder and restore just that from backup for now. 

Is the debug-information still of interest? If so, I can share it (but would not post it publicly to the list since many filenames are in there...). 
It weighs in at about 2 x 80 MiB after xz compression. 

Or is there anything else I can try safely? 

Thanks a lot in any case and cheers, 
Oliver

> 
> Thanks,
> Qu
> 
