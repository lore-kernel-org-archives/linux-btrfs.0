Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:44051 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899Ab3GaDqe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jul 2013 23:46:34 -0400
Date: Wed, 31 Jul 2013 10:46:24 +0700
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs qgroup assign -> "ERROR: bad relation requested"
Message-ID: <20130731104624.163d07d7@wpkg.org>
In-Reply-To: <3C9EC4DB-0B63-49A8-B53C-24E162CB8FEF@gmail.com>
References: <20130728135116.5ed992d4@wpkg.org>
	<8C42FC74-384A-4D88-9D11-17AC7394A20B@gmail.com>
	<20130730192525.42725e74@wpkg.org>
	<3C9EC4DB-0B63-49A8-B53C-24E162CB8FEF@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 30 Jul 2013 21:06:32 +0800
Wang Shilong <wangshilong1991@gmail.com> wrote:

> I have implemented the above function, but they haven't gone into
> upstream Btrfs-progs.
> 
> You can try this:
> 
> 	http://github.com/miaoxie/btrfs-progs.git qgroup
> 
> Maybe i need rebase the patch-set later, But you can try it firstly,
> if you want to see every qgroup's parent, you can add option '-p':
> 
> btrfs qgroup show  -p <mnt>

Hmm, is it correct git URL?

# btrfs qgroup show -p /mnt/lxc2
btrfs qgroup show: too many arguments
usage: btrfs qgroup show <path>

    Show all subvolume quota groups.



-- 
Tomasz Chmielewski
http://wpkg.org
