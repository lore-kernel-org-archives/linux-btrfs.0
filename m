Return-Path: <SRS0=ihwP=S6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E051DC43218
	for <linux-btrfs@archiver.kernel.org>; Sun, 28 Apr 2019 19:27:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B245C206A3
	for <linux-btrfs@archiver.kernel.org>; Sun, 28 Apr 2019 19:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbfD1T1V convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 28 Apr 2019 15:27:21 -0400
Received: from smtprelay06.ispgateway.de ([80.67.18.29]:12380 "EHLO
        smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfD1T1V (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Apr 2019 15:27:21 -0400
Received: from [94.217.144.7] (helo=[192.168.177.20])
        by smtprelay06.ispgateway.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <hendrik@friedels.name>)
        id 1hKpSG-00009R-Pl; Sun, 28 Apr 2019 21:27:16 +0200
From:   "Hendrik Friedel" <hendrik@friedels.name>
To:     "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        "Qu Wenruo" <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Subject: Re[2]: btrfs and write barriers
Date:   Sun, 28 Apr 2019 19:27:16 +0000
Message-Id: <emf90f6f49-9542-47ad-aad7-7ed271887782@ryzen>
In-Reply-To: <9e438df4-f477-9aac-103b-fea479caacc9@gmail.com>
References: <emae84cb43-e9f5-41a7-8a47-efca08cea36e@laptophendrik>
 <05127205-0d35-1028-559e-66ba2b1dcea1@gmx.com>
 <em07dd5637-7710-4eaa-8659-8d8eef1fc709@ryzen>
 <9e438df4-f477-9aac-103b-fea479caacc9@gmail.com>
Reply-To: "Hendrik Friedel" <hendrik@friedels.name>
User-Agent: eM_Client/7.2.34062.0
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Df-Sender: aGVuZHJpa0BmcmllZGVscy5uYW1l
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,
thanks for your reply.

 >>3) Even more, it would be good, if btrfs would disable the write cache
 >> in that case, so that one does not need to rely on the user
 >
 >Personally speaking, if user really believes it's write cache causing
 >the problem or want to be extra safe, then they should disable cache.
How many percent of the users will be able to judge that?

 >As long as FLUSH is implemented without problem, the only faulty part 
is
 >btrfs itself and I haven't found any proof of either yet.
But you have searched?

 >>2) I find the location of the (only?) warning -dmesg- well hidden. I 
think it would be better to notify the user when creating the 
file-system.
 >A notification on creating the volume and ones when adding devices 
(either via `device add` or via a replace operation)
 >would indeed be nice, but we should still keep the kernel log warning.

Ok, so what would be the way to move forward on that? Would it help if I 
create an issue in a https://bugzilla.kernel.org/ ?

 >>3) Even more, it would be good, if btrfs would disable the write cache 
in that case, so that one does not need to rely on the user
 > I would tend to disagree here. We should definitely _recommend_ this 
to the user if we know there is no barrier support, but just
 > doing it behind their back is not a good idea.

Well, there is some room between 'automatic' and 'behind their back. 
E.g.
"Barriers are not supported by /dev/sda. Automatically disabling 
write-cache on mount. You can suppress this with the 
'enable-cache-despite-no-barrier-support-I-know-what-I-am-doing' mount 
option (maybe, we can shorten the option).

 > There are also plenty of valid reasons to want to use the write cache 
anyway.

I cannot think of one. Who would sacrifice data integrity/potential 
total loss of the filesystem for speed?

 > As far as FUA/DPO, I know of exactly _zero_ devices that lie about 
implementing it and don't.
...
 > but the fact that Linux used to not issue a FLUSH command to the disks 
when you called fsync in userspace.

Ok, thanks for that clarification.


Greetings,
Hendrik

------ Originalnachricht ------
Von: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
An: "Hendrik Friedel" <hendrik@friedels.name>; "Qu Wenruo" 
<quwenruo.btrfs@gmx.com>; linux-btrfs@vger.kernel.org
Gesendet: 03.04.2019 20:44:09
Betreff: Re: btrfs and write barriers

>On 2019-04-03 14:17, Hendrik Friedel wrote:
>>Hello,
>>
>>thanks for your reply.
>>
>>>>3) Even more, it would be good, if btrfs would disable the write cache
>>>>in that case, so that one does not need to rely on the user
>>>Personally speaking, if user really believes it's write cache causing
>>>the problem or want to be extra safe, then they should disable cache.
>>How many percent of the users will be able to judge that?
>>>As long as FLUSH is implemented without problem, the only faulty part is
>>>btrfs itself and I haven't found any proof of either yet.
>>But you have searched?
>>
>>  >>2) I find the location of the (only?) warning -dmesg- well hidden. I think it would be better to notify the user when creating the file-system.
>>  >A notification on creating the volume and ones when adding devices (either via `device add` or via a replace operation)
>>  >would indeed be nice, but we should still keep the kernel log warning.
>>
>>Ok, so what would be the way to move forward on that? Would it help if I create an issue in a https://bugzilla.kernel.org/ ?
>The biggest issue is actually figuring out if the devices don't support write barriers (which means no FLUSH or broken FLUSH on Linux, not no FUA/DPO, because as long as the device properly implements FLUSH (and most do), Linux will provide a FUA emulation which works for write barriers).  Once you've got that, it should be pretty trivial to add to the messages.
>>
>>  >>3) Even more, it would be good, if btrfs would disable the write cache in that case, so that one does not need to rely on the user
>>  > I would tend to disagree here. We should definitely _recommend_ this to the user if we know there is no barrier support, but just
>>  > doing it behind their back is not a good idea.
>>
>>Well, there is some room between 'automatic' and 'behind their back. E.g.
>>"Barriers are not supported by /dev/sda. Automatically disabling write-cache on mount. You can suppress this with the 'enable-cache-despite-no-barrier-support-I-know-what-I-am-doing' mount option (maybe, we can shorten the option).
>And that's still 'behind the back' because it's a layering violation. Even LVM and MD don't do this, and they have even worse issues than we do because they aren't CoW.
>>
>>  > There are also plenty of valid reasons to want to use the write cache anyway.
>>I cannot think of one. Who would sacrifice data integrity/potential total loss of the filesystem for speed?
>There are quite a few cases where the risk of data loss _just doesn't matter_, and any data that could be invalid is also inherently stale. Some trivial examples:
>
>* /run on any modern Linux system. Primarily contains sockets used by running services, PID files for daemons, and other similar things that only matter for the duration of the current boot of the system. These days, it's usually in-memory, but some people with really tight memory constraints still use persistent storage for it to save memory.
>* /tmp on any sane UNIX system. Similar case to above, but usually for stuff that only matters on the scale of session lifetimes, or even just process lifetimes.
>* /var/tmp on most Linux systems. Usually the same case as /tmp.
>* /var/cache on any sane UNIX system. By definition, if the data here is lost, it doesn't matter, as it only exists for performance reasons anyway. Smart applications will even validate the files they put here, so corruption isn't an issue either.
>
>There are bunches of other examples I could list, but all of them are far more situational and application specific.
>>
>>  > As far as FUA/DPO, I know of exactly _zero_ devices that lie about implementing it and don't.
>>...
>>  > but the fact that Linux used to not issue a FLUSH command to the disks when you called fsync in userspace.
>>Ok, thanks for that clarification.

