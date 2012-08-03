Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from licorne.daevel.fr ([178.32.94.222]:41422 "EHLO
	licorne.daevel.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab2HCWl5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Aug 2012 18:41:57 -0400
Received: from luuna.daevel.fr ([82.67.37.138] helo=[192.168.1.50])
	by licorne.daevel.fr with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <btrfs.list@daevel.fr>)
	id 1SxQZA-0006KS-0J
	for linux-btrfs@vger.kernel.org; Sat, 04 Aug 2012 00:41:56 +0200
Message-ID: <501C53B7.30601@daevel.fr>
Date: Sat, 04 Aug 2012 00:41:59 +0200
From: Olivier Bonvalet <btrfs.list@daevel.fr>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:5038 (linux 3.4.7)
References: <501987FF.9080304@daevel.fr> <20120802132259.GO17430@twin.jikos.cz> <501A836F.90506@daevel.fr> <20120802135354.GQ17430@twin.jikos.cz> <501AA842.5080300@daevel.fr>
In-Reply-To: <501AA842.5080300@daevel.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/08/2012 18:18, Olivier Bonvalet wrote:
> On 02/08/2012 15:53, David Sterba wrote:
>> On Thu, Aug 02, 2012 at 03:41:03PM +0200, Olivier Bonvalet wrote:
>>> Yes... it's a copy from my /var/log/kern.log. Is it really "disabled" ?
>>
>> I was mistaken, it really is enabled unconditionally in ctree.h:55.
>> Josef says that the V0 extent refs are not used for a long time, so the
>> question is how did they appear in your filesystem. Did you switch to a
>> new kernel from a very old one?
>>
>>
>> david
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> mmm I have upgraded that system every two months, but the first setup is from april 2011 I think.
> 
> Should I start a "scrub" on all that systems installed a long time ago ?
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

So after a hard reboot that filesystem is not mountable anymore :

Aug  4 00:40:06 backup2 kernel: [  614.826124] device fsid a5dfe512-c8a3-46f0-bc8c-6365b8eccdcb devid 1 transid 110423 /dev/mapper/vg--backupplug-backup
Aug  4 00:40:06 backup2 kernel: [  614.827934] btrfs: force zlib compression
Aug  4 00:40:06 backup2 kernel: [  614.827943] btrfs: not using ssd allocation scheme
Aug  4 00:40:06 backup2 kernel: [  614.827950] btrfs: enabling auto recoveryparent transid verify failed on 615015833600 wanted 110423 found 110424
Aug  4 00:40:06 backup2 kernel: [  614.933613] parent transid verify failed on 615015833600 wanted 110423 found 110424
Aug  4 00:40:06 backup2 kernel: [  614.934700] btrfs read error corrected: ino 1 off 615015833600 (dev /dev/mapper/vg--backupplug-backup sector 1209083504)
Aug  4 00:40:06 backup2 kernel: [  614.934716] Failed to read block groups: -5
Aug  4 00:40:07 backup2 kernel: [  614.952684] btrfs: open_ctree failed


Is there something I can do to fix that ? (the mount option "recovery" didn't help here)

thanks,

Olivier
