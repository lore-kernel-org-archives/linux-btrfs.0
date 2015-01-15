Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:65506 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752008AbbAOBBk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Jan 2015 20:01:40 -0500
Message-ID: <54B71171.60809@cn.fujitsu.com>
Date: Thu, 15 Jan 2015 09:01:37 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Fan Chengniang <fancn.fnst@cn.fujitsu.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 RESEND] btrfs-progs: make btrfs qgroups show human
 readable sizes
References: <1421128419-17169-1-git-send-email-fancn.fnst@cn.fujitsu.com> <20150114154633.GU3685@twin.jikos.cz>
In-Reply-To: <20150114154633.GU3685@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH v2 RESEND] btrfs-progs: make btrfs qgroups show 
human readable sizes
From: David Sterba <dsterba@suse.cz>
To: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
Date: 2015年01月14日 23:46
> On Tue, Jan 13, 2015 at 01:53:39PM +0800, Fan Chengniang wrote:
>> make btrfs qgroups show human readable sizes
>> using --human-readable option, example:
> That's too long to type
It's completely OK to make the option shorter and make it consistent 
with other parts,
(BTW, fi df uses -h, no long option, why not keey consistent with it?)
but IMHO, isn't the bash-completion script a better solution for all the 
btrfs subcommands and options length?

Complicated commands like git have a quite good bash-completion script, 
and with it
option length is never a problem (except some case in git config, where 
some options can't be completed).

Thanks,
Qu
> and the idea was to add all the long options
> that force the specific unit base, ie. --kbytes/--mbytes/..., --raw,
> --si and --iec. We can possibly make the human readable the default
> because that's what I'd expect to see to have a quick overview and can
> use the other options otherwise.
>
> The geopt parser accepts short options if they're unique, so --kb or
> even --k works as a very convenient shorcut for frequent commandline
> use.
>
>> qgroupid rfer         excl         max_rfer     max_excl     parent  child
>> -------- ----         ----         --------     --------     ------  -----
>> 0/5      299.58MiB    299.58MiB    400.00MiB    0.00B        1/1     ---
>> 0/265    299.58MiB    16.00KiB     0.00B        320.00MiB    1/1     ---
>> 0/266    299.58MiB    16.00KiB     350.00MiB    0.00B        ---     ---
>> 1/1      599.16MiB    299.59MiB    800.00MiB    0.00B        ---     0/5,0/265
> The values should be also aligned to the right.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

