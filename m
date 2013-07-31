Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:33628 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078Ab3GaEgz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 00:36:55 -0400
Date: Wed, 31 Jul 2013 11:36:44 +0700
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: Wang Shilong <wangshilong1991@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs qgroup assign -> "ERROR: bad relation requested"
Message-ID: <20130731113644.0d98bb06@wpkg.org>
In-Reply-To: <51F89058.6080101@cn.fujitsu.com>
References: <20130728135116.5ed992d4@wpkg.org>
	<8C42FC74-384A-4D88-9D11-17AC7394A20B@gmail.com>
	<20130730192525.42725e74@wpkg.org>
	<3C9EC4DB-0B63-49A8-B53C-24E162CB8FEF@gmail.com>
	<20130731104624.163d07d7@wpkg.org>
	<51F89058.6080101@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 31 Jul 2013 12:19:36 +0800
Wang Shilong <wangsl.fnst@cn.fujitsu.com> wrote:

> I have tried it and it works, you can do like the following to try it.
> 
> #git clone http://github.com/miaoxie/btrfs-progs.git
> 
> #cd btrfs-progs
> 
> #git pull origin master
> 
> #make && make install

Hmm:

# git clone http://github.com/miaoxie/btrfs-progs.git
Cloning into 'btrfs-progs'...
remote: Counting objects: 3917, done.
remote: Compressing objects: 100% (1565/1565), done.
remote: Total 3917 (delta 2681), reused 3582 (delta 2348)
Receiving objects: 100% (3917/3917), 1.88 MiB | 634 KiB/s, done.
Resolving deltas: 100% (2681/2681), done.

# cd btrfs-progs/

# git pull origin master
>From http://github.com/miaoxie/btrfs-progs
 * branch            master     -> FETCH_HEAD
Already up-to-date.

# make && make install
(...)

# btrfs qgroup show -p /mnt/lxc2
btrfs qgroup show: too many arguments
usage: btrfs qgroup show <path>

    Show all subvolume quota groups.



This is the right binary (by looking at timestamps):

# /usr/local/bin/btrfs qgroup show -p /mnt/lxc2
btrfs qgroup show: too many arguments
usage: btrfs qgroup show <path>

    Show all subvolume quota groups.

# ls -l /usr/local/bin/btrfs
-rwxr-xr-x 1 root staff 1.5M Jul 31 04:30 /usr/local/bin/btrfs

# date
Wed Jul 31 04:33:59 UTC 2013


"git log" is quite old, too (last change from Thu Nov 8 17:54:13 2012 +0800).


-- 
Tomasz Chmielewski
http://wpkg.org
