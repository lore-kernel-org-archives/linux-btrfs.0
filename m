Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:59307 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913Ab3JAMZt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Oct 2013 08:25:49 -0400
Received: by mail-pd0-f175.google.com with SMTP id q10so7112281pdj.20
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Oct 2013 05:25:48 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH v2 0/9] enhance btrfs qgroup show command
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <20131001111950.GA18291@twin.jikos.cz>
Date: Tue, 1 Oct 2013 20:25:38 +0800
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-Id: <0CE9197F-E95E-4C1E-8A7A-DFFD6AF110D3@gmail.com>
References: <1379917048-9720-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <20131001111950.GA18291@twin.jikos.cz>
To: dsterba@suse.cz
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

> On Mon, Sep 23, 2013 at 02:17:19PM +0800, Wang Shilong wrote:
>> Firstly, we restructure show_qgroups, make it easy to add new features.
>> And then we add '-p' '-c', '-l',and '-e' options to print the parent
>> qgroup id, child qgroup id, max referenced size and max exclusive size
>> of qgroup respectively, add '-F' and '-f' option to list qgroups that
>> impact the given path.
> 
> Well done! I really like it.
> 
> Minor comments:
> 
> * -l sounds less intuitive, I suggest to use -r as for
>  'referenced', given that there is -e for 'exclusive'.

Yeah, here -l means limited size. Anyway, this is a little  obscure.
Maybe -r is better, but it may let user think it is a qgroup's referenced size
but not max referenced size..


> * the size should be pretty-printed by default or in bytes if a
>  commandline option is given

Agree, maybe i can add an options for example '-h'  here.

> 
> * in the long term, the tabular output would be much better as
>  default, and the current terse output available via commandline option
>  for batch processing

The main reason that i don't use table result as default is because there
are so many columns here, and my first table result will be a head name like:

rfer excl max_refer max_excl
----  -----  -----------   -------------

In order to keep compatibility with previous 'btrfs qgroup show', i add '-t'.

Thanks,
Wang
> 
> thanks,
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

