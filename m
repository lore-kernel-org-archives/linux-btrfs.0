Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:58813 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342Ab3LTQlW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Dec 2013 11:41:22 -0500
Date: Sat, 21 Dec 2013 01:41:10 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: Shilong Wang <wangshilong1991@gmail.com>
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/relocation.c:1062
Message-ID: <20131221014110.606c2ca8@virtall.com>
In-Reply-To: <CAP9B-Q=SyEbQP1fLto2buR7jRqQHcD37ACuAguSxT4Td07KV9Q@mail.gmail.com>
References: <20131219210941.1065d1b5@virtall.com>
	<52B2E319.4010706@cn.fujitsu.com>
	<20131219213019.1f1038f2@virtall.com>
	<52B2EB40.5090904@cn.fujitsu.com>
	<20131219220737.7b173f9a@virtall.com>
	<20131221000623.30148a5d@virtall.com>
	<CAP9B-Qm+he3V-Oh2AgH+gUXgcSUbE-Az0YaW0gBgW03mmDN9EA@mail.gmail.com>
	<20131221005902.0d795572@virtall.com>
	<CAP9B-Q=SyEbQP1fLto2buR7jRqQHcD37ACuAguSxT4Td07KV9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 21 Dec 2013 00:07:19 +0800
Shilong Wang <wangshilong1991@gmail.com> wrote:

> 2013/12/20 Tomasz Chmielewski <tch@virtall.com>:
> > -o  skip_balance - didn't know this.
> >
> > Actually, I was able to "skip" the balance, sort of, with this:
> >
> > mount /mnt/btrfs ; btrfs fi balance cancel /mnt/btrfs
> 
> From your previous email, i suspend your filesystem is nearly fully.
> "mount -o skip_balance" will avoid balance continuing while use btrfs
> balance cancel still
> can not avoid balance totally, so i recommend you use skip_balance
> option when remounting.

My other thread a few days ago ("no space left, metadata usage almost
full?"), if that's what you're referring to, was about a different
filesystem.

This one should have enough free space left:

# btrfs fi
show /mnt/lxc1 Label: lxc1  uuid: 8d08ad6d-4543-4fe5-8b1b-640dc1423d41
        Total devices 2 FS bytes used 2.02TiB
        devid    1 size 2.62TiB used 2.02TiB path /dev/sda5
        devid    2 size 2.62TiB used 2.02TiB path /dev/sdb5

Btrfs v3.12

# btrfs fi df /mnt/lxc1
Data, RAID1: total=1.97TiB, used=1.97TiB
System, RAID1: total=32.00MiB, used=300.00KiB
Metadata, RAID1: total=50.00GiB, used=49.21GiB


I've tried using skip_balance - it mounted, but breaks soon after I try
to remove any snapshot.


-- 
Tomasz Chmielewski
http://wpkg.org
