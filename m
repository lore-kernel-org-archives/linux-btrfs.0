Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:10259 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756274AbcKDCK3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Nov 2016 22:10:29 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 91D46AC0102
        for <linux-btrfs@vger.kernel.org>; Fri,  4 Nov 2016 11:10:23 +0900 (JST)
Subject: Re: [PATCH 3/3] btrfs-progs: send: fix handling of -c option
To: dsterba@suse.cz
References: <201610190235.AA00003@WIN-5MHF4RKU941.jp.fujitsu.com>
 <20161102122208.GD12522@twin.jikos.cz>
Cc: linux-btrfs@vger.kernel.org
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Message-ID: <9a097cab-48a5-9157-d7af-a56d5feac0b0@jp.fujitsu.com>
Date: Fri, 4 Nov 2016 11:10:05 +0900
MIME-Version: 1.0
In-Reply-To: <20161102122208.GD12522@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/11/02 21:22, David Sterba wrote:
> On Wed, Oct 19, 2016 at 11:35:40AM +0900, Tsutomu Itoh wrote:
>> When two or more -c options are specified, cannot find a suitable
>> parent. So, output stream is bigger than correct one.
>>
>> [before]
>> # btrfs send -f /tmp/data1 -c Snap0 -c ../SnapX Snap[12] ../SnapY
>> At subvol Snap1
>> At subvol Snap2
>> At subvol ../SnapY
>> # ls -l /tmp/data1
>> -rw------- 1 root root 3153 Oct 19 10:37 /tmp/data1
>> #
>>
>> [after]
>> # btrfs send -f /tmp/data1 -c Snap0 -c ../SnapX Snap[12] ../SnapY
>> At subvol Snap1
>> At subvol Snap2
>> At subvol ../SnapY
>> # ls -l /tmp/data1
>> -rw------- 1 root root 1492 Oct 19 10:39 /tmp/data1
>> #
> 
> Can you please create a test for that?

OK, I'll try to create a test case.

> 
>> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
>> ---
>>  cmds-send.c | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/cmds-send.c b/cmds-send.c
>> index 2a8a697..b93a667 100644
>> --- a/cmds-send.c
>> +++ b/cmds-send.c
>> @@ -651,6 +651,18 @@ int cmd_send(int argc, char **argv)
>>  		}
>>  
>>  		if (!full_send && root_id) {
>> +			ret = init_root_path(&send, subvol);
>> +			if (ret < 0)
>> +				goto out;
>> +
>> +			ret = get_root_id(&send,
>> +				subvol_strip_mountpoint(send.root_path, subvol),
>> +				&root_id);
>> +			if (ret < 0) {
>> +				error("cannot resolve rootid for %s", subvol);
>> +				goto out;
>> +			}
> 
> This duplicates the code that handles the '-c' option, please factori it
> toa helper function.

I will update the patch.

Thanks,
Tsutomu

> 
>> +
>>  			ret = find_good_parent(&send, root_id, &parent_root_id);
>>  			if (ret < 0) {
>>  				error("parent determination failed for %lld",
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

