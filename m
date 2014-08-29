Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:38364 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbaH2Hk3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Aug 2014 03:40:29 -0400
Received: by mail-la0-f51.google.com with SMTP id gl10so2205581lab.38
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Aug 2014 00:40:28 -0700 (PDT)
Message-ID: <54002E66.703@gmail.com>
Date: Fri, 29 Aug 2014 10:40:22 +0300
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: Jean-Denis Girard <jd.girard@sysnux.pf>, linux-btrfs@vger.kernel.org
Subject: Re: Undelete files / directory
References: <53FE1DB2.8040900@sysnux.pf> <pan$2ed7a$1001c22e$8c89f27e$d20dc522@cox.net> <262E2EAA-FE5F-4ADB-9D1D-258D51D81AFE@colorremedies.com> <ltnnfo$a57$1@ger.gmane.org>
In-Reply-To: <ltnnfo$a57$1@ger.gmane.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 28/8/2014 8:04 μμ, Jean-Denis Girard wrote:
> Hi Chris,
>
> Thanks for your detailed answer.
>
> Le 28/08/2014 06:25, Chris Murphy a écrit :
>> 9. btrfs-find-root /dev/sdc
>> Super think's the tree root is at 29917184, chunk root 20987904
>> Well block 4194304 seems great, but generation doesn't match, have=2, want=9 level 0
>> Well block 4243456 seems great, but generation doesn't match, have=3, want=9 level 0
>> Well block 29376512 seems great, but generation doesn't match, have=4, want=9 level 0
>> Well block 29474816 seems great, but generation doesn't match, have=5, want=9 level 0
>> Well block 29556736 seems great, but generation doesn't match, have=6, want=9 level 0
>> Well block 29736960 seems great, but generation doesn't match, have=7, want=9 level 0
>> Well block 29900800 seems great, but generation doesn't match, have=8, want=9 level 0
Hi all,

I did a successful btrfs restore a few months ago, saving all of my 
deleted files except 2 (So i lost about 1GB on a 4TB filesystem)
Here is what i did (this is from memory and from my .zsh_history file, 
so i may be missing something)

btrfs-find-root  /dev/sdd -o 5 > b1.txt
I think the -o 5 option is quite important here.
After that, i ran this

for i in `awk '{print $3}' b1.txt`; do echo "------------------------  
$i --------------------" && btrfs restore /dev/sdd /storage/A3/ -Dv -f 
$i  ; done

I think i did that in order to brute force a correct offset

I also have done this, in order to find the offset that gave the largest 
number of files
for i in `awk '{print $3}' b1.txt`; do echo "------------------------  
$i --------------------" && btrfs restore /dev/sdd /storage/A3/ -Dv -f 
$i |wc -l ; done


Then i did some test restores using various addresses
btrfs restore /dev/sdd /storage/A3/B1/  -vD -f 2149617336320
btrfs restore /dev/sdd /storage/A3/B1/  -vD -f 1607682736128
btrfs restore /dev/sdd /storage/A3/B1/  -vD -f 2688721551360

and then i finally did the restore using the offset that looked best

btrfs restore /dev/sdd /storage/A3/B1/  -v -f 2688721551360

I hope this helps, good luck!


> Here is what the command returns :
>
> [root@x220 ~]# btrfs-find-root /dev/mapper/home
> Super think's the tree root is at 115230801920, chunk root 131072
> Went past the fs size, exiting[root@x220 ~]#
>
> I just tried with latest btrfs-progs (from git), it returns exactly the
> same.
>
> The btrfs partition is on top of dm-crypt, could it be a problem?
>
>
> Thanks,
> Jean-Denis Girard
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Konstantinos Skarlatos

