From: Tommy Jonsson <quazzie@gmail.com>
Subject: Re: Fsck, parent transid verify failed
Date: Wed, 8 Dec 2010 21:07:58 +0100
Message-ID: <AANLkTi=mfw7V8QSZ2=t04+d9kvZ3F5zgtinQ4E3uY8uc@mail.gmail.com>
References: <003501cb9147$09197540$1b4c5fc0$@gmail.com>
	<1291306826-sup-7837@think>
	<AANLkTim5-5KQ3_sEb9WY+O1Uj36=3M3i_yQKeuSb7Qe5@mail.gmail.com>
	<1291326502-sup-1726@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1291326502-sup-1726@think>
List-ID: <linux-btrfs.vger.kernel.org>

>> Build the latest tools, then:
>>
>> btrfsck -s 1 /dev/xxx
>> btrfsck -s 2 /dev/xxx
>>
>> If either of these work we have an easy way to get it mounted.  Just let
>> me know.
>>
>> -chris
>>

> $ btrfsck -s 1 /dev/sda
> using SB copy 1, bytenr 67108864
> parent transid verify failed on 2721514774528 wanted 39651 found 39649
> btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)' failed.
> Aborted
>
> $ btrfsck -s 2 /dev/sda
> using SB copy 2, bytenr 274877906944
> parent transid verify failed on 2721514774528 wanted 39651 found 39649
> btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)' failed.
> Aborted
>
> Tried "btrfs-debug-tree /dev/sda" and "btrfs-debug-tree -e /dev/sda" :
> parent transid verify failed on 2721514774528 wanted 39651 found 39649
> btrfs-debug-tree: disk-io.c:739: open_ctree_fd: Assertion
> `!(!tree_root->node)' failed.
>
> dmesg said:
> [268375.903581] device fsid 734a485d12c77872-9b0b5aa408670db4 devid 2 transid 39650 /dev/sdd
> [268375.904241] device fsid 734a485d12c77872-9b0b5aa408670db4 devid 1 transid 39651 /dev/sdc
> [268375.904526] device fsid 734a485d12c77872-9b0b5aa408670db4 devid 3 transid 39651 /dev/sda

Sorry to be a bother, but do you have any other suggestions ?

Thanks!

-tommy
