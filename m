Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64419 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754750AbbG1Aex (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jul 2015 20:34:53 -0400
Subject: Re: [PATCH v2 10/10] btrfs-progs: Allow open_ctree use backup tree
 root or search it automatically if primary tree root is corrupted.
To: <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>
References: <1421649912-14539-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1421649912-14539-11-git-send-email-quwenruo@cn.fujitsu.com>
 <20150727150403.GG6306@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55B6CE2A.7010000@cn.fujitsu.com>
Date: Tue, 28 Jul 2015 08:34:50 +0800
MIME-Version: 1.0
In-Reply-To: <20150727150403.GG6306@suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2015/07/27 17:04 +0200:
> On Mon, Jan 19, 2015 at 02:45:12PM +0800, Qu Wenruo wrote:
>> Allow open_ctree to try its best to open tree root on damaged file system.
>>
>> With this patch, open_ctree will follow the below priority to read tree
>> root, providing better chance to open damaged btrfs fs.
>> 1) Using root bytenr in SB to read tree root
>> Normal routine if not specified to use backup roots or specified root
>> tree bytenr.
>>
>> 2) Using backup root if specified or 1) fails
>> Backup will be automatically used without user specification if
>> normal routine fails
>>
>> 3) Try to search possible tree root in all its metadata chunks
>> The last chance, searching through all the metadata space.
>> May takes a long time but still worth a try since above methods all
>> fails.
>
> I don't see this patch merged and there are no folowups. IIRC I had
> objections against the automatic behaviour but cannot find the
> discussion. Can we merge at least some bit of that patch? It does more
> than one thing so it would be better to split it.
>

I forgot this patchset again.
I must admit that I have a bad memory...

Yes, you were against the automatic use of backup root or especially 
iteration all metadata space to find the latest tree root.

I'll try to add a new option like "--full-scan" to enable the automatic 
search of all metadata space.

But I'm afraid it may be a little late as I'm recently debugging other 
things like in-band deduplication.

Thanks
Qu
