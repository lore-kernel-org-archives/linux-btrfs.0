From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH 2/4] Btrfs: fix deadlock on sb->s_umount when doing umount
Date: Wed, 09 May 2012 11:24:28 +0800
Message-ID: <4FA9E36C.3060008@cn.fujitsu.com>
References: <4F98B9BC.7010905@gmail.com> <20120426114456.GN20982@twin.jikos.cz> <4F9A7B11.1020400@gmail.com> <20120430164139.GB6740@twin.jikos.cz> <4FA8F789.80208@cn.fujitsu.com> <20120508153326.GI19331@twin.jikos.cz>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Miao Xie <miaoxie1984@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux FSDevel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120508153326.GI19331@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 8 May 2012 17:33:26 +0200, David Sterba wrote:
> On Tue, May 08, 2012 at 06:38:01PM +0800, Miao Xie wrote:
>> I think this method can not fix the problem safely because if the other
>> background threads(not the cleaner) call shrink_delalloc(), the problem
>> can still occur.
> 
> And it does not indeed fix the problem completely, I found xfstests/269
> hung inside cleaner and defrag (mounted with autodefrag).

Did you apply the trylock patchs I sent before?

Thanks
Miao
