Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:12803 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751703AbdIOCft (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Sep 2017 22:35:49 -0400
Subject: Re: [PATCH 1/2] btrfs-progs: build: generate all dependency files
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <150538384653.24503.41288304442819820.stgit@naota.dhcp.fujisawa.hgst.com>
 <20170914124108.GS29043@suse.cz>
From: Naohiro Aota <naohiro.aota@wdc.com>
Message-ID: <63173644-5453-ba53-2ca1-f3bdf49998bf@wdc.com>
Date: Fri, 15 Sep 2017 11:34:54 +0900
MIME-Version: 1.0
In-Reply-To: <20170914124108.GS29043@suse.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017年09月14日 21:41, David Sterba wrote:
> On Thu, Sep 14, 2017 at 07:10:46PM +0900, Naohiro Aota wrote:
>> We're missing several dependency files like:
>>
>> $ diff -u <(find -name '*.o'|cut -d. -f2|sort) <(find -name '*.o.d'|cut -d. -f2|sort)
>>    --- /proc/self/fd/11    2017-09-14 18:17:44.460564620 +0900
>>    +++ /proc/self/fd/12    2017-09-14 18:17:44.460564620 +0900
> 
> Please note that an actual diff in the changelog is understood as start
> of the patch by git-am, indenting the --- or +++ lines makes it work
> again.

Oops, I forgot about that limitation. Thank you for the fix.

> 
>> @@ -3,7 +3,6 @@
>>  /btrfs-corrupt-block
>>  /btrfs-debug-tree
>>  /btrfs-find-root
>> -/btrfs-list
>>  /btrfs-map-logical
>>  /btrfs-select-super
>>  /btrfstune
>> @@ -29,11 +28,6 @@
>>  /cmds-scrub
>>  /cmds-send
>>  /cmds-subvolume
>> -/convert/common
>> -/convert/main
>> -/convert/source-ext2
>> -/convert/source-fs
>> -/convert/source-reiserfs
>>  /ctree
>>  /dir-item
>>  /disk-io
>> <snip>
>>
>> This is due to moving things out of objects and cmds_objects variables. Such
>> missing dependency files cause mis-building of some source files (try touch
>> utils.h; make mkfs/main.o).
>>
>> This patch introduce a new variable "all_objects" to keep all the objects and
>> use the variable to generate proper dependency file building rules.
>>
>> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
> 
> Applied, thanks.
> 
