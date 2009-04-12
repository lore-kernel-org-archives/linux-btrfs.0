From: Harald Glatt <mail@hachre.de>
Subject: Unable to mount btrfs after crash
Date: Sun, 12 Apr 2009 02:03:46 +0200
Message-ID: <EE151463-E687-43D0-91E0-02003C32972F@hachre.de>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have set up a btrfs within a 200 GB file that I mount via -o loop.

It worked fine so far but today it crashed when there was alot of  
concurrent writing/reading going on.
I'm testing it with a torrent client, so the data is really irrelevant  
- but it's a good amount of stress.

When it crashed dmesg got logged onto my /var/log which filled up the  
entire harddrive within a few minutes... Since I wasn't able to reboot  
properly I deleted the relevant log files and am not able to give a  
dmesg output of the crash :(

I adjusted my logging now so I should be able to provide more info  
next time.

When I try to mount the filesystem now mount hangs forever though and  
dmesg is flooding this message several times per second:
parent transid verify failed on 164143104 wanted 22325 found 22209

I don't really care about the data but I would like to restore one  
config file from the filesystem.

Is there any way to get it mounted? Or to extract single files?

If you need any more info feel free to ask, I'll try to help as much  
as possible.

Thanks
Harald
