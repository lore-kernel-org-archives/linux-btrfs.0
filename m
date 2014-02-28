Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:61648 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbaB1HjD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Feb 2014 02:39:03 -0500
Received: by mail-pb0-f50.google.com with SMTP id md12so408062pbc.23
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Feb 2014 23:39:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CE569C8-14AE-4C71-A2CC-FF8DB455460A@colorremedies.com>
References: <CAAmRLYx1L=o7a2PMSAiJbr7qH_JiuYG2-ncHG-mHLyLcM3Z-GQ@mail.gmail.com>
	<519E70A2-FA6F-41A3-9639-2C2BB965975E@colorremedies.com>
	<4CE569C8-14AE-4C71-A2CC-FF8DB455460A@colorremedies.com>
Date: Fri, 28 Feb 2014 01:39:02 -0600
Message-ID: <CAAmRLYxy_PDveh=iNg-s6Zoq1YJfAJeTZb+b6G6vuQWNFrMBVQ@mail.gmail.com>
Subject: Re: Help with space
From: Justin Brown <otakujunction@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Apologies for the late reply, I'd assumed the issue was closed even
given the unusual behavior.  My mount options are:

/dev/sdb1 on /var/lib/nobody/fs/ubfterra type btrfs
(rw,noatime,nodatasum,nodatacow,noacl,space_cache,skip_balance)

I only recently added nodatacow and skip_balance in an attempt to
figure out where the missing space had gone.  I don't know what impact
it might have if any on things.  I've got a full balance running at
the moment which, after about a day or so, has managed to process 5%
of the chunks it's considering (988 out of about 18396 chunks balanced
(989 considered),  95% left).  The amount of free space has vacillated
slightly, growing by about a gig to shrink back.  As far as objects in
the file system missing, I've not seen any such.  I've a lot of files
of various data types, the majority is encoded japanese animation.
Since I actually play these files via samba from a htpc, particularly
the more recent additions, I'd hazard to guess that if something were
breaking I'd have tripped across it by now, the unusual used to free
space delta being the exception.  My brother also uses this raid for
data storage, he's something of a closet meteorologist and is
fascinated by tornadoes.  He hasn't noticed any unusual behavior
either.  I'm in the process of sourcing a 64 bit capable system in the
hopes that will resolve the issue.  Neither of us are currently
writing anything to the file system for fear of things breaking, but
both have been reading from it without issue other than the noticeable
impact in performance balance seems to be having.  Thanks for the
help.

-Justin


On Fri, Feb 28, 2014 at 12:26 AM, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Feb 27, 2014, at 11:13 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
>>
>> On Feb 27, 2014, at 11:19 AM, Justin Brown <otakujunction@gmail.com> wrote:
>>
>>> terra:/var/lib/nobody/fs/ubfterra # btrfs fi df .
>>> Data, single: total=17.58TiB, used=17.57TiB
>>> System, DUP: total=8.00MiB, used=1.93MiB
>>> System, single: total=4.00MiB, used=0.00
>>> Metadata, DUP: total=392.00GiB, used=33.50GiB
>>> Metadata, single: total=8.00MiB, used=0.00
>>
>> After glancing at this again, what I thought might be going on might not be going on. The fact it has 17+TB already used, not merely allocated, doesn't seem possible if there's a hard 16TB limit for Btrfs on 32-bit kernels.
>>
>> But then I don't know why du -h is reporting only 13T total used. And I'm unconvinced this is a balance issue either. Is anything obviously missing from the file system?
>
> What are your mount options? Maybe compression?
>
> Clearly du is calculating things differently. I'm getting:
>
> du -sch = 4.2G
> df -h    = 5.4G
> btrfs df  = 4.7G data and 620MB metadata(total).
>
> I am using compress=lzo.
>
> Chris Murphy
>
