From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: "open_ctree failed", unable to mount the fs
Date: Fri, 07 Jan 2011 21:01:31 +0100
Message-ID: <4D27711B.4090606@wpkg.org>
References: <4D276899.7000702@wpkg.org> <AANLkTik3GZVTwco+4PNFriB0+t_U=e+dH0UOgK_3P9D5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTik3GZVTwco+4PNFriB0+t_U=e+dH0UOgK_3P9D5@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 07.01.2011 20:46, cwillu wrote:

>> However, I don't see the tool when I clone the latest git - am I missing something?
>
> It's not built by the makefile by default;  "make btrfs-select-super"
> as stated above will make it.

$ grep select Makefile
$ grep super Makefile
$ grep -r select-super *
$ grep -r selects-super *


I used:

git clone 
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git 
next


-- 
Tomasz Chmielewski
http://wpkg.org
