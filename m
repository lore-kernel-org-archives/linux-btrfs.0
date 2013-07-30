Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:40248 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab3G3NGi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jul 2013 09:06:38 -0400
Received: by mail-pb0-f49.google.com with SMTP id xb4so1720911pbc.36
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jul 2013 06:06:37 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: btrfs qgroup assign -> "ERROR: bad relation requested"
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <20130730192525.42725e74@wpkg.org>
Date: Tue, 30 Jul 2013 21:06:32 +0800
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-Id: <3C9EC4DB-0B63-49A8-B53C-24E162CB8FEF@gmail.com>
References: <20130728135116.5ed992d4@wpkg.org> <8C42FC74-384A-4D88-9D11-17AC7394A20B@gmail.com> <20130730192525.42725e74@wpkg.org>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

> On Sun, 28 Jul 2013 15:36:41 +0800
> Wang Shilong <wangshilong1991@gmail.com> wrote:
> 
>> Btrfs group assign requires parent's level > children's level, For
>> your example below, you can do like:
>> 
>> btrfs qgroup create 1/1 <mnt>
>> btrfs qgroup assign  1177 1/1 <mnt>
>> btrfs qgroup assign  1178 1/1  <mnt>
> 
> Cool, thanks.
> 
> And is it possible (i.e. at some later point) to verify that 1177, 1178
> were assigned to 1/1 (or in general, what is assigned to 1/1)?

I have implemented the above function, but they haven't gone into upstream
Btrfs-progs.

You can try this:

	http://github.com/miaoxie/btrfs-progs.git qgroup

Maybe i need rebase the patch-set later, But you can try it firstly, if you want to see
every qgroup's parent, you can add option '-p':

btrfs qgroup show  -p <mnt>


If you want to see what is assigned to 1/1, you can use:

btrfs group show -c <mnt>

Further, if you want to see a specified path's parent qgroup, you can use it:

btrfs group show -F/-f <path>

Also '-l' and '-e' print limit size of qgroup.

Thanks,
Wang
> 
>  
> -- 
> Tomasz Chmielewski
> http://wpkg.org
> 

