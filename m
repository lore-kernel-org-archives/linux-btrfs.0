Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64876 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751121AbaEHBjH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 21:39:07 -0400
Message-ID: <536AE073.2070307@cn.fujitsu.com>
Date: Thu, 8 May 2014 09:40:03 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: doc: link btrfsck to btrfs-check
References: <20140416171219.GC29256@twin.jikos.cz> <1397668577-846-1-git-send-email-dsterba@suse.cz> <534F24A0.5000304@cn.fujitsu.com> <20140418144801.GG29256@suse.cz>
In-Reply-To: <20140418144801.GG29256@suse.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH] btrfs-progs: doc: link btrfsck to btrfs-check
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年04月18日 22:48
> On Thu, Apr 17, 2014 at 08:47:28AM +0800, Qu Wenruo wrote:
>>> @@ -73,6 +74,7 @@ install: install-man
>>>   install-man: man
>>>   	$(INSTALL) -d -m 755 $(DESTDIR)$(man8dir)
>>>   	$(INSTALL) -m 644 $(GZ_MAN8) $(DESTDIR)$(man8dir)
>>> +	$(LNS) btrfs-check.txt $(DESTDIR)$(man8dir)
>> Shouldn't the source of soft link be btrfs-check.8.gz. ?
Forgot to mention that the dest is also wrong. This will make 
$(DESTDIR)$(man8dir)/btrfs-check.8.gz to be a
infinite loop(pointing to it self).
The correct one should be like the following:
+       $(LNS) btrfs-check.8.gz $(DESTDIR)$(man8dir)/btrfsck.8.gz

Thanks,
Qu

>>> @@ -47,4 +49,3 @@ SEE ALSO
>>>   `mkfs.btrfs`(8),
>>>   `btrfs-scrub`(8),
>>>   `btrfs-rescue`(8)
>>> -`btrfsck`(8)
>> Sorry to bother you but 'btrfs-scrub'/'btrfs-rescue' and 'btrfs-restore'
>> seems also metioning 'btrfsck' and may also needs to remove 'btrfsck'.
> Thanks for catching them, I'll fix it up.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

