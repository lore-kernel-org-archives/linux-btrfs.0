Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:63929 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934330AbcLOACj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Dec 2016 19:02:39 -0500
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 98348AC0181
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Dec 2016 09:02:29 +0900 (JST)
Subject: Re: [PATCH v2] btrfs-progs: qgroup: add sync option to 'qgroup show'
To: dsterba@suse.cz
References: <201612070307.AA00021@WIN-5MHF4RKU941.jp.fujitsu.com>
 <201612070755.AA00022@WIN-5MHF4RKU941.jp.fujitsu.com>
 <20161214105409.GA3620@twin.jikos.cz>
Cc: linux-btrfs@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Message-ID: <c48dd7dd-ce7f-1e06-c7c5-f87d3812caf6@jp.fujitsu.com>
Date: Thu, 15 Dec 2016 09:02:08 +0900
MIME-Version: 1.0
In-Reply-To: <20161214105409.GA3620@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

Thanks for the review.

On 2016/12/14 19:54, David Sterba wrote:
> On Wed, Dec 07, 2016 at 04:55:15PM +0900, Tsutomu Itoh wrote:
>> The 'qgroup show' command does not synchronize filesystem.
>> Therefore, 'qgroup show' may not display the correct value unless
>> synchronized with 'filesystem sync' command etc.
>>
>> So add the '--sync' and '--no-sync' options so that we can choose
>> whether or not to synchronize when executing the command.
>>
>> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
>> ---
>> v2: use getopt_long with enum instead of single letter (suggested by Qu)
>> ---
>>  Documentation/btrfs-qgroup.asciidoc |  6 ++++++
>>  cmds-qgroup.c                       | 33 +++++++++++++++++++++++++++++----
>>  2 files changed, 35 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/btrfs-qgroup.asciidoc b/Documentation/btrfs-qgroup.asciidoc
>> index 438dbc7..9c65795 100644
>> --- a/Documentation/btrfs-qgroup.asciidoc
>> +++ b/Documentation/btrfs-qgroup.asciidoc
>> @@ -126,6 +126,12 @@ Prefix \'+' means ascending order and \'-' means descending order of <attr>.
>>  If no prefix is given, use ascending order by default.
>>  +
>>  If multiple <attr>s is given, use comma to separate.
>> ++
>> +--sync::::
>> +To retrieve information after updating the status of qgroups,
>> +invoke sync before getting information.
> 
> This could be more specific, that it's a filesystem sync.
> 
>> +--no-sync::::
>> +Do not invoke sync before getting information (default).
> 
> I'm not sure we need this option, how is it supposed to be used?

I made it to pair with --sync, but there is no use case in particular.
So, I would like to drop this with the next patch.

> 
>> @@ -311,8 +313,15 @@ static int cmd_qgroup_show(int argc, char **argv)
>>  
>>  	while (1) {
>>  		int c;
>> +		enum {
>> +			GETOPT_VAL_SORT = 256,
>> +			GETOPT_VAL_SYNC,
>> +			GETOPT_VAL_NO_SYNC
>> +		};
>>  		static const struct option long_options[] = {
>> -			{"sort", required_argument, NULL, 'S'},
>> +			{"sort", required_argument, NULL, GETOPT_VAL_SORT},
> 
> This change is unrelated to the patch, please make a separate patch for
> that.

OK. I'll separate this with the next patch.

Thanks,
Tsutomu

> 
> Otherwise looks good.
> 
>> +			{"sync", no_argument, NULL, GETOPT_VAL_SYNC},
>> +			{"no-sync", no_argument, NULL, GETOPT_VAL_NO_SYNC},
>>  			{ NULL, 0, NULL, 0 }
>>  		};
>>  


