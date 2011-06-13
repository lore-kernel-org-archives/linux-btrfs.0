From: Chris Mason <chris.mason@oracle.com>
Subject: Re: bug caused by removal of trans_mutex? (Was: Re: kernel BUG at fs/btrfs/extent-tree.c:6164!)
Date: Mon, 13 Jun 2011 15:55:51 -0400
Message-ID: <1307994828-sup-6461@shiny>
References: <4DEC90CB.4050609@jp.fujitsu.com> <4DEDB7AF.2060308@cn.fujitsu.com> <4DEDBE4B.2020403@jp.fujitsu.com> <4DEDC293.30105@jp.fujitsu.com> <4DEDE03B.9050907@jp.fujitsu.com> <4DEDE328.5060405@cn.fujitsu.com> <1307461229-sup-9822@shiny> <4DEF04CF.8010502@jp.fujitsu.com> <4DF5B889.5080202@cn.fujitsu.com> <BANLkTi=m2CkcSQNPNja=A7eG62vLstM1sw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: Li Zefan <lizf@cn.fujitsu.com>,
	Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
	liubo <liubo2009@cn.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: "Yan, Zheng" <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <BANLkTi=m2CkcSQNPNja=A7eG62vLstM1sw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Yan, Zheng's message of 2011-06-13 10:58:35 -0400:
> The usage of trans_mutex in relocation code is subtle. It controls
> interaction of relocation
> with transaction start, transaction commit and snapshot creation.
> Simple replacing
> trans_mutex with trans_lock is wrong.

So, I've got a mutex around the reloc_root here and that was almost but
not quite enough.  It looks like the biggest problem is that we need to
wait in btrfs_record_root_in_trans for anyone inside merge_reloc_roots.

I'm surviving much longer with a patch in place that synchronizes
btrfs_record_root_in_trans better.

Zheng if you have other comments on the locking please let me know.

-chris
