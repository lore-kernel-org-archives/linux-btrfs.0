Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46980 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbbBRDEa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Feb 2015 22:04:30 -0500
Message-ID: <54E40143.3000300@oracle.com>
Date: Wed, 18 Feb 2015 11:04:35 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH 23/24] Btrfs: sysfs: support seed devices in the sysfs
 layout
References: <1423439785-10260-1-git-send-email-anand.jain@oracle.com> <1423439785-10260-24-git-send-email-anand.jain@oracle.com> <20150211185259.GM28877@twin.jikos.cz> <54DC475C.4000002@oracle.com> <20150213175102.GN8720@twin.jikos.cz>
In-Reply-To: <20150213175102.GN8720@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


[guihc.fnst@cn.fujitsu.com
  bounced removing the email id from the cc-list].

Dave,

here is the patch list for Oct.
   https://patchwork.kernel.org/project/linux-btrfs/list/?page=7
v2 isn't there. I am confused.

Anyway if btrfs-progs integration-20150213
contained V2. I am on it now. And I still see the problem.

----------------------
btrfs fi show <-- on a nested seed fs
warning devid 1 not found already  <---
warning devid 2 not found already  <---
bytenr mismatch, want=4194304, have=0 <----
Label: none  uuid: fce49239-b392-4e4d-b775-57dca7f2426b
	Total devices 1 FS bytes used 28.00KiB
	devid    1 size 967.86MiB used 12.00MiB path /dev/sdb

Label: none  uuid: bccc7c86-82ff-4f2c-805a-4d384642f5e6
	Total devices 2 FS bytes used 92.00KiB
	devid    1 size 967.86MiB used 8.00MiB path /dev/sdb
	devid    2 size 967.87MiB used 144.00MiB path /dev/sdc

Label: none  uuid: 6ea26ac0-b4e9-4a56-9079-67d25a57ac27
	Total devices 3 FS bytes used 156.00KiB
	devid    3 size 1.52GiB used 224.00MiB path /dev/sdd
	*** Some devices missing

btrfs-progs v3.19-rc2-68-gd4bf1cc
--------------------------

Can you pls revert this patch for now ?


Thanks, Anand



On 02/14/2015 01:51 AM, David Sterba wrote:
> On Thu, Feb 12, 2015 at 02:25:32PM +0800, Anand Jain wrote:
>> Since we are on this topic: btrfs-progs shouldn't have had this patch:
>>      git log -p 2513077
>> -------------------------
>> commit 2513077f2f830b4bc83d528bfb6979eb461918bd
>> Author: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
>> Date:   Mon Oct 6 18:16:46 2014 +0800
>>
>>       btrfs-progs: fix device missing of btrfs fi show with seed devices
>> -------------------------
>>
>> it doesn't work with nested seed as I commented
>>     http://marc.info/?l=linux-btrfs&m=141102300324251&w=2
>> -------------------------
>>     btrfs fi show -d
>> warning devid 1 not found already
>> warning devid 2 not found already
>> Check tree block failed, want=29425664, have=0
>> read block failed check_tree_block
>> Couldn't setup csum tree
>> Check tree block failed, want=29360128, have=0
>> read block failed check_tree_block
>> -------------------------
>>
>> I haven't see next version of this patch from Gui. (Gui ?, copied)
>
> The fixed version was "[PATCH v2 3/3] btrfs-progs: fix device missing of
> btrfs fi show with seed devices"
>
> http://article.gmane.org/gmane.comp.file-systems.btrfs/39186/
>
> and that's what I have merged.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
