Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:41465 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750735Ab3GaEUv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 00:20:51 -0400
Message-ID: <51F89058.6080101@cn.fujitsu.com>
Date: Wed, 31 Jul 2013 12:19:36 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Tomasz Chmielewski <mangoo@wpkg.org>
CC: Wang Shilong <wangshilong1991@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs qgroup assign -> "ERROR: bad relation requested"
References: <20130728135116.5ed992d4@wpkg.org> <8C42FC74-384A-4D88-9D11-17AC7394A20B@gmail.com> <20130730192525.42725e74@wpkg.org> <3C9EC4DB-0B63-49A8-B53C-24E162CB8FEF@gmail.com> <20130731104624.163d07d7@wpkg.org>
In-Reply-To: <20130731104624.163d07d7@wpkg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/31/2013 11:46 AM, Tomasz Chmielewski wrote:
> On Tue, 30 Jul 2013 21:06:32 +0800
> Wang Shilong <wangshilong1991@gmail.com> wrote:
> 
>> I have implemented the above function, but they haven't gone into
>> upstream Btrfs-progs.
>>
>> You can try this:
>>
>> 	http://github.com/miaoxie/btrfs-progs.git qgroup
>>
>> Maybe i need rebase the patch-set later, But you can try it firstly,
>> if you want to see every qgroup's parent, you can add option '-p':
>>
>> btrfs qgroup show  -p <mnt>
> 
> Hmm, is it correct git URL?


I have tried it and it works, you can do like the following to try it.

#git clone http://github.com/miaoxie/btrfs-progs.git

#cd btrfs-progs

#git pull origin master

#make && make install

Thanks,
Wang
> 
> # btrfs qgroup show -p /mnt/lxc2
> btrfs qgroup show: too many arguments
> usage: btrfs qgroup show <path>
> 
>     Show all subvolume quota groups.
> 
> 
> 

