Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:37884 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750841Ab2JIHYt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2012 03:24:49 -0400
Message-ID: <5073D13E.90101@gmx.net>
Date: Tue, 09 Oct 2012 09:24:46 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?matthieu_Barth=E9lemy?= <bonsouere@gmail.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: working quota example?
References: <CAK=A7Ef2jTckd216+EVmYZhiArMWZrnWxe2K_aAF2C7ZL3pDHw@mail.gmail.com> <5072CEB6.6030709@gmx.net> <CAK=A7Ee84dXpc4DenR7-Sn8UPG-qTiRRS0fdvRCWT+hF1bPaSQ@mail.gmail.com> <50732ED1.9030005@gmx.net> <CAK=A7Efzgu8pS0P_i=qK-Fqahb4KENBrV-Fq_FHKHDm-GxCBjA@mail.gmail.com>
In-Reply-To: <CAK=A7Efzgu8pS0P_i=qK-Fqahb4KENBrV-Fq_FHKHDm-GxCBjA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09.10.2012 09:13, matthieu Barthélemy wrote:
> On Mon, Oct 8, 2012 at 9:51 PM, Arne Jansen <sensille@gmx.net> wrote:
>> On 10/08/12 21:31, matthieu Barthélemy wrote:
>>
>>>
>>> Are there any plan to maybe get a better 'btrfs quota show' output?
>>
>> Definitely. The first priority was to get the kernel part running, when
>> that is settled, we can improve the user mode part. There's also still
>> some work to do to make the tracking qgroups more presentable.
>>
> Yes, and it seems to run well, I confirm that I was able to set a
> quota on a test subvolume and have it trigger as expected.
> 
> But now I'm stuck again, though maybe the problem is as obvious as the
> one that made me post first...
> After having created a file that triggered a "quota exceeded" error, I
> created a snapshot of my subvolume. No problem here.
> Then I tried to remove the original 'big' test file :
> 
> rm: cannot remove `/btrfs/test/bigFile': Disk quota exceeded
> 
> 
> I then tried to delete the snapshot subvol to see if it helped:
> 
> # ./btrfs sub delete /btrfs/test/.snap1/
> Delete subvolume '/btrfs/test/.snap1'
> # rm /btrfs/test/bigFile
> rm: cannot remove `/btrfs/roger/bigFile': Disk quota exceeded
> 
> # ./btrfs qgroup show /btrfs/
> 0/257 1073725440 4096
> 0/261 1073725440 4096
> 
> 261 was the snap that I just removed. Why is it still there?
> 

It may be that the corresponding qgroup does not get removed automatically
with the subvol. So it's not the subvol that's still there, just the qgroup.

> No problem, let's remove it:
> # ./btrfs qgroup destroy 0/261 /btrfs/
> 
> # rm /btrfs/test/bigFile
> rm: cannot remove `/btrfs/test/bigFile': Disk quota exceeded

Do you have a limit on 257?

> 
> # ls -lsha /btrfs/test/
> total 1.0G
>    0 drwxr-xr-x 1 root root   14 Oct  9 09:00 .
> 4.0K drwxr-xr-x 1 root root   10 Oct  8 19:56 ..
> 1.0G -rw-r--r-- 1 root root 1.0G Oct  8 19:58 bigFile
> 
> 
> 
> I have to destroy my subvolume qgroup (0/257) to be able to 'rm' my
> file.  Is this the expected behavior?

In a way. You could just have raised the limit. The problem with cow
filesystems is that a delete actually takes space, even if it gets
freed afterwards when no snapshots are present. The quota code currently
has no special handling for 'rm', though it would obviously be useful.
It is already on the TODO list.

-Arne

> Of course I did something wrong again, but where?
> 
> Thanks for your help,

