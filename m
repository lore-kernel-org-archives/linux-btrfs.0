From: Duncan <1i5t5.duncan@cox.net>
Subject: Wiki update request: source repo page   Was: [PATCH] Btrfs: use
 i_version instead of our own sequence
Date: Thu, 12 Apr 2012 21:41:17 +0000 (UTC)
Message-ID: <pan.2012.04.12.21.41.17@cox.net>
References: <1333986794-6525-1-git-send-email-josef@redhat.com>
	<CALLzPKY0ViBnaH8PVOmxad+oPpbWiYOz24+Lc8CWNuzKbyHHng@mail.gmail.com>
	<20120412133107.GC1924@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik posted on Thu, 12 Apr 2012 09:31:07 -0400 as excerpted:

>> BTW.
>> 1. where is BTRFS devel git tree?
>> 2. when this is coming to mainline?
>> 
>> 
> There's a bunch, my personal tree with just my patches is here
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-work.git
> 
> a tree with all outstanding mailinglist patches is here
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git
> 
> and Chris's tree which is where all things go through to get to mainline
> is here
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git
> 
> It will probably be in the next merge window.  Thanks,


Could this list be added to the btrfs wiki, source repositories page?

http://btrfs.ipv5.de/index.php?title=Btrfs_source_repositories

While there, please review the dkms information:

0) At least a paragraph actually describing what dkms is/does would be 
extremely useful.  A link to another page on the topic or to an external 
dkms resource for more information is probably in order as well.

1) Near the top of the dkms section, under "You have a very recent 
kernel", the for instance says dkms doesn't work with recent kernels, but 
then backporting is mentioned.  So you want to use it if you have a very 
recent kernel, but it doesn't work with recent kernels and backporting is 
needed?  WTF?

2) Is Chris's tree STILL based on old 2.6.32 without further updates 
except to btrfs?  If so, the link to it in the earlier btrfs kernel 
module git repository section should probably have a BIG WARNING TO THAT 
EFFECT, instead of simply saying it downloads a complete Linux kernel 
tree.

3) Further down there's a step that says Patch version script, noting 
2.6.27, which is older still.  Has cmason merged that patch?

4) The instructions appear to assume a kernel module an initr* based 
setup.  What about people who configure and build a custom monolithic 
kernel, with module loading disabled?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

