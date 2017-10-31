Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:54932 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752357AbdJaL3C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 07:29:02 -0400
Received: by mail-io0-f179.google.com with SMTP id e89so34216741ioi.11
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 04:29:02 -0700 (PDT)
Subject: Re: Problem with file system
To: Marat Khalili <mkh@rqc.ru>, Chris Murphy <lists@colorremedies.com>,
        Dave <davestechshop@gmail.com>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>,
        Fred Van Andel <vanandel@gmail.com>
References: <CAJyZh6S4f=6W+oA6DT1zu2FRuCgO7w8TfRzC96rPWNzUszvRmg@mail.gmail.com>
 <9871a669-141b-ac64-9da6-9050bcad7640@cn.fujitsu.com>
 <f6428a81-6fc8-1a73-0151-d13dd550c277@rqc.ru>
 <bb12a331-1fec-448a-cbf8-881b434766e7@cn.fujitsu.com>
 <CAJyZh6RxKuMukM-vCd=_u_8y38MJO_oUG1nYFpaxBroeK8xpAQ@mail.gmail.com>
 <CAH=dxU4OV6tQ0hCy_0Ug7eqkOM7HTUWTKjAr4qg+uO2gVxk2Jw@mail.gmail.com>
 <CAJCQCtS9BPZn-hnS+wP7Eu3oHQP_tS8EEM4j4FQDwRmzcFH+_A@mail.gmail.com>
 <10fb0b92-bc93-a217-0608-5284ac1a05cd@rqc.ru>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <b32358ec-781e-aff6-439b-3fc6fe02a25c@gmail.com>
Date: Tue, 31 Oct 2017 07:28:58 -0400
MIME-Version: 1.0
In-Reply-To: <10fb0b92-bc93-a217-0608-5284ac1a05cd@rqc.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-10-31 01:57, Marat Khalili wrote:
> On 31/10/17 00:37, Chris Murphy wrote:
>> But off hand it sounds like hardware was sabotaging the expected write
>> ordering. How to test a given hardware setup for that, I think, is
>> really overdue. It affects literally every file system, and Linux
>> storage technology.
>>
>> It kinda sounds like to me something other than supers is being
>> overwritten too soon, and that's why it's possible for none of the
>> backup roots to find a valid root tree, because all four possible root
>> trees either haven't actually been written yet (still) or they've been
>> overwritten, even though the super is updated. But again, it's
>> speculation, we don't actually know why your system was no longer
>> mountable.
> Just a detached view: I know hardware should respect ordering/barriers 
> and such, but how hard is it really to avoid overwriting at least one 
> complete metadata tree for half an hour (even better, yet another one 
> for a day)? Just metadata, not data extents.
If you're running on an SSD (or thinly provisioned storage, or something 
else which supports discards) and have the 'discard' mount option 
enabled, then there is no backup metadata tree (this issue was mentioned 
on the list a while ago, but nobody ever replied), because it's already 
been discarded.  This is ideally something which should be addressed (we 
need some sort of discard queue for handling in-line discards), but it's 
not easy to address.

Otherwise, it becomes a question of space usage on the filesystem, and 
this is just another reason to keep some extra slack space on the FS 
(though that doesn't help _much_, it does help).  This, in theory, could 
be addressed, but it probably can't be applied across mounts of a 
filesystem without an on-disk format change.
