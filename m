Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:40234 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751581Ab2LTDQ5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Dec 2012 22:16:57 -0500
Message-ID: <50D28345.4010805@cn.fujitsu.com>
Date: Thu, 20 Dec 2012 11:17:25 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Arne Jansen <sensille@gmx.net>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        wangshilong <wangsl-fnst@cn.fujitsu.com>
Subject: Re: About btrfs qgroup import/export command
References: <50D1632E.6010801@cn.fujitsu.com> <50D1A430.607@cn.fujitsu.com> <50D1A7A9.9010300@gmx.net>
In-Reply-To: <50D1A7A9.9010300@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 19 Dec 2012 12:40:25 +0100, Arne Jansen wrote:
> On 19.12.2012 12:25, Miao Xie wrote:
>> Hi, everyone.
>>
>> As we know, there is no backup function for qgroup. when the problem
>> occurs, the users must recover qgroup configuration manually, it is not
>> convenient. And besides that, some users might want to import an existed
>> qgroup configuration into a new filesystem. Btrfs does not have such a
>> function,it can only be done manually.
>>
>> So we want to implement btrfs qgroup import/export commands.
>> 1)'btrfs qgroup export' commands will export qgroup tree
>>   into a user's specified file.(stdout by default)
>>
>> 2)user may modify the configuration file firstly and then
>>   import it into the filesystem.(by 'btrfs qgroup import' command)
>>
>> The file may be formated as the following:
>>
>> Qgroupid     is_compressed     is_exclusive   limited_size    parent
>> ----------------------------------------------------------------------
>>  0/1            0                 0              10G            1/0
>>  1/0            1                 1              20G            ---
>>   
>>  If 'is_exclusive' is set, 'limited_size' corresponds to max exlusive size,
>>  else max referenced size. Here 'parent' exclude ancestral qgroups. 
>>
>> Is there any comment about this idea? 
> 
> The configuration only really makes sense in combination with the existing
> subvolumes. Even if the target has subvolumes under the same name, they
> might have different internal IDs. So it might make more sense to address
> the level 0 qgroups by name.

Yeah. Thanks for your suggest.

> Also it might be misleading to apply a configuration to an existing fs, as
> it currently is not possible get a correct accounting if the fs is not
> empty. Rescan is not yet implemented.
> So instead of just saving and restoring the qgroup config, it might make
> more sense to create a new filesystem including all subvolumes and quota
> config from a config file.
> But, I'm not completely convinced that this is a features that is needed
> frequently. If I want a standard deployment, I simple write a script that
> creates the fs + subvol + quota.

But if you set a new value for some groups, you must modify your script at
the same time, it is a bit troublesome.

Thanks
Miao
