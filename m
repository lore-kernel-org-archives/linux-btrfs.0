Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58109 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab2ISIcG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Sep 2012 04:32:06 -0400
Received: from m2.gw.fujitsu.co.jp (unknown [10.0.50.72])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 008A83EE0C3
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 17:32:03 +0900 (JST)
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id D820D45DE4E
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 17:32:02 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id C275045DE4D
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 17:32:02 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id AF25A1DB803F
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 17:32:02 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 664B11DB803E
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 17:32:02 +0900 (JST)
Received: from ml14.css.fujitsu.com (ml14 [127.0.0.1])
	by ml14.s.css.fujitsu.com (Postfix) with ESMTP id 3E8229F78F3
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 17:32:02 +0900 (JST)
Received: from [127.0.0.1] (unknown [10.124.101.112])
	by ml14.s.css.fujitsu.com (Postfix) with ESMTP id E21F39F78DF
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 17:32:01 +0900 (JST)
Message-ID: <505982DD.8030408@jp.fujitsu.com>
Date: Wed, 19 Sep 2012 17:31:25 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: make space to keep default mount options
References: <5057CDA7.3090201@jp.fujitsu.com> <5057CE50.1050706@jp.fujitsu.com> <20120918121035.GZ17430@twin.jikos.cz>
In-Reply-To: <20120918121035.GZ17430@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2012/09/18 21:10), David Sterba wrote:
> On Tue, Sep 18, 2012 at 10:28:48AM +0900, Hidetoshi Seto wrote:
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index fa5c45b..3eb0551 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -458,8 +458,11 @@ struct btrfs_super_block {
>>  
>>  	__le64 cache_generation;
>>  
>> +	/* default mount options */
>> +	unsigned long default_mount_opt;
> 
> you need to use __le64 here, unsigned long has not fixed size

Indeed. I'll use __le64 next time.

>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index e239915..7ef4a2e 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -340,6 +340,8 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>>  	char *compress_type;
>>  	bool compress_force = false;
>>  
>> +	info->mount_opt = info->super_copy->default_mount_opt;
> 
> the options have to respect some priority, eg. when I set default
> options to a filesystem, but mount with a different set, I expect that
> the explicit flags apply and override the defaults.
> 
> I don't remember if this was discussed in the mailinglist or on IRC
> only, should be easy to dig up if needed.

At least I don't know whether this was already disscussed or not.
Now my code gives priority to the default options, and it would not
be so difficult in case if we have opposing options like "ssd" vs
"nossd", and "space_cache" vs "no_space_cache"...
Or we could use the default options only if there is no options
specified when it is being mount, but it will make the default
options useless. Humm, I'll try to pull together my thoughts
prior to my next post.

Thanks,
H.Seto

