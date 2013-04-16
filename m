Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:12526 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934017Ab3DPKm7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 06:42:59 -0400
Message-ID: <516D2C33.1010601@cn.fujitsu.com>
Date: Tue, 16 Apr 2013 18:47:15 +0800
From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: dsterba@suse.cz, Wang Shilong <wangsl-fnst@cn.fujitsu.com>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org, Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH v2 1/3] Btrfs: split btrfs_qgroup_account_ref into four
 functions
References: <1366101920-13083-1-git-send-email-list.btrfs@jan-o-sch.net> <1366101920-13083-2-git-send-email-list.btrfs@jan-o-sch.net> <516D17F1.4070208@cn.fujitsu.com> <516D1C25.5060103@jan-o-sch.net> <516D2035.6010800@cn.fujitsu.com> <20130416103228.GG18193@twin.jikos.cz>
In-Reply-To: <20130416103228.GG18193@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

> On Tue, Apr 16, 2013 at 05:56:05PM +0800, Wang Shilong wrote:
>> But static checker may want to know what is 3 steps
>> just by the function name but not to read the pdf.
> 
> I'm curious what static checker you mean and how a function name helps
> there.


I mean that other developers will get more information by the function name.
In fact, the tree steps they do more things.So maybe
the function name of mine is not good enough.
But i really hope that a meaningful function name gives more information. I don't
insist on this anyway ^_^

Thanks,
Wang

> 
> thanks,
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 



