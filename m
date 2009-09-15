From: Michel Alexandre Salim <michael.silvanus@gmail.com>
Subject: Re: Incorrect disk space reporting
Date: Tue, 15 Sep 2009 01:20:42 -0400
Message-ID: <615c05430909142220l735d11a7p9841ccaa748e491a@mail.gmail.com>
References: <615c05430909141957m65cc0b30jfda5bd04e23dd6a3@mail.gmail.com>
	 <3d0408630909142151y71024345wf1d00afc944e3946@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs list <linux-btrfs@vger.kernel.org>
To: "Yan, Zheng" <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630909142151y71024345wf1d00afc944e3946@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Zheng,

On Tue, Sep 15, 2009 at 12:51 AM, Yan, Zheng <yanzheng@21cn.com> wrote:
> 2009/9/15 Michel Alexandre Salim <michael.silvanus@gmail.com>:
>> I have btrfs /home partitions on two machines, a laptop with Fedora
>> 11.91 (Rawhide) x86_64, and a netbook with the same OS, i686 (32-bit).
>> Both with kernel 2.6.31-2.fc12 and btrfs-progs 0.19.
>>
>> /home directories are both converted from ext4.
>>
>> On the netbook, everything is fine; on the laptop, I thought
>> everything was fine until I ran a program installer that checks the
>> amount of disk space. To my surprise, I then noticed that it is as
>> follows:
>>
>> $ df -h /home
>> /dev/mapper/system-home 212G -64Z -99G 100% /home
>>
> This bug has already been fixed in btrfs-progs-unstable tree. The bug
> only affects fstatfs(2)
>
Aha, thanks. Is the only solution to dump / reformat / restore? This
is what happens when I tried btrfsck from the unstable tree:

[michel@erdos unstable]$ sudo btrfsck /dev/mapper/system-homeparent
transid verify failed on 207315775488 wanted 979 found 973
btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)' failed.
Aborted
[michel@erdos unstable]$ sudo btrfsck /dev/mapper/system-home
parent transid verify failed on 207317180416 wanted 980 found 935
btrfsck: disk-io.c:416: find_and_setup_root: Assertion `!(!root->node)' failed.
Aborted
[michel@erdos unstable]$ sudo btrfsck /dev/mapper/system-home
parent transid verify failed on 207317180416 wanted 980 found 935
btrfsck: disk-io.c:416: find_and_setup_root: Assertion `!(!root->node)' failed.
Aborted

Note -- with the stable tree, btrfsck works fine, it just did not fix
the free space count

Thanks,

-- 
Michel Alexandre Salim
