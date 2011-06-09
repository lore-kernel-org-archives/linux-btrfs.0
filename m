From: Arne Jansen <sensille@gmx.net>
Subject: Re: [GIT PULL] scrub fixes for -rc3
Date: Thu, 09 Jun 2011 08:51:39 +0200
Message-ID: <4DF06D7B.8050003@gmx.net>
References: <4DEF39C0.8040405@gmx.net> <4DEF7865.5070403@redhat.com> <1307555576-sup-582@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Josef Bacik <josef@redhat.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1307555576-sup-582@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 08.06.2011 19:54, Chris Mason wrote:
> Excerpts from Josef Bacik's message of 2011-06-08 09:25:57 -0400:
>> On 06/08/2011 04:58 AM, Arne Jansen wrote:
>>> Hi Chris,
>>>
>>> please pull from
>>>
>>> git://git.kernel.org/pub/scm/linux/kernel/git/arne/btrfs-unstable-arne.git
>>> for-chris
>>>
>>> It contains the 2 commits
>>>
>>> Arne Jansen (1):
>>>       btrfs: scrub: errors in tree enumeration
>>>
>>> Li Zefan (1):
>>>       Btrfs: avoid stack bloat in btrfs_ioctl_fs_info()
> 
> Please leave off commits from others unless you somehow depend on
> them ;)  I'll pull in the stack bloat patch separately.

ok, will not do it again ;)

> 
> re: the revert, it sounds like the lack of locking is causing trouble.
> We'll have to figure something else out.

Josef sent a patch for that. It fixes the crashes I saw, so please take
it instead.

The branch is now updated to contain only the tree enumeration
correction, now even more correct.

-Arne

> 
> -chris

